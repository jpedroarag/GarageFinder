//
//  LoginViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 21/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class LoginViewController: UIViewController {
    let loginView = LoginView()
    var validator: FieldValidator!
    override func viewDidLoad() {
        view = loginView
        loginView.loginAction = loginAction(email:password:)
        loginView.signUpAction = signUpAction
        loginView.closeAction = closeAction
        view.addGestureRecognizer(view.tap)
    }
    
    func loginAction(email: String, password: String) {
        let strategies: [ValidationStrategy] = [EmailValidationStrategy(), EmptyStrategy()]
        validator = FieldValidator(andStrategies: strategies)
        let isEmailRight = validator.validate(elements: loginView.emailTextField, withStrategy: EmailValidationStrategy.self)
        let isNoEmpty = validator.validate(elements: loginView.passwordTextField, withStrategy: EmptyStrategy.self)
        let hasNoWarning = isEmailRight && isNoEmpty
        
        if hasNoWarning {
            let userAuth = UserAuth(email: email, password: password)
            let provider = URLSessionProvider()
            provider.request(.post(userAuth)) { result in
                switch result {
                case .success(let response):
                    if let userAuth = response.result {
                        print("TOKEN: \(userAuth.token ?? "")")
                        UserDefaults.standard.set(userAuth.token, forKey: "Token")
                        UserDefaults.standard.set(userAuth.exp, forKey: "ExpToken")
                        UserDefaults.standard.set(userAuth.userId, forKey: "LoggedUserId")
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print("Error on login: \(error)")
                    self.showErrorAlert()
                }
            }
        }
    }
    
    func showErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Erro ao logar", message: "Credenciais incorretas", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func signUpAction() {
        loginView.setKeyScroller(enabled: false)
        let signUpVC = SignUpViewController()
        signUpVC.finishSignUpDelegate = self
        present(signUpVC, animated: true, completion: nil)
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }

}

extension LoginViewController: FinishSignUpDelegate {
    func didFinishSignUp() {
        loginView.setKeyScroller(enabled: true)
    }
}
