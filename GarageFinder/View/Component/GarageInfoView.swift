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

    lazy var paymentMethodView: UIView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(component)
        addSubview(button)
        setConstraints()
    }
    
    convenience init(collapsed: Bool, buttonTitle: String? = nil) {
        self.init(frame: .zero)
        component.isCollapsed = collapsed
        button.setTitle(buttonTitle, for: .normal)
    }
    
    private func setConstraints() {
        component.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 20)
            .right(rightAnchor, padding: 20)
            .height(constant: 75)
        
        button.anchor
            .top(component.bottomAnchor, padding: 24, priority: 250)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(constant: 60)
            .bottom(bottomAnchor, priority: 250)
    }
    
    private func setConstraintsForSupplementaryView(_ height: CGFloat? = nil) {
        guard let supplementary = supplementaryView else { return }

        supplementary.anchor
            .top(component.bottomAnchor, padding: 24)
            .centerX(centerXAnchor)
            .width(widthAnchor)
        
        if let heightValue = height {
            supplementary.anchor.height(constant: heightValue)
        }
        
        button.anchor
            .top(supplementary.bottomAnchor, padding: 24, priority: 700)
    }
    
    private func setConstraintsPaymentMethodView() {
        
        guard let paymentView = paymentMethodView, let supplementary = supplementaryView else { return }

        paymentView.anchor
            .top(supplementary.bottomAnchor, padding: 24)
            .centerX(centerXAnchor)
            .width(widthAnchor)
            .height(constant: 50)
        button.anchor
            .top(paymentView.bottomAnchor, padding: 24, priority: 750)
    }
    private func setFrameForSupplementaryView() {
        let position = CGPoint(x: component.frame.origin.x + 24, y: button.frame.origin.y)
        let size = CGSize(width: button.bounds.width - 2 * 24, height: .zero)
        supplementaryView?.frame = CGRect(origin: position, size: size)
    }
    
    func addSupplementaryView(_ view: UIView, withHeight height: CGFloat? = nil, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        supplementaryView?.removeFromSuperview()
        supplementaryView = view
        setFrameForSupplementaryView()
        addSubview(view)
        setConstraintsForSupplementaryView(height)
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutSubviews()
            }, completion: { _ in
                completion?()
            })
        } else {
            layoutSubviews()
            completion?()
        }
        
    }
    
    func removeSupplementaryView(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        supplementaryView?.anchor.deactivateConstraints(withLayoutAttributes: .height, .top, .bottom)
        supplementaryView?.anchor
            .height(constant: 24)
            .top(component.bottomAnchor, padding: 0)
            .bottom(button.topAnchor)
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutSubviews()
                self.supplementaryView?.alpha = 0
            }, completion: { _ in
                self.supplementaryView?.removeFromSuperview()
                self.supplementaryView = nil
                completion?()
            })
        } else {
            layoutSubviews()
            supplementaryView?.removeFromSuperview()
            supplementaryView = nil
            completion?()
        }
        
    }
    
    func addPaymentMethodView(_ view: UIView, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        paymentMethodView?.removeFromSuperview()
        paymentMethodView = view
        view.alpha = 0
        addSubview(view)
        setConstraintsPaymentMethodView()
        self.layoutSubviews()
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 1
            }, completion: { _ in
                completion?()
            })
        } else {
            layoutSubviews()
            completion?()
        }
        
    }
    
    func loadData(_ garage: Garage) {
        //component.leftImageView.image = garage.pictures.first ?? UIImage()
        component.titleLabel.text = garage.description
        component.subtitleLabel.text = garage.address?.description
        if let average = garage.average?.rounded(toPlaces: 2) {
            if average != 0 {
                component.ratingLabel.text = "\(average)"
                return
            }
        }
        component.ratingLabel.text = "S/A"
    }
    
    func loadImage(_ image: UIImage?) {
        if image == UIImage(named: "profile") {
            component.leftImageView.contentMode = .scaleAspectFit
        }
        component.leftImageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
