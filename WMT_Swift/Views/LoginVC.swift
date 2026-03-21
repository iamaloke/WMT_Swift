//
//  LoginVC.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import UIKit

class LoginVC: UIViewController {
    
    private let viewModel = LoginViewModel()

    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        loginBTN.isEnabled = false
        bindViewModel()
    }

    @IBAction private func didTapOnLogin(_ sender: UIButton) {
    }
    
    private func bindViewModel() {
        viewModel.onLoading = { isLoading in
            print("Loading: \(isLoading)")
            // show/hide loader
        }
        
        viewModel.onSuccess = { token in
            print("Login success: \(token)")
            // navigate to next screen
        }
        
        viewModel.onError = { message in
            print("Error: \(message)")
            // show alert
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loginBTN.isEnabled = viewModel.validate(emailTF.text, passwordTF.text)
    }
}
