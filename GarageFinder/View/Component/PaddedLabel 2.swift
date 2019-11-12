//
//  NoPictureView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 06/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class PaddedLabel: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setConstraints()
    }
    
    convenience init(text: String?) {
        self.init(frame: .zero)
        label.text = text
    }
    
    private func setConstraints() {
        label.anchor.attatch(to: self, paddings: [.top(15), .left(15), .right(15), .bottom(15)])
    }
    
    required init?(coder: NSCoder) { return nil }
}
