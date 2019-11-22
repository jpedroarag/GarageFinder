//
//  NSLayoutConstrait.Attribute+CaseIterable.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension NSLayoutConstraint.Attribute: CaseIterable {
    public static var allCases: [NSLayoutConstraint.Attribute] {
        return [.top,
                .left,
                .right,
                .bottom,
                .topMargin,
                .leftMargin,
                .rightMargin,
                .bottomMargin,
                .centerX,
                .centerY,
                .centerXWithinMargins,
                .centerYWithinMargins,
                .firstBaseline,
                .lastBaseline,
                .height,
                .width,
                .leading,
                .trailing,
                .notAnAttribute]
    }
}
