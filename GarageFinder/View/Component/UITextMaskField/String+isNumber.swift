//
//  String+isNumber.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

extension String {
    var isNumber: Bool {

        let num = Int(self)

        if num != nil {
            return true
        }

        return false
    }

    var hasSpecialCharacter: Bool {
        guard let regex = try? NSRegularExpression(
            pattern: ".*[^A-Za-z0-9].*",
            options: NSRegularExpression.Options()) else {

            return false
        }

        if regex.firstMatch(
            in: self,
            options: NSRegularExpression.MatchingOptions(),
            range: NSRange(location: 0, length: self.count)) != nil {
            return true
        }
        return false
    }

    subscript (index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    subscript (index: Int) -> String {
        return String(self[index] as Character)
    }

    subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[(start ..< end)])
    }
}
