//
//  OptionSelectorViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 21/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class OptionSelectorViewController: UIViewController {
    
    typealias Action = (String) -> Void
    var optionSelected: Action?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 96, height: 48)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(OptionSelectorCollectionViewCell.self, forCellWithReuseIdentifier: "optionCell")
        return view
    }()
    
    var options = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func setOptions(options: String...) {
        self.options = options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.anchor.attatch(to: view)
    }
    
}

extension OptionSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as? OptionSelectorCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.label.text = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        optionSelected?(options[indexPath.item])
    }
}
