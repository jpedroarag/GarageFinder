//
//  ToolboxView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 30/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class ToolboxView: UIView {
    
    let minimumButtonSize = CGSize(width: 48, height: 48)
    
    var totalHeight: CGFloat {
        return CGFloat(buttons.count) * minimumButtonSize.height + CGFloat((buttons.count - 1))
    }
    
    var buttons = [UIButton]()
    var separators = [UIView]()
    
    private var separatorColor: UIColor?

    init(withBackgroundColor backgroundColor: UIColor, withSeparatorColor separatorColor: UIColor, andButtons buttons: UIButton...) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
        self.buttons = buttons
        
        rounded(cornerRadius: 5)
        shadowed()
        
        addSubviews(buttons)
        setConstraints()
        insertSeparators(withColor: separatorColor)
    }
    
    private func setConstraints() {
        for index in 0..<buttons.count {
            if buttons[index] === buttons.last {
                buttons[index].anchor
                    .bottom(bottomAnchor)
                    .left(leftAnchor)
                    .right(rightAnchor)
                    .height(constant: minimumButtonSize.height)
                return
            }
            buttons[index].anchor
                .bottom(buttons[index+1].topAnchor, padding: 1)
                .left(leftAnchor)
                .right(rightAnchor)
                .height(constant: minimumButtonSize.height)
        }
    }
    
    private func insertSeparators(withColor color: UIColor) {
        buttons.forEach { button in
            if button === buttons.last { return }
            
            let separator = UIView(frame: .zero)
            separator.backgroundColor = color
            addSubview(separator)
            
            separator.anchor
                .top(button.bottomAnchor)
                .left(leftAnchor, padding: 2)
                .right(rightAnchor, padding: 2)
                .height(constant: 1)
        }
    }
    
    private func remakeConstraints() {
        buttons.forEach { button in
            button.anchor.deactivateConstraints(withLayoutAttributes: .bottom,
                                                                      .left,
                                                                      .right,
                                                                      .height)
        }
        separators.forEach { separator in
            separator.anchor.deactivateConstraints(withLayoutAttributes: .top,
                                                                         .left,
                                                                         .right,
                                                                         .height)
        }
        setConstraints()
        insertSeparators(withColor: separatorColor ?? .black)
    }
    
    func addButtons(_ buttons: UIButton...) {
        addSubviews(buttons)
        self.buttons.append(contentsOf: buttons)
        remakeConstraints()
    }
    
    func removeButton(_ button: UIButton) {
        buttons.removeAll { $0 == button }
        remakeConstraints()
    }
    
    func removeButton(atIndex index: Int) {
        if index >= buttons.count || index < buttons.count { return }
        buttons.remove(at: index)
        remakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
