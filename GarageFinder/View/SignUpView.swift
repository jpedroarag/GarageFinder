//
//  SignUpView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    let dataSource = TextFieldsTableDataSource(.name, .email, .cpf, .password, .confirmPassword)
    
    lazy var editPhotoButton: UIButton = {
        guard let image = UIImage(named: "edit") else { return UIButton() }
        let button = UIButton(circularWith: image.withRenderingMode(.alwaysTemplate), andCornerRadius: 18)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .gray
        return button
    }()

    lazy var photoImageView: UIView = {
        let photoImageView = UIView(withImage: UIImage(named: "profile"))
        photoImageView.contentMode = .center
        photoImageView.shadowed()
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 62.5
        return photoImageView
    }()
    
    lazy var textFieldsTableView: TextFieldsTableView = {
        let table = TextFieldsTableView(frame: .zero, style: .plain)
        table.dataSource = dataSource
        return table
    }()

    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Cadastrar", for: .normal)
        return button
    }()
    
    override func didMoveToSuperview() {
        addSubviews([photoImageView, editPhotoButton, textFieldsTableView, submitButton])
        setupConstraints()
        backgroundColor = .white
    }
    
    func setupConstraints() {
        photoImageView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 16)
            .centerX(centerXAnchor)
            .width(constant: 125)
            .height(constant: 125)
        
        editPhotoButton.anchor
            .left(photoImageView.leftAnchor)
            .bottom(photoImageView.bottomAnchor)
            .width(constant: 36)
            .height(constant: 36)
        
        textFieldsTableView.anchor
            .top(photoImageView.bottomAnchor, padding: 16)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .height(constant: textFieldsTableView.getHeight() + 8)
        
        submitButton.anchor
            .top(textFieldsTableView.bottomAnchor, padding: 16)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 32)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 32)
            
    }
}
