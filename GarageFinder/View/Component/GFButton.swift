//
//  GFButton.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GFButton: UIButton {
    
    var action: ((GFButton) -> Void)? 

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0x23D25B, alpha: 100)
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        rounded(cornerRadius: 5)
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
    @objc func tapped() {
        action?(self)
    }
    
}
