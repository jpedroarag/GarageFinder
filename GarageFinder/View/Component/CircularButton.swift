//
//  CircularButton.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class CircularButton: UIButton {
    
    var action: ((CircularButton) -> Void)?
    
    init(icon: UIImage?, size: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        super.init(frame: frame)
        rounded(cornerRadius: size/2)
        shadowed()
        backgroundColor = .white
        setImage(icon, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}
