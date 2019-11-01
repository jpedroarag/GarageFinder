//
//  EditFieldViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class EditFieldViewController: UIViewController {

    let editFieldView: EditFieldView
    var user: User?
    let fieldType: TextFieldType
    var updateFieldDelegate: UpdateFieldDelegate?
    var validator: FieldValidator!
    let provider = URLSessionProvider()
    init(user: User?, fieldType: TextFieldType, content: String?) {
        editFieldView = EditFieldView(fieldType: fieldType)
        if fieldType != .password && content != "------" {
            editFieldView.textField.text = content
        }
        
        self.user = user
        self.fieldType = fieldType
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editFieldView.closeButtonAction = cancel
        editFieldView.submitButtonAction = submit
        editFieldView.textField.becomeFirstResponder()
    }

    override func loadView() {
        view = editFieldView
    }
    
    func submit() {
        var strategies: [ValidationStrategy] = []
        guard var user = self.user else { return }
        let field = editFieldView.textField.text
        var isRight: Bool = false
        switch fieldType {
        case .name:
            strategies = [EmptyStrategy()]
            validator = FieldValidator(andStrategies: strategies)
            isRight = validator.validate(elements: editFieldView.textField, withStrategy: EmptyStrategy.self)
            user.name = field
        case .cpf:
            strategies = [CPFValidationStrategy()]
            validator = FieldValidator(andStrategies: strategies)
            isRight = validator.validate(elements: editFieldView.textField, withStrategy: CPFValidationStrategy.self)
            user.documentNumber = field
        case .password:
            strategies = [EmptyStrategy(), NewPasswordValidationStrategy(oldPasswordTextField: editFieldView.newPassword)]
            validator = FieldValidator(andStrategies: strategies)
            isRight = validator.validate(elements: editFieldView.textField, withStrategy: EmptyStrategy.self) &&
                validator.validate(elements: editFieldView.confirmPassword, withStrategy: NewPasswordValidationStrategy.self)
        default: break
        }
        
        if isRight {
            //If user want to change password, first need to confirm old password. Need to login again.
            if fieldType == .password, let email = user.email, let password = field {
                let newPassword = self.editFieldView.confirmPassword.text
                provider.request(.post(UserAuth(email: email, password: password))) { result in
                    switch result {
                    case .success:
                        user.password = newPassword
                        self.update(user: user)
                    case .failure:
                        print("Error login user: ")
                        self.showErrorAlert()
                    }
                }
            } else {
                update(user: user)
            }
        }
    }
    
    func update(user: User) {
        print("USER: \(user)")
        provider.request(.update(user)) { result in
            switch result {
            case .success:
                print("Success update user")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.updateFieldDelegate?.didUpdate(field: self.fieldType, content: self.editFieldView.textField.text)
                }
            case .failure(let error):
                print("Error update user: \(error)")
            }
        }
    }
    
    func showErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Erro", message: "Senha incorreta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
