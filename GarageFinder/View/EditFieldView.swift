//
//  EditFieldView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
class EditFieldView: UIView {
    typealias Action = () -> Void
    let type: TextFieldType
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightBlue
        return label
    }()
    
    lazy var textField: GFTextField = {
        let textField = GFTextField(withType: .none)
        return textField
    }()
    
    lazy var newPassword: GFTextField = {
        let textField = GFTextField(withType: .none)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var confirmPassword: GFTextField = {
        let textField = GFTextField(withType: .none)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Salvar", for: .normal)
        return button
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }()
        
    var submitButtonAction: Action?
    var closeButtonAction: Action?
    
    init(fieldType: TextFieldType) {
        self.type = fieldType
        super.init(frame: .zero)
        titleLabel.text = fieldType.rawValue
        textField.setUpType(type: fieldType)
        setupBlurView()
        addSubview(contentView)
        contentView.addSubviews([titleLabel, textField, submitButton, closeButton])
        setupPassword()
        setupConstraints()
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func setupPassword() {
        if type == .password {
            textField.placeholder = "Senha atual"
            newPassword.placeholder = "Nova Senha"
            confirmPassword.placeholder = "Confirmar nova Senha"
            contentView.addSubviews([newPassword, confirmPassword])
        }
    }
    @objc func submitButtonTapped() {
        submitButtonAction?()
    }
    
    @objc func closeButtonTapped() {
        closeButtonAction?()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animateZoomIn()
    }
    func setupBlurView() {
        backgroundColor = .clear
        addSubview(blurEffectView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        blurEffectView.addGestureRecognizer(tap)
    }
    
    func setupConstraints() {
        contentView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 128)
            .width(widthAnchor)
            .centerX(centerXAnchor)
            
        titleLabel.anchor
            .top(contentView.topAnchor, padding: 16)
            .left(contentView.leftAnchor, padding: 16)
        
        textField.anchor
            .top(titleLabel.bottomAnchor, padding: 16)
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .height(constant: 36)
        
        closeButton.anchor
            .top(contentView.topAnchor, padding: 8)
            .right(contentView.rightAnchor, padding: 16)
            .width(constant: 24)
            .height(constant: 24)
        
        submitButton.anchor
            .top(textField.bottomAnchor, padding: 32, priority: 250)
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .bottom(contentView.bottomAnchor, padding: 16)
            .height(constant: 60)
        
        if type == .password {
            newPassword.anchor
                .top(textField.bottomAnchor, padding: 16)
                .left(contentView.leftAnchor, padding: 16)
                .right(contentView.rightAnchor, padding: 16)
                .height(constant: 36)
            
            confirmPassword.anchor
                .top(newPassword.bottomAnchor, padding: 16)
                .left(contentView.leftAnchor, padding: 16)
                .right(contentView.rightAnchor, padding: 16)
                .height(constant: 36)
            
            submitButton.anchor
                .top(confirmPassword.bottomAnchor, padding: 32, priority: 750)
            
        }
    }
    
    func animateZoomIn() {
        contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        blurEffectView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView.layer.opacity = 0.8
            self.contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
        }
    }
}
