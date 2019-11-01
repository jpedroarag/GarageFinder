//
//  UIImage+Base64.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func toBase64() -> String? {
        guard let img = resizeWithPercent(percentage: 0.3) else { return nil}
        let data = img.jpegData(compressionQuality: .zero)
        return data?.base64EncodedString()
    }
}
