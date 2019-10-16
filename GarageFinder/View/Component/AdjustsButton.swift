//
//  AdjustsButton.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 04/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class AdjustsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let adjustsImage = UIImage(named: "adjusts")
        setImage(adjustsImage, for: .normal)
        addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        tintColor = .black
    }
    
    @objc func tapped(_ sender: AdjustsButton) {
        NotificationCenter.default.post(name: .adjustsMenu, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
