//
//  ImagePickerSourceType.swift
//  Itself
//
//  Created by João Paulo de Oliveira Sabino on 18/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

import UIKit

extension UIImagePickerController.SourceType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .camera:
            return "Camera"
        case .photoLibrary:
            return "Photo Library"
        case .savedPhotosAlbum:
            return "Saved Photos"
        @unknown default:
            return "Unkown"
        }
    }
}
