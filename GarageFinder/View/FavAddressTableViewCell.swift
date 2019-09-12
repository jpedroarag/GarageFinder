//
//  AddressTableViewCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FavAddressTableViewCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(FavAddressCollectionViewCell.self, forCellWithReuseIdentifier: "FavAddress")
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.anchor
            .top(topAnchor, padding: 16)
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 16)
            .height(constant: 80, priority: 999)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension FavAddressTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavAddress", for: indexPath) as? FavAddressCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
}

extension FavAddressTableViewCell: UICollectionViewDelegate {
    
}
