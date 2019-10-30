//
//  ImagePickerTool+UIImagePickerControllerDelegate.swift
//  Itself
//
//  Created by João Paulo de Oliveira Sabino on 18/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UIKit

extension ImagePickerTool: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        guard let imageUrl = info[.originalImage] as? URL,
            let imageData = try? Data(contentsOf: imageUrl),
            let image = UIImage(data: imageData) else {
                
                if let image = info[.originalImage] as? UIImage {
                    imageCompletion?(ImageResult.image(image))
                    self.imagePickerController?.dismiss(animated: true, completion: nil)
                    return
                }
                imageCompletion?(ImageResult.canceled)
                
                return
        }
        imageCompletion?(ImageResult.image(image))
        self.imagePickerController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageCompletion?(ImageResult.canceled)
        self.imagePickerController?.dismiss(animated: true, completion: nil)
    }
}
