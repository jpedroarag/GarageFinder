//
//  TextFieldsTableViewDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldsTableDataSource: NSObject, UITableViewDataSource {
    let textFieldTypes: [TextFieldType]
    
    required init(_ textFieldTypes: TextFieldType ...) {
        self.textFieldTypes = textFieldTypes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TextFieldCell
        cell?.textField.setUpType(type: textFieldTypes[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
}
