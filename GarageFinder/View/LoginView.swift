//
//  LoginView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 21/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var loginAction: ((_ email: String, _ password: String) -> Void)?
    var signUpAction: (() -> Void)?
    lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        textfield.placeholder = "Email"
        textfield.setStyle()
        return textfield
    }()
    
    lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "Senha"
        textfield.setStyle()
        return textfield
    }()
    
    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Logar", for: .normal)
        return button
    }()
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Não tem conta? Cadastre-se!", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([emailTextField, passwordTextField, submitButton, signUpButton])
        setupConstraints()
        
        submitButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
    }
    
    func setupConstraints() {
        emailTextField.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 32)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 32)
            .height(constant: 40)
        passwordTextField.anchor
            .top(emailTextField.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 32)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 32)
            .height(constant: 40)
        submitButton.anchor
            .top(passwordTextField.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
        signUpButton.anchor
            .top(submitButton.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
    }
    
    @objc func loginButtonPress() {
        loginAction?(emailTextField.text ?? "", passwordTextField.text ?? "")
    }
    @objc func signUpButtonPress() {
        signUpAction?()
    }
}
