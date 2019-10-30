//
//  CharacterChain.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

class CharacterChain: Chain {
    var nextChain: Chain?
    var limitation: ChainLimitation
    var isNumberBlocked: Bool

    init(limitation: ChainLimitation, isNumberBlocked: Bool, next: Chain? = nil) {
        self.limitation = limitation
        self.isNumberBlocked = isNumberBlocked
        self.nextChain = next
    }

    @discardableResult
    func scan(maskString: String, index: String.Index, counter: inout Int,
              textWithMask: inout String, text: String) -> Bool {

        let textToCompare: String = text[counter]

        if "\(maskString[index])" == "C" {
            if textToCompare.hasSpecialCharacter {
                return false
            }

            if textToCompare.isNumber && isNumberBlocked {
                return false
            }

            switch limitation {
            case .onlyLower:
                textWithMask += String(text[counter]).lowercased()
            case .onlyUpper:
                textWithMask += String(text[counter]).uppercased()
            case .any:
                textWithMask += text[counter]
            }
            counter += 1

            return true
        }
        return nextChain?.scan(maskString: maskString, index: index,
                               counter: &counter, textWithMask: &textWithMask, text: text) ?? false
    }
}
