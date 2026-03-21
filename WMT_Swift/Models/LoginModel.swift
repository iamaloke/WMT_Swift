//
//  LoginModel.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}
