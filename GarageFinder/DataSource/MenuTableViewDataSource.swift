//
//  MenuTableViewDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class MenuTableViewDataSource: NSObject, UITableViewDataSource {
    
    let options = ["Editar Conta", "Histórico de Garagens (Em Breve)", "Configurações", "Sair da Conta"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = options[indexPath.row]
        cell?.selectionStyle = .none
        
        switch indexPath.row {
        case 1:
            cell?.textLabel?.textColor = .lightGray
        case 3:
            cell?.textLabel?.textColor = .systemRed
        default:
            cell?.accessoryType = .disclosureIndicator
        }

        return cell ?? UITableViewCell()
    }
}
