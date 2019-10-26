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
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }()
        
    var submitButtonAction: Action?
    var closeButtonAction: Action?
    
    init(fieldType: TextFieldType) {
        super.init(frame: .zero)
        titleLabel.text = fieldType.rawValue
        backgroundColor = .clear
        setupBlurView()
        addSubview(contentView)
        contentView.addSubviews([titleLabel, textField, submitButton, closeButton])
        setupConstraints()
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
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
    
    func setupBlurView() {
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
            .top(textField.bottomAnchor, padding: 16)
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .bottom(contentView.bottomAnchor, padding: 16)
            .height(constant: 40)
    }
    
    func animateZoomIn() {
        self.contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 1.05, y: 1.05))
        blurEffectView.layer.opacity = 0
        UIView.animate(withDuration: 0.334) {
            self.blurEffectView.layer.opacity = 1
            self.contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
        }
    }
}
