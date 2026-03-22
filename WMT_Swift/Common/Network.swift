//
//  Network.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum APPError: Error {
    case invalidResponse
    case noData
    case decodingError
}

enum Network {
    enum URL: String {
        case login = "https://reqres.in/api/login"
        case register = "https://reqres.in/api/register"
        case logout = "https://reqres.in/api/logout"
    }
}

protocol APIService {
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T
}

struct Endpoint<T: Decodable> {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
    
    var urlRequest: URLRequest {
        var allHeaders = headers ?? [:]
        allHeaders["Content-Type"] = "application/json"
        allHeaders["x-api-key"] = Constants.reqresApiKey
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = allHeaders
        request.httpBody = body
        return request
    }
}

final class NetworkManager: APIService {
    func request<T>(_ endpoint: Endpoint<T>) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw APPError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APPError.decodingError
        }
    }
}
