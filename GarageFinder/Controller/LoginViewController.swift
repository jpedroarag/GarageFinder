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
    
    override func viewDidLoad() {
        view = loginView
        loginView.loginAction = loginAction(email:password:)
        loginView.signUpAction = signUpAction
    }

    func loginAction(email: String, password: String) {
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
                    
                    provider.request(.getCurrent(User.self)) { result in
                        switch result {
                        case .success(let response):
                            if let user = response.result {
                                print("Current user: \(user)")
                            }
                        case .failure(let error):
                            print("Error getting current user: \(error)")
                        }
                    }
                    
                }
            case .failure(let error):
                print("Error on login: \(error)")
            }
        }
    }
    
    func signUpAction() {
        present(SignUpViewController(), animated: true, completion: nil)
    }
}
