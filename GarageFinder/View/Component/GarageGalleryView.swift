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
        view.layer.cornerRadius = 5
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "galleryCell")
        return view
    }()
    
    var photos: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    convenience init(images: [UIImage]) {
        self.init(frame: .zero)
        photos = images
        collectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        setConstraints()
    }
    
    private func setConstraints() {
        collectionView.anchor
        .top(topAnchor)
        .left(leftAnchor)
        .right(rightAnchor)
        .bottom(bottomAnchor)
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}

extension GarageGalleryView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        guard let width = photos[indexPath.item].cgImage?.width else {
            return .zero
        }
        if width > 300 {
            return CGSize(width: CGFloat(300), height: UIScreen.main.bounds.height * 0.2 - 10)
        } else {
            return CGSize(width: CGFloat(width), height: UIScreen.main.bounds.height * 0.2 - 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}
