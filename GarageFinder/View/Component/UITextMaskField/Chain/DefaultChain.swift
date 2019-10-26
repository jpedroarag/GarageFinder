//
//  DefaultChain.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

class DefaultChain: Chain {
    var nextChain: Chain?

    init(next: Chain? = nil) {
        self.nextChain = next
    }

    @discardableResult
    func scan(maskString: String, index: String.Index,
              counter: inout Int, textWithMask: inout String, text: String) -> Bool {
        textWithMask += "\(maskString[index])"
        return true
    }
}
