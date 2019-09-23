//
//  SearchResultCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class SearchResultCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        setConstraints()
        
        // add shadow on cell and make rounded
        backgroundColor = .clear
        shadowed()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    }
    func loadData(name: String?, address: String?) {
        nameLabel.text = name
        addressLabel.text = address
    }
    
    func setConstraints() {
        
        nameLabel.anchor
            .top(topAnchor, padding: 21)
            .left(leftAnchor, padding: 24)
            .right(rightAnchor, padding: 24)
        
        addressLabel.anchor
            .top(nameLabel.bottomAnchor, padding: 5)
            .left(leftAnchor, padding: 24)
            .right(rightAnchor, padding: 24)
            .bottom(bottomAnchor, padding: 21)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
