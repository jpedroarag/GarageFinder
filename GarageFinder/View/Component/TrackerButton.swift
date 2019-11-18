//
//  TrackerButton.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 08/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class TrackerButton: UIButton {
    
    weak var mapView: MKMapView?
    lazy var mode: MKUserTrackingMode = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "tracker(0)")
        setImage(image, for: .normal)
        addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        backgroundColor = .clear
        rounded(cornerRadius: 5)
    }
    
    convenience init(mapView: MKMapView?) {
        self.init(frame: .zero)
        self.mapView = mapView
    }
    
    @objc func tapped(_ sender: TrackerButton) {
        switchMode(current: mode)
        mapView?.userTrackingMode = mode
    }
    
    func switchMode(current: MKUserTrackingMode) {
        switch current {
        case .none:
            mode = .follow
        case .follow:
            mode = .followWithHeading
        case .followWithHeading:
            mode = .none
        @unknown default: return
        }
    }
    
    func switchToImage(named imageName: String, animated: Bool = false) {
        let image = UIImage(named: imageName)
        if animated {
            UIView.animate(withDuration: 0.1725, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                self.alpha = 0
            }, completion: { _ in
                self.setImage(image, for: .normal)
                UIView.animate(withDuration: 0.1725, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                    self.alpha = 1
                }, completion: nil)
            })
        } else {
            setImage(image, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
