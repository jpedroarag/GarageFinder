//
//  SignUpView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

struct KeyScrollerItem {
    weak var scroller: KeyScroller?
}

class KeyScroller {
    weak var scrollView: UIScrollView? 
    static var keyScrollers = [KeyScrollerItem]()
    
	init(withScrollView scrollView: UIScrollView) {
        self.scrollView = scrollView
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let scrollView = scrollView else {
            fatalError("View in view controller not scroll view")
        }
        scrollView.contentInset.bottom = 0
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let scrollView = scrollView,
            let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                fatalError("View in view controller not scroll view")
        }
        
        guard let responder = UIResponder.current as? UIView else {
            return
        }
                
		var origin = responder.frame.origin
		if responder.superview is UITableViewCell {
			origin = responder.convert(origin, to: scrollView)
		}

        let visibleHeight = UIScreen.main.bounds.height - keyboardFrame.height
        let centerOfVisibleHeight = visibleHeight / 2
		
		scrollView.contentInset.bottom = keyboardFrame.height
        
        let newOffsetPoint = CGPoint(x: 0, y: origin.y - centerOfVisibleHeight)
        scrollView.setContentOffset(newOffsetPoint, animated: true)
    }
}

extension UIResponder {
    private weak static var currentFirstResponder: UIResponder?
    
    public static var current: UIResponder? {
        UIResponder.currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder.currentFirstResponder = self
    }
}
