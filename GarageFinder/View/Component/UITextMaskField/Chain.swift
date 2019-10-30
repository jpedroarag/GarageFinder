//
//  Chain.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import Foundation

protocol Chain: AnyObject {
    var nextChain: Chain? { get set }

    @discardableResult
    func scan(maskString: String, index: String.Index,
              counter: inout Int, textWithMask: inout String, text: String) -> Bool
}
