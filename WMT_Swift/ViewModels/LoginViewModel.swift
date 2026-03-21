//
//  LoginViewModel.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import Foundation

final class LoginViewModel {
    
    // MARK: - Bindings (Outputs)
    var onLoading: ((Bool) -> Void)?
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
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
    
    func login(email: String, password: String) {
        
    }
}
