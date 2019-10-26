//
//  EditFieldViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class EditFieldViewController: UIViewController {

    let editFieldView: EditFieldView
    
    init(fieldType: TextFieldType, content: String?) {
        editFieldView = EditFieldView(fieldType: fieldType)
        editFieldView.textField.text = content
        super.init(nibName: nil, bundle: nil)
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
        editFieldView.animateZoomIn()
    }
    
    func submit() {
        print("SUBMIT")
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        print("CANCEL")
        dismiss(animated: true, completion: nil)
    }
}
