//
//  GalleryCollectionViewCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 11/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.rounded(cornerRadius: 5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
    }
    
    private func setConstraints() {
        imageView.anchor
        .top(topAnchor)
        .left(leftAnchor)
        .right(rightAnchor)
        .bottom(bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
