//
//  DetailsTableViewCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 09/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(rgb: 0x000000, alpha: 60)
        return label
    }()
    
    var content: UIView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(sectionHeaderLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        sectionHeaderLabel.anchor
            .top(topAnchor, padding: 16)
            .left(leftAnchor, padding: 20)
            .right(rightAnchor, padding: 20)
    }
    
    typealias Paddings = (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat, height: CGFloat?)
    
    func addContentView(_ view: UIView) {
        content = view
        addSubview(view)
        
        var anchor: NSLayoutYAxisAnchor
        if sectionHeaderLabel.text == "" || sectionHeaderLabel.text == nil {
            anchor = topAnchor
        } else {
            anchor = sectionHeaderLabel.bottomAnchor
        }
        
        let paddingValues = paddings(forView: view)
        view.anchor
            .top(anchor, padding: paddingValues.top)
            .left(leftAnchor, padding: paddingValues.left)
            .right(rightAnchor, padding: paddingValues.right)
            .bottom(bottomAnchor, padding: paddingValues.bottom)

        if let height = paddingValues.height {
            view.anchor.height(constant: height)
        }
    }
    
    private func paddings(forView view: UIView) -> Paddings {
        
        var topPadding: CGFloat
        var bottomPadding: CGFloat
        var fixedHeight: CGFloat?
        
        if view is GarageInfoView {
            topPadding = 16
            bottomPadding = 16
        } else if view is GarageActionsView {
            topPadding = 0
            bottomPadding = 4
            fixedHeight = 48 + 8
        } else if view is GarageGalleryView {
            topPadding = 4
            bottomPadding = 16
            fixedHeight = 192
        } else if view is RentingDetailsView {
            topPadding = 4
            bottomPadding = 16
            let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            let height: CGFloat = "Value".heightOfString(usingFont: font)
            let insets: CGFloat = 16
            fixedHeight = (height + insets) * 4.0
        } else {
            topPadding = 4
            bottomPadding = 16
            if let ratingsTable = view as? UITableView {
                let rowHeight: CGFloat = 72
                let count = ratingsTable.dataSource?.tableView(ratingsTable, numberOfRowsInSection: 0) ?? 1
                let bottomInset = UIScreen.main.bounds.height * 0.3
                fixedHeight = rowHeight * CGFloat(count) + bottomInset
            }
        }
        
        return (topPadding, 0, bottomPadding, 0, fixedHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
