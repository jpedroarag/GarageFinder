//
//  SignUpView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SignUpView: UIView {
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
        table.delegate = self
        return table
    }()

    lazy var submitButton: GFButton = {
        let button = GFButton()
        button.setTitle("Cadastrar", for: .normal)
        return button
    }()
    
    var keyScroller: KeyScroller?
    
    init(isEditingProfile: Bool = false) {
        self.dataSource = TextFieldsTableDataSource(userTypes: [.name, .email, .cpf, .password, .confirmPassword],
        vehicleTypes: [.model, .color, .year, .licensePlate], isEditing: isEditingProfile)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        keyScroller = KeyScroller(withScrollView: scrollView)
        addSubview(scrollView)
        scrollView.addSubviews([photoImageView, editPhotoButton, textFieldsTableView])
        
        if !dataSource.isEditing {
            scrollView.addSubview(submitButton)
        }
        
        setupConstraints()
        backgroundColor = .white
        
        editPhotoButton.addTarget(self, action: #selector(photoButtonAction), for: .touchUpInside)
        
        addGestureRecognizer(tap)
    }
    @objc func photoButtonAction() {
        print("Photo button")
    }
    func setupConstraints() {
        scrollView.anchor
            .top(safeAreaLayoutGuide.topAnchor)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 8)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 8)
            .bottom(safeAreaLayoutGuide.bottomAnchor)
        
        photoImageView.anchor
            .top(scrollView.topAnchor, padding: 16)
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
            .height(constant: textFieldsTableView.height)
        
        if !dataSource.isEditing {
            submitButton.anchor
                .top(textFieldsTableView.bottomAnchor, padding: 16)
                .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
                .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
                .bottom(scrollView.bottomAnchor, padding: 64)
        } else {
            textFieldsTableView.anchor.bottom(scrollView.bottomAnchor, padding: 32)
        }
    }
}

extension SignUpView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = section == 0 ? "Usuário" : "Veículo"
        let headerView = SignupHeader(frame: CGRect(x: 0, y: 0,
                                                          width: tableView.frame.width, height: 50),
                                            title: headerTitle)
        return headerView
    }
}
