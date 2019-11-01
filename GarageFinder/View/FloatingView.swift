//
//  FloatingView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
enum CurrentViewInFloating {
    case baseFloating
    case garageDetail
    case search
}

class FloatingView: UIView {
    lazy var parentView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.rounded(cornerRadius: 5)
        return headerView
    }()
    
    lazy var pinView: CircleView = {
        let pinView = CircleView()
        pinView.backgroundColor = .customLightGray
        return pinView
    }()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.shadowed()
        sb.placeholder = "Onde deseja estacionar?"
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.searchBarStyle = .minimal
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.backgroundColor = .white
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.textFieldBorderGray.cgColor
            textfield.layer.cornerRadius = 5
            textfield.clipsToBounds = true
        }
        return sb
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        lastScrollView = tableView
        tableView.register(FavAddressTableViewCell.self, forCellReuseIdentifier: "FavAddress")
        tableView.register(FavGaragesTableViewCell.self, forCellReuseIdentifier: "FavGarages")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bounces = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var lastScrollView: UIScrollView!
    var lastTouchY: CGFloat = 0
    var currentPos: CGFloat = 0
    var currentIndexPos = 0 {
        didSet {
            guard let pos = FloatingViewPosition(rawValue: currentIndexPos) else { return }
            floatingViewPositioningDelegate?.didEntered(in: pos)
            currentPos = allPos[currentIndexPos]
            if currentIndexPos == 1 || currentIndexPos == 0 {
                clearSearch()
            }
        }
    }
    weak var floatingViewPositioningDelegate: FloatingViewPositioningDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupParentView()
        setupPinView()
        setupSearchBar()
        setupTableView()

        let posX = frame.minX
        let width = frame.width
        let height = frame.height
        self.frame = CGRect(x: posX, y: partialView, width: width, height: height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupParentView() {
        addSubview(parentView)
        parentView.anchor
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .bottom(bottomAnchor)
            .top(topAnchor)        
    }
    
    func setupPinView() {
        parentView.addSubview(pinView)
        pinView.anchor
            .top(parentView.topAnchor, padding: 8)
            .centerX(parentView.centerXAnchor)
            .width(constant: 35)
            .height(constant: 5)
    }
    
    func setupSearchBar() {
        parentView.addSubview(searchBar)
        searchBar.anchor
            .top(pinView.bottomAnchor, padding: 8)
            .left(parentView.leftAnchor, padding: 8)
            .right(parentView.rightAnchor, padding: 8)
            .height(constant: 50)
    }
    
    func setupTableView() {
        parentView.addSubview(tableView)
        
        tableView.anchor
            .top(searchBar.bottomAnchor, padding: 50)
            .bottom(parentView.bottomAnchor, padding: fullView)
            .left(parentView.leftAnchor)
            .right(parentView.rightAnchor)
    }
    
    func clearSearch() {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        lastScrollView = tableView
    }
    
}

// MARK: Floating View Animations
extension FloatingView {
    var fullView: CGFloat {
        return UIScreen.main.bounds.height * 0.2
    }
    var middleView: CGFloat {
        return UIScreen.main.bounds.height * 0.65
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 100 
    }
    var allPos: [CGFloat] {
        return [partialView, middleView, fullView]
    }
    
    func startGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if lastScrollView == tableView {
                tableView.isScrollEnabled = true
            }
            lastTouchY = recognizer.location(in: self).y
        case .changed:
            let isTouchingSearchBar = lastTouchY <= searchBar.frame.height * 0.9

            if lastScrollView.contentOffset.y <= 0 || isTouchingSearchBar {
                scroll(recognizer)
            } else {
                recognizer.setTranslation(.zero, in: self)
            }
        case .cancelled, .ended:
            endScroll(recognizer)
        default: break
        }
    }
    
    func scroll(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let minY = frame.minY
        
        let limit = minY + translation.y
        let bypassLimit = (limit >= 0) && (limit <= partialView)
        
        if bypassLimit {
            frame = CGRect(x: frame.minX, y: limit, width: frame.width, height: frame.height)
            recognizer.setTranslation(.zero, in: self)
        }
    }
    
    /// Perform animation when stop scrolling
    func endScroll(_ recognizer: UIPanGestureRecognizer) {
        let minY = frame.minY
        
        let top = abs(minY - fullView)
        let middle = abs(minY - middleView)
        let bottom = abs(minY - partialView)
        
        //Return the min value to get the closest position
        let screenPositionValues: [CGFloat: CGFloat] = [top: fullView, middle: middleView, bottom: partialView]
        guard let min = screenPositionValues.min(by: { itemA, itemB in
            itemA.key < itemB.key
        }) else { return }
        
        let velocity = recognizer.velocity(in: self).y
        let isUp = velocity < -400
        let isDown = velocity > 400
        let canMoveUp = isDown && currentIndexPos != 0
        let canMoveDown = isUp && currentIndexPos != 2

        if (canMoveUp || canMoveDown) && lastScrollView.contentOffset.y <= 0 {
            
            if currentPos == partialView && velocity < -1500 {
                currentIndexPos += 2
            } else if currentPos == fullView && velocity > 1500 {
                currentIndexPos -= 2
            } else {
                currentIndexPos += canMoveUp ? -1 : 1
            }
        } else {
            let minPosition = allPos.firstIndex(of: min.value) ?? 0
            if currentIndexPos != minPosition {
                currentIndexPos = minPosition
            }
        }
        
        if currentPos == middleView || currentPos == partialView {
            lastScrollView.setContentOffset(CGPoint(x: lastScrollView.contentOffset.x, y: 0), animated: true)
            lastScrollView.isScrollEnabled = false
        } else {
            lastScrollView.isScrollEnabled = true
        }
        
        if currentPos == 0 { return }
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                       options: [.curveEaseOut, .allowUserInteraction], animations: {
                        
                        self.frame = CGRect(x: 0, y: self.currentPos,
                                            width: self.frame.width, height: self.frame.height)
        })
    }
    func animTo(positionY: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                           options: [.curveEaseOut, .allowUserInteraction], animations: {

                            self.frame = CGRect(x: 0, y: positionY, width: self.frame.width, height: self.frame.height)

                            let minPosition = self.allPos.firstIndex(of: positionY) ?? 0
                            if self.currentIndexPos != minPosition {
                                self.currentIndexPos = minPosition
                            }

            })
        }
    }
    
    func changeCurrentScrollView(_ scrollView: UIScrollView) {
        if lastScrollView == scrollView { return }
        lastScrollView = scrollView
        lastScrollView.isScrollEnabled = currentIndexPos == 2
    }
}
