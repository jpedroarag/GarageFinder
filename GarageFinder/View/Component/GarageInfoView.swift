//
//  GarageInfoView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class GarageInfoView: UIView {
    
    lazy var button: GFButton = {
        let button = GFButton(frame: .zero)
        button.setTitle("Estacionar", for: .normal)
        return button
    }()
    
    lazy var component: GFTableViewComponent = {
        let view = GFTableViewComponent(type: .garageInfo)
        return view
    }()
    
    lazy var supplementaryView: UIView? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(component)
        addSubview(button)
        button.addTarget(self, action: #selector(parkButtonTapped(_:)), for: .touchUpInside)
        setConstraints()
    }
    
    convenience init(collapsed: Bool) {
        self.init(frame: .zero)
        component.isCollapsed = collapsed
    }
    
    private func setConstraints() {
        component.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 20)
            .right(rightAnchor, padding: 20)
            .height(constant: 21+4+16)
        
        button.anchor
            .top(component.bottomAnchor, padding: 24)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(button.widthAnchor, multiplier: 0.16)
    }
    
    private func deactivateConstraints() {
        component.anchor.deactivateAll()
        button.anchor.deactivateAll()
    }
    
    private func setConstraintsForSupplementaryView() {
        guard let supplementary = supplementaryView else { return }
        deactivateConstraints()
        component.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 20)
            .right(rightAnchor, padding: 20)
            .bottom(supplementary.topAnchor, padding: 24)
        
        supplementary.anchor
            .bottom(button.topAnchor, padding: 24)
            .centerX(centerXAnchor)
            .width(widthAnchor)
            .height(constant: 50)
        
        button.anchor
            .bottom(bottomAnchor, padding: 16)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(button.widthAnchor, multiplier: 0.16)
    }
    
    private func setFrameForSupplementaryView() {
        let position = CGPoint(x: component.frame.origin.x + 24, y: button.frame.origin.y)
        let size = CGSize(width: button.bounds.width - 2 * 24, height: .zero)
        supplementaryView?.frame = CGRect(origin: position, size: size)
    }
    
    func addSupplementaryView(_ view: UIView, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        supplementaryView?.removeFromSuperview()
        supplementaryView = view
        setFrameForSupplementaryView()
        addSubview(view)
        setConstraintsForSupplementaryView()
        if animated {
            UIView.animate(withDuration: 0.7, animations: {
                self.layoutSubviews()
            }, completion: { _ in
                completion?()
            })
        } else {
            layoutSubviews()
            completion?()
        }
    }
    
    @objc private func parkButtonTapped(_ sender: GFButton) {
        button.action?(sender)
    }
    
    func loadData(_ garage: Garage) {
        component.leftImageView.image = UIImage(named: "mockGarage")
        component.titleLabel.text = "Garagem de Marcus"
        component.subtitleLabel.text = "St. John Rush, 79"
        component.ratingLabel.text = "4.3"
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
