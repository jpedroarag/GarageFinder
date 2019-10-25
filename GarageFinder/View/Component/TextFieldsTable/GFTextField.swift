//
//  GFTextField.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GFTextField: UITextField {
    var type: TextFieldType = .none
    
    let warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.textColor = .red
        warningLabel.font = UIFont.systemFont(ofSize: 10)
        warningLabel.text = "warning"
        warningLabel.isHidden = true
        
        return warningLabel
    }()
    var hasIcon: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        leftViewMode = .always
        self.addSubview(warningLabel)
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
    
    private func setIcon(image: UIImage) {
        if hasIcon {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            let icon = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
            icon.addSubview(imageView)
            leftView = icon
            leftViewMode = .always
        }
    }
    
    private func setConstraints() {
        warningLabel.anchor
            .left(leftAnchor)
            .right(rightAnchor)
            .bottom(bottomAnchor)
    }
    
     func setUpType(type: TextFieldType) {
        self.type = type
        placeholder = type.rawValue
        switch type {
        case .email:
            guard let image = UIImage(named: "envelope") else {
                print("Image not contained in assets")
                return
            }
            self.setIcon(image: image)
        case .password, .confirmPassword:
            guard let image = UIImage(named: "lock") else {
                print("Image not contained in assets")
                return
            }
            self.setIcon(image: image)
            self.isSecureTextEntry = true
        case .cpf:
            self.keyboardType = .numberPad
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
