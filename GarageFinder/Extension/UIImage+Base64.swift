//
//  UIImage+Base64.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIImage {
    func toBase64() -> String? {
        let data = jpegData(compressionQuality: .zero)
        return data?.base64EncodedString()
    }
}
