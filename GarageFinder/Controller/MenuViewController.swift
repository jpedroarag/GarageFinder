//
//  MenuViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class MenuViewController: UIViewController {
    let menuView = MenuView()
    let titleMenuView = TitleMenuView()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.tableView.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setNavigationCloseButton()
        
    }
    var user: User?
    override func viewDidAppear(_ animated: Bool) {
        showTitleView(show: true)
    }
    override func loadView() {
        view = menuView
        addTitleView()
        loadUser()
    }
    
    func addTitleView() {
        if let navBar = navigationController?.navigationBar {
            navBar.addSubview(titleMenuView)
            navBar.layoutMargins.left = 116
            titleMenuView.anchor
                .left(navBar.leftAnchor)
                .top(navBar.topAnchor)
                .width(constant: 84)
                .height(constant: 84)
        }
    }
    
    func showTitleView(show: Bool) {
        UIView.animate(withDuration: 0.2) {
          self.titleMenuView.alpha = show ? 1.0 : 0.0
        }
    }

    func loadUser() {
        URLSessionProvider().request(.getCurrent(User.self)) { result in
            switch result {
            case .success(let response):
                if let user = response.result {
                    DispatchQueue.main.async {
                        self.title = user.name
                        self.user = user
                    }
                }
                
            case .failure(let error):
                print("Error loading current user: \(error)")
            }
        }
    }
    
    func logoutAccount() {
        UserDefaults.standard.logoutUser()
        dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showTitleView(show: false)
            let signVC = SignUpViewController(isEditingProfile: true)
            if let user = self.user {
                signVC.load(user)
                navigationController?.pushViewController(signVC, animated: true)   
            }
        case 1:
           showTitleView(show: false)
           navigationController?.pushViewController(GarageHistoryViewController(), animated: true)
        case 2:
           print("Settings")
        case 3:
            let alert = UIAlertController(title: "", message: "Você deseja sair da conta?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
                self.logoutAccount()
            }))
                    
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
}
