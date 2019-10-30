//
//  ChainLimitation.swift
//  labelf
//
//  Created by Elias Paulino on 29/08/19.
//  Copyright © 2019 LDS. All rights reserved.
//

import UIKit

open class UITextMaskField: UITextField {
    private var _mask: String!

    private let responsabilityChain = NumberChain(next:
        CharacterChain(limitation: .onlyUpper, isNumberBlocked: true, next:
        CharacterChain(limitation: .onlyUpper, isNumberBlocked: true, next:
        CharacterChain(limitation: .any, isNumberBlocked: true, next:
        CharacterChain(limitation: .any, isNumberBlocked: false, next:
        CharacterChain(limitation: .onlyUpper, isNumberBlocked: true, next:
        CharacterChain(limitation: .onlyLower, isNumberBlocked: true, next:
        AnyChain(next: DefaultChain()))))))))

    @IBInspectable public var maskString: String {
        get {
            return _mask
        }
        set {
            _mask = newValue
        }
    }

    public func applyFilter(textField: UITextField) {

        if _mask == nil ||
           _mask.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
            return
        }

        var textWithMask: String = ""
        var counter: Int = 0
        var text: String = textField.text ?? ""

        if text.isEmpty {
            return
        }

        text = removeMaskCharacters(text: text, withMask: maskString)

        for item in maskString.enumerated() {
            let index = maskString.index(maskString.startIndex, offsetBy: item.offset)

            if counter >= text.count {
                self.text = textWithMask
                break
            }

            responsabilityChain.scan(maskString: maskString, index: index,
                                     counter: &counter, textWithMask: &textWithMask, text: text)
        }

        self.text = textWithMask
    }

    public func isNumber(textToValidate: String) -> Bool {

        let num = Int(textToValidate)

        if num != nil {
            return true
        }

        return false
    }

    public func hasSpecialCharacter(searchTerm: String) -> Bool {
        guard let regex = try? NSRegularExpression(
            pattern: ".*[^A-Za-z0-9].*",
            options: NSRegularExpression.Options()) else {

            return false
        }

        if regex.firstMatch(
            in: searchTerm,
            options: NSRegularExpression.MatchingOptions(),
            range: NSRange(location: 0, length: searchTerm.count)) != nil {
            return true
        }

        return false
    }

    public func removeMaskCharacters(text: String, withMask mask: String) -> String {

        let mask = ["X", "N", "C", "c", "U", "u", "*"]
            .reduce(mask, { (currentMask, currentItem) -> String in
            currentMask.replacingOccurrences(of: currentItem, with: "")
        })

        let text = mask.reduce(text) { (currentText, currentMaskChar) -> String in
            currentText.replacingOccurrences(of: "\(currentMaskChar)", with: "")
        }

        return text
    }
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addTarget(self, action: #selector(textFieldDidChange(textField:)),
        for: UIControl.Event.editingChanged)
    }

    @objc func textFieldDidChange(textField: UITextField) {
        applyFilter(textField: textField)
    }
}
