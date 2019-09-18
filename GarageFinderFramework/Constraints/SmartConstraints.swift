//
//  SmartConstraints.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

/*
 USAGE EXAMPLE:
 
 childView.anchor
 .top(view.topAnchor)
 .bottom(parentView.bottomAnchor, padding: 16.0)
 .left(parentView.leftAnchor, padding: 16.0)
 .right(parentView.rightAnchor, padding: 16.0)
 
*/
 
import UIKit

public class SmartConstraint {
    /// Item to be anchored, can be a UIView or a UILayoutGuide
    unowned var view: AnyObject
    
    public var lastConstraint: NSLayoutConstraint?
    /// Init with View
    init(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
    }
    
    /// Init with Layout Guide
    init(layoutGuide: UILayoutGuide) {
        self.view = layoutGuide
    }
}

public extension UIView {
    var anchor: SmartConstraint {
        return SmartConstraint(view: self)
    }
    
}

extension SmartConstraint {
    
    @discardableResult
    public func top(_ anchor: NSLayoutYAxisAnchor,
                    padding: CGFloat = 0,
                    relation: NSLayoutConstraint.Relation = .equal,
                    priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.topAnchor, toAnchor: anchor, relation: relation, padding: padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func bottom(_ anchor: NSLayoutYAxisAnchor,
                       padding: CGFloat = 0,
                       relation: NSLayoutConstraint.Relation = .equal,
                       priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.bottomAnchor, toAnchor: anchor, relation: relation, padding: -padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func left(_ anchor: NSLayoutXAxisAnchor,
                     padding: CGFloat = 0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.leftAnchor, toAnchor: anchor, relation: relation, padding: padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func right(_ anchor: NSLayoutXAxisAnchor,
                      padding: CGFloat = 0,
                      relation: NSLayoutConstraint.Relation = .equal,
                      priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.rightAnchor, toAnchor: anchor, relation: relation, padding: -padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func width(_ anchor: NSLayoutDimension,
                      constant: CGFloat = 0,
                      multiplier: CGFloat = 1,
                      relation: NSLayoutConstraint.Relation = .equal,
                      priority: Float = 1000) -> SmartConstraint {
        layoutDimension(view.widthAnchor, toDimension: anchor, relation: relation, constant: constant, multiplier: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    public func width(constant: CGFloat,
                      relation: NSLayoutConstraint.Relation = .equal,
                      priority: Float = 1000) -> SmartConstraint {
        layoutDimension(view.widthAnchor, relation: relation, constant: constant, priority: priority)
        return self
    }
    
    @discardableResult
    public func height(_ anchor: NSLayoutDimension,
                       constant: CGFloat = 0,
                       multiplier: CGFloat = 1,
                       relation: NSLayoutConstraint.Relation = .equal,
                       priority: Float = 1000) -> SmartConstraint {
        layoutDimension(view.heightAnchor, toDimension: anchor, relation: relation, constant: constant, multiplier: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    public func height(constant: CGFloat,
                       relation: NSLayoutConstraint.Relation = .equal,
                       priority: Float = 1000) -> SmartConstraint {
        layoutDimension(view.heightAnchor, relation: relation, constant: constant, priority: priority)
        return self
    }
    
    @discardableResult
    public func centerX(_ anchor: NSLayoutXAxisAnchor,
                        padding: CGFloat = 0,
                        relation: NSLayoutConstraint.Relation = .equal,
                        priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.centerXAnchor, toAnchor: anchor, relation: relation, padding: padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func centerY(_ anchor: NSLayoutYAxisAnchor,
                        padding: CGFloat = 0,
                        relation: NSLayoutConstraint.Relation = .equal, priority: Float = 1000) -> SmartConstraint {
        layoutAnchor(view.centerYAnchor, toAnchor: anchor, relation: relation, padding: padding, priority: priority)
        return self
    }
    
    @discardableResult
    public func attatch(to view: UIView, paddings: [Paddings]? = nil) -> SmartConstraint {
        var anchors: [CGFloat] = [0, 0, 0, 0]
        
        paddings?.forEach({ (padding) in
            switch padding {
            case .top(let anchor):
                anchors[0] = anchor
            case .right(let anchor):
                anchors[1] = anchor
            case .bottom(let anchor):
                anchors[2] = anchor
            case .left(let anchor):
                anchors[3] = anchor
            }
            
        })
        
        top(view.topAnchor, padding: anchors[0])
        bottom(view.bottomAnchor, padding: anchors[1])
        left(view.leftAnchor, padding: anchors[2])
        right(view.rightAnchor, padding: anchors[3])
        return self
    }
    
    func layoutAnchor<T: AnyObject>(_ anchor: NSLayoutAnchor<T>,
                                    toAnchor: NSLayoutAnchor<T>,
                                    relation: NSLayoutConstraint.Relation,
                                    padding: CGFloat,
                                    priority: Float) {
        var constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = anchor.constraint(equalTo: toAnchor, constant: padding)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: padding)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: toAnchor, constant: padding)
        default:
            fatalError()
        }
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        lastConstraint = constraint
    }
    
    func layoutDimension(_ dimension: NSLayoutDimension,
                         toDimension: NSLayoutDimension? = nil,
                         relation: NSLayoutConstraint.Relation,
                         constant: CGFloat,
                         multiplier: CGFloat = 1,
                         priority: Float = 1000) {
        
        var constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            if let dim = toDimension {
                constraint = dimension.constraint(equalTo: dim, multiplier: multiplier, constant: constant)
            } else {
                constraint = dimension.constraint(equalToConstant: constant)
            }
        case .greaterThanOrEqual:
            if let dim = toDimension {
                constraint = dimension.constraint(greaterThanOrEqualTo: dim, multiplier: multiplier, constant: constant)
            } else {
                constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
            }
        case .lessThanOrEqual:
            if let dim = toDimension {
                constraint = dimension.constraint(lessThanOrEqualTo: dim, multiplier: multiplier, constant: constant)
            } else {
                constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
            }
        default:
            fatalError()
        }
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        lastConstraint = constraint
    }
}

public enum Paddings: Equatable {
    case top(CGFloat)
    case right(CGFloat)
    case bottom(CGFloat)
    case left(CGFloat)
}
