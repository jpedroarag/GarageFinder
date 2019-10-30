//
//  NumberChain.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

class NumberChain: Chain {

    var nextChain: Chain?

    init(next: Chain? = nil) {
        self.nextChain = next
    }

    @discardableResult
    func scan(maskString: String, index: String.Index, counter: inout Int,
              textWithMask: inout String, text: String) -> Bool {

        if "\(maskString[index])" == "N" {
            let textToCompare: String = text[counter]
            if !textToCompare.isNumber {
                return false
            }
            textWithMask += text[counter]
            counter += 1
            return true
        }
        return nextChain?.scan(maskString: maskString, index: index,
                               counter: &counter, textWithMask: &textWithMask, text: text) ?? false
    }
}
