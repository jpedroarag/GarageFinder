//
//  RatingView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class RatingView: UIView {
    
    var ratingAction: ((_ rating: Int) -> Void)?
    
    lazy var ratingButtons: [UIButton] = {
        var buttons: [UIButton] = []
        (0...4).forEach { _ in
            let btn = UIButton()
            btn.setBackgroundImage(UIImage(named: "rate"), for: .normal)
            btn.imageView?.contentMode = .scaleAspectFill
            buttons.append(btn)
        }
        return buttons
    }()
    
    lazy var contentButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let textViewPlaceholder = "Digite algo"
    let textViewMaxCharacters = 100
    lazy var shadowedView: UIView = {
        let shadowView = UIView()
        shadowView.shadowed()
        shadowView.layer.cornerRadius = 5
        return shadowView
    }()
    lazy var commentTextView: UITextView = {
        let textView = UITextView(fontSize: 16)
        textView.text = textViewPlaceholder
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()

    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([contentButtons, shadowedView])
        contentButtons.addArrangedSubviews(ratingButtons)
        shadowedView.addSubview(commentTextView)
        setupConstraints()
        
        ratingButtons.forEach {
            $0.addTarget(nil, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func tapRatingButton(_ sender: UIButton) {
        for (index, button) in ratingButtons.enumerated() {
            index <= sender.tag ? button.setImage("rate") : button.setImage("unfilled_star")
        }
        ratingAction?(sender.tag + 1)
    }
    
    func setupConstraints() {
        
        contentButtons.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 16)
            .height(constant: 30)
            .left(leftAnchor, padding: 76)
            .right(rightAnchor, padding: 76)

        for (index, button) in ratingButtons.enumerated() {
          button.tag = index
          button.anchor
              .width(constant: 30)
              .height(constant: 30)
        }
        
        shadowedView.anchor
            .top(contentButtons.bottomAnchor, padding: 24)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(constant: 80)
            .bottom(safeAreaLayoutGuide.bottomAnchor, padding: 24)
        
        commentTextView.anchor.attatch(to: shadowedView)
    }
}

extension RatingView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < textViewMaxCharacters
    }
}
