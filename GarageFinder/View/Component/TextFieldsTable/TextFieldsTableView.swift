//
//  TextFieldsTableView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldsTableView: UITableView {
    override init(frame: CGRect = .zero, style: UITableView.Style = .grouped) {
        super.init(frame: frame, style: style)
        register(TextFieldCell.self, forCellReuseIdentifier: "cell")
        register(LabelCell.self, forCellReuseIdentifier: "labelCell")
        isScrollEnabled = false
        contentInset = .zero
        rowHeight = 72
        separatorColor = .clear
        backgroundColor = .white
    }
    
    var height: CGFloat {
        var height = CGFloat.zero
        (0..<numberOfSections).forEach { section in
            height += self.rowHeight * CGFloat(self.numberOfRows(inSection: section) + 1)
        }
        return height
    }

    func getData() -> TextFieldCollection<TextFieldType, GFTextField> {
        var tfData: TextFieldCollection<TextFieldType, GFTextField> = [:]
        (0..<numberOfSections).forEach { section in
            (0..<numberOfRows(inSection: section)).forEach { row in
                if let cell = cellForRow(at: [section, row]) as? TextFieldCell {
                    tfData.insert(cell.textField)
                }
            }
        }
        return tfData
    }
    
    func load(data: [TextFieldType: String]) {
        DispatchQueue.main.async {
            (0..<self.numberOfSections).forEach { section in
                (0..<self.numberOfRows(inSection: section)).forEach { row in
                    if let cell = self.cellForRow(at: [section, row]) as? LabelCell, let type = cell.type {
                        if let content = data[type] {
                            cell.label.text = content
                        }
                    }
                }
            }
        }
        
    }
    
    func loadForFields(data: [[TextFieldType: String]]) {
        DispatchQueue.main.async {
            (0..<self.numberOfSections).forEach { section in
                (0..<self.numberOfRows(inSection: section)).forEach { row in
                    if let cell = self.cellForRow(at: [section, row]) as? TextFieldCell {
                        cell.textField.text = data[section][cell.textField.type]
                    }
                }
            }
        }
        
    }
    
    func get(_ field: TextFieldType) -> UITextField? {
        var label: UITextField?
        (0..<numberOfSections).forEach { section in
            (0..<numberOfRows(inSection: section)).forEach { row in
                if let cell = cellForRow(at: [section, row]) as? LabelCell, label == nil {
                    if cell.type == field {
                        label = cell.label
                    }
                }
            }
        }
        return label
    }
    
    func getField(atIndexPath indexPath: IndexPath) -> GFTextField? {
        guard let cell = cellForRow(at: indexPath) as? TextFieldCell else {
            return nil
        }
        return cell.textField
    }
    
    func getFields() -> [[GFTextField]] {
        var fields: [[GFTextField]] = [[], []]
        (0..<numberOfSections).forEach { section in
            (0..<numberOfRows(inSection: section)).forEach { row in
                if let cell = cellForRow(at: [section, row]) as? TextFieldCell {
                    fields[section].append(cell.textField)
                }
            }
        }
        
        return fields
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
