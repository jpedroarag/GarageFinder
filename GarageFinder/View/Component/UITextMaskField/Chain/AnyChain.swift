//
//  AnyChain.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

class AnyChain: Chain {
    var nextChain: Chain?

    init(next: Chain? = nil) {
        self.nextChain = next
    }

    @discardableResult
    func scan(maskString: String, index: String.Index,
              counter: inout Int, textWithMask: inout String, text: String) -> Bool {
        if "\(maskString[index])" == "*" {
            textWithMask += text[counter]
            counter += 1
            return true
        }
        return nextChain?.scan(maskString: maskString, index: index,
                               counter: &counter, textWithMask: &textWithMask, text: text) ?? false
    }
}
