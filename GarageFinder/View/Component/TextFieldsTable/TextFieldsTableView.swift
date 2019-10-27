//
//  TextFieldsTableView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldsTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(TextFieldCell.self, forCellReuseIdentifier: "cell")
        register(LabelCell.self, forCellReuseIdentifier: "labelCell")
        isScrollEnabled = false
        contentInset = .zero
        rowHeight = 56
        separatorColor = .clear
        backgroundColor = .white
    }
    
    var height: CGFloat {
        layoutIfNeeded()
        return contentSize.height + 108
    }

    func getData() -> TextFieldCollection<TextFieldType, GFTextField> {
        var tfData: TextFieldCollection<TextFieldType, GFTextField> = [:]
        (0..<numberOfRows(inSection: 0)).forEach { row in
            if let cell = cellForRow(at: IndexPath(row: row, section: 0)) as? TextFieldCell {
                tfData.insert(cell.textField)
            }
        }
        return tfData
    }
    
    func load(data: [TextFieldType: String]) {
        DispatchQueue.main.async {
            (0..<self.numberOfRows(inSection: 0)).forEach { row in
                if let cell = self.cellForRow(at: IndexPath(row: row, section: 0)) as? LabelCell, let type = cell.type {
                    if let content = data[type] {
                        cell.label.text = content
                    }
                }
            }
        }
        
    }
    
    func getField(atPosition position: Int) -> GFTextField? {
        guard let cell = cellForRow(at: IndexPath(row: position, section: 0)) as? TextFieldCell else {
            return nil
        }
        return cell.textField
    }
    
    func getFields() -> [GFTextField] {
        var fields: [GFTextField] = []
        (0..<numberOfRows(inSection: 0)).forEach { row in
            if let cell = cellForRow(at: IndexPath(row: row, section: 0)) as? TextFieldCell {
                fields.append(cell.textField)
            }
        }
        
        return fields
    }
    
    //TODO: - Implementation of loading data in profile

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}