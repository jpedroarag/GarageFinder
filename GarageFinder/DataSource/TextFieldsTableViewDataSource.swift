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
    required init(userTypes: [TextFieldType], vehicleTypes: [TextFieldType]) {
        self.userTypes = userTypes
        self.vehicleTypes = vehicleTypes
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TextFieldCell
        
        switch indexPath.section {
        case 0:
            cell?.textField.setUpType(type: userTypes[indexPath.row])
        default:
            cell?.textField.setUpType(type: vehicleTypes[indexPath.row])
        } 
        return cell ?? UITableViewCell()
    }
}
