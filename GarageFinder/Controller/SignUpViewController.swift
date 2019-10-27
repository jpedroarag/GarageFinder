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
        
        if isEditingProfile {
            loadUser()
        }
    }
    
    func loadUser() {
        URLSessionProvider().request(.getCurrent(User.self)) { result in
            switch result {
            case .success(let response):
                if let user = response.result {
                    let content: [TextFieldType: String] = [.name: user.name,
                                                                 .email: user.email,
                                                                 .cpf: user.documentNumber]
                    self.signUpView.textFieldsTableView.load(data: content)
                }
                
            case .failure(let error):
                print("Error loading current user: \(error)")
            }
        }
    }
    
    func showImagePicker() {
        self.imagePickerTool.getImage(from: [.camera, .photoLibrary], parentViewController: self, imageCompletion: { (result) in
            switch result {
            case .image(let image):
                self.savedImage = image
                self.signUpView.setUserPhoto(image)
            case .canceled:
                break
            }
        })
    }
}

// MARK: - TableViewDelegate

extension SignUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = section == 0 ? "Usuário" : "Veículo"
        let headerView = SignupHeader(frame: CGRect(x: 0, y: 0,
                                                          width: tableView.frame.width, height: 50),
                                            title: headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingProfile {
            if let labelCell = tableView.cellForRow(at: indexPath) as? LabelCell, let type = labelCell.type {
                let editFieldVC = EditFieldViewController(fieldType: type, content: labelCell.label.text)
                DispatchQueue.main.async {
                    self.present(editFieldVC, animated: true, completion: nil)
                }
            }
        }
    }
}
