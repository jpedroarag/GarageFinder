//
//  ToolboxView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 30/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class ToolboxView: UIView {
    
    lazy var totalButtons = CGFloat(1)
    let minimumButtonSize = CGSize(width: 48, height: 48)
    var totalHeight: CGFloat {
        return totalButtons * minimumButtonSize.height + (totalButtons - 1)
    }
    
    var locationTrackerButton: MKUserTrackingButton!
    var separators = [UIView]()

    init(mapView: MapView, backgroundColor: UIColor, separatorColor: UIColor) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 5
        layer.masksToBounds = false
        
        configureButtons(mapView)
        setConstraints()
        insertSeparators(withColor: separatorColor)
    }
    
    private func configureButtons(_ mapView: MKMapView) {
        locationTrackerButton = MKUserTrackingButton(mapView: mapView)
        locationTrackerButton.tintColor = .white
        addSubview(locationTrackerButton)
    }
    
    func setConstraints() {
        locationTrackerButton.anchor
            .top(topAnchor)
            .left(leftAnchor)
            .right(rightAnchor)
            .height(constant: minimumButtonSize.height)
    }
    
    func setSeparatorConstraints(_ separator: UIView, topOffset: CGFloat) {
        separator.anchor
            .top(topAnchor, padding: topOffset)
            .left(leftAnchor, padding: 2)
            .right(rightAnchor, padding: 2)
            .height(constant: 1)
    }
    
    func insertSeparators(withColor color: UIColor) {
        for index in 0..<Int(totalButtons-1) {
            let separator = UIView(frame: .zero)
            separator.backgroundColor = color
            addSubview(separator)
            let topPosition = CGFloat(index+1) * minimumButtonSize.height
            setSeparatorConstraints(separator, topOffset: topPosition)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}