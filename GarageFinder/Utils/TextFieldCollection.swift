//
//  TextFieldCollection.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

protocol BaseTextField: UITextField {
    associatedtype TFType = Hashable
    var type: TFType {get set}
}

extension GFTextField: BaseTextField { }

struct TextFieldCollection<TFType: Hashable, TF: BaseTextField> {
    typealias DictionaryType = [TFType: [TF]]
    private var textFields = DictionaryType()
    
    mutating func insert(_ textField: TF) {
        guard let type = textField.type as? TFType else { return }
        if textFields[type] == nil {
            textFields[type] = [textField]
        } else {
            textFields[type]?.append(textField)
        }
    }
}

extension TextFieldCollection: Collection {
    typealias Index = DictionaryType.Index
    typealias Element = DictionaryType.Element
    
    var startIndex: Index { return textFields.startIndex }
    var endIndex: Index { return textFields.endIndex }
    
    func index(after index: Index) -> Index {
        return textFields.index(after: index)
    }
    
    subscript(index: Index) -> Element {
        return textFields[index]
    }
    
    subscript(_ key: Key) -> Value.Element {
        return textFields[key]?.first ?? TF()
    }
    
    subscript(_ key: Key) -> String {
        return textFields[key]?.first?.text ?? ""
    }
    
    subscript(_ key: Key, _ index: Int) -> Value.Element {
        guard let array = textFields[key], index < array.count else { return TF() }
        return array[index]
    }
    
    subscript(_ key: Key, _ index: Int) -> String {
        guard let array = textFields[key], index < array.count else { return "" }
        return array[index].text ?? ""
    }
    
    subscript(_ keys: Key ...) -> Value {
        var textFields: [TF] = []
        keys.forEach {
            if let field = self.textFields[$0] {
                textFields.append(contentsOf: field)
            }
        }
        return textFields
    }

    subscript(_ keys: Key ...) -> [String] {
        var values: [String] = []
        keys.forEach {
            if let field = self.textFields[$0] {
                field.forEach { values.append($0.text ?? "") }
            }
        }
        return values
    }
}

extension TextFieldCollection: ExpressibleByDictionaryLiteral {
    typealias Key = TFType
    typealias Value = [TF]
    
    init(dictionaryLiteral elements: (Key, Value)...) {
        for (tfType, tf) in elements {
            textFields[tfType] = tf
        }
    }
}
