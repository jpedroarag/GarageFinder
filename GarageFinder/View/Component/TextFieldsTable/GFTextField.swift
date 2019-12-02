//
//  GFTextField.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GFTextField: UITextMaskField {
    var type: TextFieldType = .none
    
    let warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.textColor = .systemRed
        warningLabel.font = UIFont.systemFont(ofSize: 10)
        warningLabel.text = "warning"
        warningLabel.isHidden = true
        return warningLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        leftViewMode = .always
        addSubview(warningLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setConstraints()
    }

    convenience init(withType type: TextFieldType) {
        self.init(frame: .zero)
        self.backgroundColor = .white
        setUpType(type: type)
    }
    
    private func setConstraints() {
        warningLabel.anchor
            .left(leftAnchor)
            .right(rightAnchor)
            .bottom(bottomAnchor, padding: -15)
    }
    
     func setUpType(type: TextFieldType) {
        self.type = type
        placeholder = type.rawValue
        switch type {
        case .email:
            autocapitalizationType = .none
            keyboardType = .emailAddress
        case .password, .confirmPassword:
            isSecureTextEntry = true
        case .cpf:
            maskString = "NNN.NNN.NNN-NN"
            keyboardType = .numberPad
        case .year:
            maskString = "NNNN"
        case .licensePlate:
            maskString = "CCC-NNNN"
        case .driverLicense:
            maskString = "NNNNNNNNNNN"
            keyboardType = .numberPad
        default:
            return
        }
    }
    @objc private func datePickerChanged(_ picker: UIDatePicker) {
        print("picker changed")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: picker.date))
        self.text = formatter.string(from: picker.date)
    }
    
    @objc private func closePicker() {
        self.endEditing(true)
    }
}
extension GFTextField: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        let genders = Gender.getAll()
//        return genders.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let genders = Gender.getAll()
//
//        self.text = genders[row]
//        return genders[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let genders = Gender.getAll()
//        self.text = genders[row]
//    }
    
}
