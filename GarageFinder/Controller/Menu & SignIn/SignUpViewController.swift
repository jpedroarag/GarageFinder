//
//  SignUpViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class SignUpViewController: UIViewController {
    let signUpView: SignUpView
    let isEditingProfile: Bool
    let imagePickerTool = ImagePickerTool()
    var savedImage: UIImage?
    var validator: FieldValidator!
    var user: User?
    
    weak var parkingStatusDelegate: ParkingStatusDelegate!
    weak var finishSignUpDelegate: FinishSignUpDelegate?
    weak var updateUserPhotoDelegate: UpdateUserPhotoDelegate?
    
    let provider = URLSessionProvider()
    
    init(isEditingProfile: Bool = false) {
        self.isEditingProfile = isEditingProfile
        self.signUpView = SignUpView(isEditingProfile: isEditingProfile)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view = signUpView
        signUpView.textFieldsTableView.delegate = self
        signUpView.photoButtonAction = showImagePicker
        signUpView.submitButtonAction = saveUser(_:)
        if isEditingProfile {
            navigationItem.largeTitleDisplayMode = .never
            title = "Editar Conta"
            setNavigationCloseButton()
        } else {
            signUpView.closeButtonAction = closeButtonAction
        }
    }
    
    func closeButtonAction() {
        finishSignUpDelegate?.didFinishSignUp()
        dismiss(animated: true, completion: nil)
    }
    
    func load(_ user: User) {
        self.user = user
        guard let name = user.name, let email = user.email, var cpf = user.documentNumber else { return }
        if cpf == "" {
            cpf = "------"
        }
        let content: [TextFieldType: String] = [.name: name,
                                                     .email: email,
                                                     .cpf: cpf]
        self.signUpView.textFieldsTableView.load(data: content)
        
        if let image = user.avatar?.base64Convert() {
            signUpView.setUserPhoto(image)
        }
    }
    
    func saveUser(_ content: TextFieldCollection<TextFieldType, GFTextField>) {
        
        let strategies: [ValidationStrategy] = [CPFValidationStrategy(), EmptyStrategy(),
                                                EmailValidationStrategy(), NewPasswordValidationStrategy(oldPasswordTextField: content[.password])]
        validator = FieldValidator(andStrategies: strategies)
        let isEmailRight = validator.validate(elements: content[.email], withStrategy: EmailValidationStrategy.self)
        let isCPFRight = validator.validate(elements: content[.cpf], withStrategy: CPFValidationStrategy.self)
        let isNewPassRight = validator.validate(elements: content[.confirmPassword], withStrategy: NewPasswordValidationStrategy.self)
        let isNameRight = validator.validate(elements: content[.name], content[.password], withStrategy: EmptyStrategy.self)
        let hasNoWarning = isEmailRight && isNewPassRight && isNameRight && isCPFRight
        
        if hasNoWarning {
            let user = User(id: nil, name: content[.name], email: content[.email],
                            documentType: .cpf, documentNumber: content[.cpf], password: content[.password],
                            addresses: nil, garages: nil, role: "ROLE_GD", avatar: savedImage?.toBase64())

            provider.request(.post(user)) { result in
                switch result {
                case .success(let response):
                    print("response: ", response)
                    if response.result != nil {
                        print("USER SAVED")
                        DispatchQueue.main.async {
                            if !self.isEditingProfile {
                                self.parkingStatusDelegate.loadData(fromLogin: true)
                            }
                            self.finishSignUpDelegate?.didFinishSignUp()
                            self.dismiss(animated: true) {
                                let loginController = self.finishSignUpDelegate as? LoginViewController
                                loginController?.updateMapSettings()
                                loginController?.dismiss(animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    print("Error save user: \(error)")
                }
            }
        }
    }
    func showImagePicker() {
        self.imagePickerTool.getImage(from: [.camera, .photoLibrary], parentViewController: self, imageCompletion: { result in
            switch result {
            case .image(let image):
                self.savedImage = image
                self.signUpView.setUserPhoto(image)
                
                if self.isEditingProfile {
                    guard let userId = self.user?.id else { return}
                    let user = User(id: userId, avatar: image.toBase64())
                    self.provider.request(.update(user)) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                self.updateUserPhotoDelegate?.didUpdateUserPhoto(image)
                            }
                        case .failure(let error):
                            print("Erron update photo: \(error)")
                        }
                    }
                }
            case .canceled:
                break
            }
        })
    }
}

// MARK: - TableViewDelegate

extension SignUpViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerTitle = section == 0 ? "Usuário" : "Veículo"
//        let headerView = SignupHeader(frame: CGRect(x: 0, y: 0,
//                                                          width: tableView.frame.width, height: 50),
//                                            title: headerTitle)
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingProfile {
            if let labelCell = tableView.cellForRow(at: indexPath) as? LabelCell, let type = labelCell.type {
                if type != .email {
                    let editFieldVC = EditFieldViewController(user: user, fieldType: type, content: labelCell.label.text)
                    editFieldVC.updateFieldDelegate = self
                    DispatchQueue.main.async {
                        self.present(editFieldVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension SignUpViewController: UpdateFieldDelegate {
    func didUpdate(field: TextFieldType, content: String?) {
        if let label = signUpView.textFieldsTableView.get(field) {
            label.text = content
        }
    }
    
}
