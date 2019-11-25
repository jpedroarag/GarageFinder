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
    
    weak var parkingStatusDelegate: ParkingStatusDelegate!
    
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
                        self.getCurrentUser(playerId: UserDefaults.playerId)
                        DispatchQueue.main.async {
                            self.updateMapSettings()
                            self.parkingStatusDelegate.loadData(fromLogin: true)
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
    func getCurrentUser(playerId: String) {
        if UserDefaults.userIsLogged {
            URLSessionProvider().request(.get(User.self, id: UserDefaults.loggedUserId)) { result in
                switch result {
                case .success(let response):
                    if let user = response.result {
                        if user.playerId != playerId {
                            print("Are different!")
                            self.updateUser(playerId: playerId)
                        } else {
                            print("Are Equals!")
                        }
                    }
                case .failure(let error):
                    print("Error on get user: \(error)")
                }
            }
        }
    }
    
    func updateUser(playerId: String) {
        let user = User(id: UserDefaults.loggedUserId, playerId: playerId)
        URLSessionProvider().request(.update(user)) { result in
            switch result {
            case .success(let response):
                print("Sucess update user playerID: \(response)")
            case .failure(let error):
                print("Error on get user: \(error)")
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
        signUpVC.parkingStatusDelegate = parkingStatusDelegate
        signUpVC.finishSignUpDelegate = self
        present(signUpVC, animated: true, completion: nil)
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateMapSettings() {
        NotificationCenter.default.post(name: .mapOptionSettingDidChange, object: nil)
        NotificationCenter.default.post(name: .trafficSettingDidChange, object: nil)
    }

}

extension LoginViewController: FinishSignUpDelegate {
    func didFinishSignUp() {
        loginView.setKeyScroller(enabled: true)
    }
}
