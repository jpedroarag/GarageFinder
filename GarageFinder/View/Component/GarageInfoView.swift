//
//  GarageInfoView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageInfoView: UIView {
    
    lazy var parkButton: GFButton = {
        let button = GFButton(frame: .zero)
        button.setTitle("Estacionar", for: .normal)
        return button
    }()
    
    lazy var component: GFTableViewComponent = {
        let view = GFTableViewComponent(type: .garageInfo)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(component)
        addSubview(parkButton)
        parkButton.addTarget(self, action: #selector(parkButtonTapped(_:)), for: .touchUpInside)
        setConstraints()
    }
    
    private func setConstraints() {
        component.anchor
        .top(topAnchor)
        .left(leftAnchor, padding: 20)
        .right(rightAnchor, padding: 20)
        .height(constant: 21+4+16)
        
        parkButton.anchor
            .top(component.bottomAnchor, padding: 24)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(parkButton.widthAnchor, multiplier: 0.16)
    }
    
    @objc private func parkButtonTapped(_ sender: GFButton) {
        parkButton.action?(sender)
    }
    
    // TODO: Load data from object
    func loadData() {
        
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
