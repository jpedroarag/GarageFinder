//
//  Label+Extension.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 11/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UILabel {
    var estimatedHeight: CGFloat {
        guard let textUnwrapped = text else { return 0 }
        let stringHeight = textUnwrapped.heightOfString(usingFont: font)
        let roundedHeight = stringHeight.native.rounded(toPlaces: 1)
        return CGFloat(roundedHeight)
    }
}
