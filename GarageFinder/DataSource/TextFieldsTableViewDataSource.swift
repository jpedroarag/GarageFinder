//
//  TextFieldsTableViewDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldsTableDataSource: NSObject, UITableViewDataSource {
    let userTypes: [TextFieldType]
    let vehicleTypes: [TextFieldType]
    let isEditing: Bool
    
    required init(userTypes: [TextFieldType], vehicleTypes: [TextFieldType], isEditing: Bool = false) {
        
        self.userTypes = userTypes
        self.vehicleTypes = vehicleTypes
        self.isEditing = isEditing
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return userTypes.count
        default:
            return vehicleTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var textFieldCell: TextFieldCell?
        var labelCell: LabelCell?
        
        if isEditing {
            labelCell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
        } else {
            textFieldCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TextFieldCell
            
            switch indexPath.section {
            case 0:
                textFieldCell?.textField.setUpType(type: userTypes[indexPath.row])
            default:
                textFieldCell?.textField.setUpType(type: vehicleTypes[indexPath.row])
            }
        }
        
        return textFieldCell ?? labelCell ?? UITableViewCell()
    }
}
