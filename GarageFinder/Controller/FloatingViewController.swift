//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {
    var fullView: CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    var middleView: CGFloat {
        return UIScreen.main.bounds.height * 0.75
    }
    var partialView: CGFloat {
        //TODO: Este valor deve ser de acordo com a Search bar
        return UIScreen.main.bounds.height  * 0.9
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let frame = self?.view.frame,
                let yComponent = self?.partialView {
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            }
        })
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        print("PAN GESTURE")
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        let y = view.frame.minY
        
        let limit = y + translation.y
        
        if (limit >= 0) && (limit <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        let top = abs(y - self.fullView)
        let middle = abs(y - self.middleView)
        let bottom = abs(y - self.partialView)
        
        let screenPositionValues: [CGFloat: CGFloat] = [top: self.fullView, middle: self.middleView, bottom: self.partialView]
        
        guard let min = screenPositionValues.min(by: { itemA, itemB in
            itemA.key < itemB.key
        }) else { return }
        
        let minDuration = 0.3
        let durationFactor = 0.0016
        let duration: Double = minDuration + Double(min.key) * durationFactor
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.view.frame = CGRect(x: 0, y: min.value, width: self.view.frame.width, height: self.view.frame.height)
            })

        }
        
    }
}

extension FloatingViewController: UIGestureRecognizerDelegate {
    
}
