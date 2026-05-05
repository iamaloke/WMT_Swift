//
//  LoginViewModel.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import Foundation

enum LoadingState {
    case idle
    case loading(message: String)
    case finished
}

final class LoginViewModel {
    
    // MARK: - Bindings (Outputs)
    var onLoadingStateChange: ((LoadingState) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Network Manager
    var networkManager: APIService
    
    init(apiService: APIService) {
        self.networkManager = apiService
    }
    
    func validate(_ email: String?, _ password: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            onError?("Email is required")
            return false
        }
        
        guard isValidEmail(email) else {
            onError?("Email is not valid")
            return false
        }
        
        guard let password = password, !password.isEmpty else {
            onError?("Password is required")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func login(email: String?, password: String?) async {
        guard let email, let password, validate(email, password) else {
            return
        }
        
        onLoadingStateChange?(.loading(message: "Logging in..."))
        defer {
            onLoadingStateChange?(.finished)
            onLoadingStateChange?(.idle)
        }
        
        do {
            let data = try JSONEncoder().encode(LoginRequest(email: "eve.holt@reqres.in", password: "cityslicka"))
            let endpoint = Endpoint<LoginResponse>(path: Network.URL.login.rawValue, method: .post, headers: ["x-api-key": Constants.reqresApiKey], body: data)
            let response = try await networkManager.request(endpoint)
            print("response: \(response)")
            onSuccess?("Success")
        } catch let error as APPError {
            handleError(error)
        } catch {
            onError?("Something went wrong. Please try again.")
        }
    }
    
    private func handleError(_ error: APPError) {
        switch error {
        case .invalidResponse:
            onError?("Invalid server response")
        case .noData:
            onError?("No data received")
        case .decodingError:
            onError?("Failed to process data")
        }
    }
}
