//
//  GarageGalleryView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageGalleryView: UIView {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.rounded(cornerRadius: 5)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "galleryCell")
        
        return view
    }()
    
    var photos: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var dataSource: GarageGalleryDataSourceDelegate!
    weak var delegate: GarageGalleryDataSourceDelegate!
    
    convenience init(images: [UIImage?]) {
        self.init(frame: .zero)
        setDataSourceDelegate(images)
        photos = images
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        setDataSourceDelegate(photos)
        setConstraints()
        setLayer()
    }
    
    private func setDataSourceDelegate(_ photos: [UIImage?]) {
        let dataSourceDelegate = GarageGalleryDataSourceDelegate(photos)
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        dataSource = dataSourceDelegate
        delegate = dataSourceDelegate
    }
    
    private func setConstraints() {
        collectionView.anchor
        .top(topAnchor)
        .left(leftAnchor, padding: 16)
        .right(rightAnchor, padding: -5)
        .height(constant: 192)
    }
    
    private func setLayer() {
        rounded(cornerRadius: 5)
        shadowed()
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}
