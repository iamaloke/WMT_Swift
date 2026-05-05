//
//  LoginVC.swift
//  WMT_Swift
//
//  Created by aloksingh on 22/03/26.
//

import UIKit

class LoginVC: UIViewController {
    
    private let viewModel = LoginViewModel(apiService: NetworkManager())

    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }

    @IBAction private func didTapOnLogin(_ sender: UIButton) {
        sender.isEnabled = false
        
        Task { [weak self] in
            guard let self else { return }
            await self.viewModel.login(email: emailTF.text, password: passwordTF.text)
            sender.isEnabled = true
        }
    }
    
    private func setup() {
        emailTF.delegate = self
        emailTF.addTarget(self, action: #selector(textInputChanged(_:)), for: .editingChanged)
        passwordTF.delegate = self
        passwordTF.addTarget(self, action: #selector(textInputChanged(_:)), for: .editingChanged)
        loginBTN.isEnabled = false
    }
    
    private func bindViewModel() {
//        viewModel.onLoading = { isLoading in
//            print("Loading: \(isLoading)")
//            // show/hide loader
//        }
//
//        viewModel.onSuccess = { token in
//            print("Login success: \(token)")
//            // navigate to next screen
//        }
//
//        viewModel.onError = { message in
//            print("Error: \(message)")
//            // show alert
//        }
        
        viewModel.onLoadingStateChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .idle:
                break
            case .loading(let message):
                self.showActivity(message: message)
            case .finished:
                self.hideActivity()
            }
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func textInputChanged(_ textField: UITextField) {
        loginBTN.isEnabled = viewModel.validate(emailTF.text, passwordTF.text)
    }
}

extension LoginVC: ActivityIndicatable {}
