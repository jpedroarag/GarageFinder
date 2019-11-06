//
//  String+Base64.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension String {
    
    func base64Convert() -> UIImage? {
        let base = self.components(separatedBy: ",")
        if let contentBase = base.last, let data = Data(base64Encoded: contentBase, options: .ignoreUnknownCharacters) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
