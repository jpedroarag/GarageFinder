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
    var closeAction: (() -> Void)?
    lazy var scrollView = UIScrollView()
    
    lazy var gfIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "iconLogin"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var emailTextField: GFTextField = {
        let textfield = GFTextField()
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        textfield.placeholder = "Email"
        textfield.setStyle()
        return textfield
    }()
    
    lazy var passwordTextField: GFTextField = {
        let textfield = GFTextField()
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
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitle("Não tem conta? Cadastre-se!", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    var keyScroller: KeyScroller?
    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([scrollView, closeButton])
        scrollView.addSubviews([gfIconImageView, emailTextField, passwordTextField, submitButton, signUpButton])
        setupConstraints()
        
        submitButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonPress), for: .touchUpInside)
        
        keyScroller = KeyScroller(withScrollView: scrollView)
    }
    
    func setKeyScroller(enabled: Bool) {
        keyScroller = enabled ? KeyScroller(withScrollView: scrollView) : nil
    }
    
    func setupConstraints() {
        closeButton.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .width(constant: 24)
            .height(constant: 24)
        scrollView.anchor
            .top(safeAreaLayoutGuide.topAnchor)
            .left(safeAreaLayoutGuide.leftAnchor)
            .right(safeAreaLayoutGuide.rightAnchor)
            .bottom(safeAreaLayoutGuide.bottomAnchor)
        gfIconImageView.anchor
            .top(scrollView.topAnchor, padding: 48)
            .centerX(centerXAnchor)
            .left(scrollView.leftAnchor, padding: 64)
            .right(scrollView.rightAnchor, padding: 64)
            .height(constant: 150)
        emailTextField.anchor
            .top(gfIconImageView.bottomAnchor, padding: 32)
            .left(scrollView.leftAnchor, padding: 16)
            .right(scrollView.rightAnchor, padding: 16)
            .height(constant: 40)
        passwordTextField.anchor
            .top(emailTextField.bottomAnchor, padding: 24)
            .left(scrollView.leftAnchor, padding: 16)
            .right(scrollView.rightAnchor, padding: 16)
            .height(constant: 40)
        submitButton.anchor
            .top(passwordTextField.bottomAnchor, padding: 32)
            .left(scrollView.leftAnchor, padding: 16)
            .right(scrollView.rightAnchor, padding: 16)
            .height(constant: 60)
        signUpButton.anchor
            .top(submitButton.bottomAnchor, padding: 16)
            .left(scrollView.leftAnchor, padding: 16)
            .right(scrollView.rightAnchor, padding: 16)
            .bottom(scrollView.bottomAnchor, padding: 16)
    }
    
    @objc func loginButtonPress() {
        loginAction?(emailTextField.text ?? "", passwordTextField.text ?? "")
    }
    @objc func signUpButtonPress() {
        signUpAction?()
    }
    
    @objc func closeButtonPress() {
        closeAction?()
    }
}
