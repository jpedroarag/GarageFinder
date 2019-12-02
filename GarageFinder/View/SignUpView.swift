//
//  SignUpView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    typealias Action = () -> Void
    var photoButtonAction: Action?
    var submitButtonAction: ((_ content: TextFieldCollection<TextFieldType, GFTextField>) -> Void)?
    var closeButtonAction: Action?
    let dataSource: TextFieldsTableDataSource
    
    lazy var scrollView = UIScrollView()
    lazy var editPhotoButton: UIButton = {
        guard let image = UIImage(named: "edit") else { return UIButton() }
        let button = UIButton(circularWith: image.withRenderingMode(.alwaysTemplate), andCornerRadius: 18)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.tintColor = .lightBlue
        return button
    }()

    lazy var photoShadowView: UIView = {
        let view = UIView()
        view.shadowed()
        view.backgroundColor = .white
        view.layer.cornerRadius = 62.5
        return view
    }()
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(image: UIImage(named: "profile"))
        photoImageView.contentMode = .center
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 62.5
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    lazy var textFieldsTableView: TextFieldsTableView = {
        let table = TextFieldsTableView(style: .grouped)
        table.dataSource = dataSource
        return table
    }()

    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Cadastrar", for: .normal)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    var keyScroller: KeyScroller?
    
    init(isEditingProfile: Bool = false) {
        var userData: [TextFieldType] = [.name, .email, .cpf, .driverLicense, .password]
        let driverData: [TextFieldType] = [.model, .year, .chassi, .licensePlate]
        
        if !isEditingProfile {
            userData.append(.confirmPassword)
        }
        
        let userTypes: [[TextFieldType]] = [userData, driverData]
        
        self.dataSource = TextFieldsTableDataSource(userTypes: userTypes, isEditing: isEditingProfile)
        super.init(frame: .zero)
        scrollView.bounces = false
        if !isEditingProfile {
            addGestureRecognizer(tap)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        
        addSubview(scrollView)
        scrollView.addSubviews([photoShadowView, photoImageView, editPhotoButton, textFieldsTableView])
        
        if !dataSource.isEditing {
            addSubview(closeButton)
            keyScroller = KeyScroller(withScrollView: scrollView)
            scrollView.addSubview(submitButton)
        }
        
        setupConstraints()
        backgroundColor = .white
        
        editPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func setKeyScroller(enabled: Bool) {
        keyScroller = enabled ? KeyScroller(withScrollView: scrollView) : nil
    }
    
    @objc func photoButtonTapped() {
        photoButtonAction?()
    }
    
    @objc func submitButtonTapped() {
        submitButtonAction?(textFieldsTableView.getData())
    }
    
    @objc func closeButtonTapped() {
        closeButtonAction?()
    }
    
    func setUserPhoto(_ image: UIImage?) {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.image = image
    }
    
    func setupConstraints() {
        scrollView.anchor
            .top(safeAreaLayoutGuide.topAnchor)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 8)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 8)
            .bottom(safeAreaLayoutGuide.bottomAnchor)
        
        photoShadowView.anchor
            .top(scrollView.topAnchor, padding: 32)
            .centerX(scrollView.centerXAnchor)
            .width(constant: 125)
            .height(constant: 125)
        
        photoImageView.anchor
            .top(scrollView.topAnchor, padding: 32)
            .centerX(scrollView.centerXAnchor)
            .width(constant: 125)
            .height(constant: 125)
        
        editPhotoButton.anchor
            .left(photoImageView.leftAnchor)
            .bottom(photoImageView.bottomAnchor)
            .width(constant: 36)
            .height(constant: 36)
        
        textFieldsTableView.anchor
            .top(photoImageView.bottomAnchor, padding: 32)
            .width(scrollView.widthAnchor)
            .height(constant: textFieldsTableView.height + 16)
        
        if !dataSource.isEditing {
            submitButton.anchor
                .top(textFieldsTableView.bottomAnchor, padding: 16)
                .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
                .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
                .bottom(scrollView.bottomAnchor, padding: 64)
                .height(constant: 60)
            
            closeButton.anchor
                .top(safeAreaLayoutGuide.topAnchor, padding: 16)
                .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
                .width(constant: 24)
                .height(constant: 24)
        } else {
            textFieldsTableView.anchor
                .bottom(scrollView.bottomAnchor, padding: 32)
        }
    }
}
