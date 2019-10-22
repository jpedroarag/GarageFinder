//
//  LoginView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 21/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var action: ((_ email: String, _ password: String) -> Void)?
    
    lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        textfield.placeholder = "Email"
        textfield.borderStyle = .none
        textfield.backgroundColor = .white
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.textFieldBorderGray.cgColor
        textfield.layer.cornerRadius = 5
        textfield.clipsToBounds = true
        return textfield
    }()
    
    lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "Senha"
        textfield.borderStyle = .none
        textfield.backgroundColor = .white
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.textFieldBorderGray.cgColor
        textfield.layer.cornerRadius = 5
        textfield.clipsToBounds = true
        return textfield
    }()
    
    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Logar", for: .normal)
        return button
    }()
    
    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([emailTextField, passwordTextField, submitButton])
        setupConstraints()
        
        submitButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    func setupConstraints() {
        emailTextField.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 32)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 32)
        passwordTextField.anchor
            .top(emailTextField.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 32)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 32)
        submitButton.anchor
            .top(passwordTextField.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
    }
    
    @objc func loginAction() {
        action?(emailTextField.text ?? "", passwordTextField.text ?? "")
    }
}
