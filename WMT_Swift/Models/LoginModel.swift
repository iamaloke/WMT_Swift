//
//  LoginModel.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
}
