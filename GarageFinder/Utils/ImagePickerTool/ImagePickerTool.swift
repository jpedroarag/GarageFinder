//
//  ImagePickerTool.swift
//  Itself
//
//  Created by João Paulo de Oliveira Sabino on 18/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UIKit

typealias Option = (name: String, completion: () -> Void)

class ImagePickerTool: NSObject {
    var imageCompletion: ((_ image: ImageResult) -> Void)?
    
    var imagePickerController: UIImagePickerController?
    
    private func showImagePicker(parentViewController: UIViewController,
                                 _ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        parentViewController.show(imagePicker, sender: self)
        
        self.imagePickerController = imagePicker
    }
    
    /// Gets a image using a UIImagePickerController.
    ///
    /// - Parameters:
    ///   - sources: The sources from where get the image.
    ///   - parentViewController: the controller that will present the image picker
    ///   - imageCompletion: a completion that returns the image or a "cancel"
    func getImage(from sources: [UIImagePickerController.SourceType],
                  parentViewController: UIViewController,
                  imageCompletion: @escaping (_ image: ImageResult) -> Void) {
        
        self.imageCompletion = imageCompletion
        
        let options: [Option] = sources.map { (sourceType) -> Option in
            return (name: "\(sourceType)",
                completion: { [weak self] in
                    self?.showImagePicker(
                        parentViewController: parentViewController,
                        sourceType
                    )
                }
            )
        }
        
        let alertController = makeOptionsAlert(options: options)
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    private func makeOptionsAlert(options: [Option]) -> UIAlertController {
        let alertController = UIAlertController()
        
        options.map { (option) -> UIAlertAction in
            UIAlertAction(title: option.name, style: .default, handler: { (_) in
                option.completion()
            })
            }.forEach { (action) in
                alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        return alertController
    }
}
