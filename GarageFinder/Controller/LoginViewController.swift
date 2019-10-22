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
        loginView.action = loginAction(email:password:)
    }

    func loginAction(email: String, password: String) {
        print(email, password)
        
        let userAuth = UserAuth(auth: Credentials(email: email, password: password))
        let provider = URLSessionProvider()
        provider.request(.post(userAuth)) { result in
            switch result {
            case .success(let response):
                if let token = response.jwt {
                    UserDefaults.standard.set(token, forKey: "Token")
                    provider.request(.get(User.self, isCurrent: true)) { result in
                        switch result {
                        case .success(let response):
                            if let userId = response.result?.id {
                                UserDefaults.standard.set(userId, forKey: "LoggedUserId")
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        case .failure(let error):
                            print("Error get current user: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error on login: \(error)")
            }
        }
    }
}
