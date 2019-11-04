//
//  MainIntroView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class MainIntroView: UIView {
    lazy var scrollView = UIScrollView()
    lazy var firstPage = FirstPageIntroView()
    lazy var secondPage = SecondPageIntroView()
    
    override func didMoveToSuperview() {
        backgroundColor = .blue
        addSubview(scrollView)
        scrollView.addSubviews([firstPage, secondPage])
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.anchor.attatch(to: safeAreaLayoutGuide)
        
        firstPage.anchor
            .top(scrollView.topAnchor)
            .left(scrollView.leftAnchor)
            .bottom(scrollView.bottomAnchor)
            .width(constant: UIScreen.main.bounds.width - 100)
            .height(constant: UIScreen.main.bounds.height)
        
        secondPage.anchor
            .top(scrollView.topAnchor)
            .left(firstPage.rightAnchor)
            .bottom(scrollView.bottomAnchor)
            .width(constant: UIScreen.main.bounds.width)
    }
}
