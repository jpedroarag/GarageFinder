//
//  GarageGalleryDataSourceDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageGalleryDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var photos: [UIImage?]
    
    init(_ photos: [UIImage?]) {
        self.photos = photos
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let width = photos[indexPath.item]?.cgImage?.width else {
            return .zero
        }
        
        let maxWidth = UIScreen.main.bounds.width * 3/4
        let height = collectionView.bounds.height - 10
        let minWidth = height
        
        if CGFloat(width) > maxWidth {
            return CGSize(width: maxWidth, height: height)
        } else if CGFloat(width) < minWidth {
            return CGSize(width: minWidth, height: height)
        } else {
            return CGSize(width: CGFloat(width), height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
    }
    
}
