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
    let isEditing: Bool
    
    required init(userTypes: [TextFieldType], isEditing: Bool = false) {
        
        self.userTypes = userTypes
        self.isEditing = isEditing
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var textFieldCell: TextFieldCell?
        var labelCell: LabelCell?

        if isEditing {
            labelCell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
        } else {
            textFieldCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TextFieldCell
        }

        let userType = userTypes[indexPath.row]
        textFieldCell?.textField.setUpType(type: userType)
        labelCell?.setType(userType)

        return textFieldCell ?? labelCell ?? UITableViewCell()
    }
}
