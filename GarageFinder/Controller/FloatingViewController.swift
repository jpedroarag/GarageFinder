//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {
    var fullView: CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    var middleView: CGFloat {
        return UIScreen.main.bounds.height * 0.55
    }
    var partialView: CGFloat {
        //TODO: Este valor deve ser de acordo com a Search bar
        return UIScreen.main.bounds.height  * 0.9
    }
    var allPos: [CGFloat]!
    var currentPos: CGFloat = 0
    var currentIndexPos = 0 {
        didSet {
            currentPos = allPos[currentIndexPos]
        }
    }
    
    var touchLocationY: CGFloat = 0
    lazy var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)

        allPos = [partialView, middleView, fullView]
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.bounces = false
        tableView.anchor
            .top(view.topAnchor, padding: 64)
            .bottom(view.bottomAnchor)
            .left(view.leftAnchor)
            .right(view.rightAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let frame = self?.view.frame,
                let yComponent = self?.partialView {
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            }
        })

    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            touchLocationY = recognizer.location(in: view).y
        }
        
        if tableView.contentOffset.y <= 0 || touchLocationY <= view.frame.height - partialView {
            scroll(recognizer)
        } else {
            recognizer.setTranslation(.zero, in: view)
        }

        let fullOrMiddleView = allPos[currentIndexPos] == fullView
        tableView.isScrollEnabled = fullOrMiddleView ? true : false
        endScroll(recognizer)
    }
    
    func scroll(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        let limit = minY + translation.y
        let bypassLimit = (limit >= 0) && (limit <= partialView)
        if bypassLimit {
            view.layer.removeAllAnimations()
            view.frame = CGRect(x: 0, y: limit, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(.zero, in: view)
        }
    }
    
    /// Perform animation when stop scrolling
    func endScroll(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            tableView.isScrollEnabled = true
            let minY = view.frame.minY
            
            let top = abs(minY - self.fullView)
            let middle = abs(minY - self.middleView)
            let bottom = abs(minY - self.partialView)
            
            let screenPositionValues: [CGFloat: CGFloat] = [top: self.fullView, middle: self.middleView, bottom: self.partialView]
            guard let min = screenPositionValues.min(by: { itemA, itemB in
                itemA.key < itemB.key
            }) else { return }
            
            let velocity = recognizer.velocity(in: view).y
            let isUp = velocity < 0
            let isDown = velocity > 0
            let limit = minY + recognizer.translation(in: view).y
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                //var currentPos = minY
                let canMoveUp = isDown && self.currentIndexPos != 0
                let canMoveDown = isUp && self.currentIndexPos != 2
                
                let didTouchedTop = self.tableView.contentOffset.y <= 0 || self.touchLocationY <= self.view.frame.height - self.partialView
                if (canMoveUp || canMoveDown) && didTouchedTop {
                    if self.currentPos == self.partialView && velocity < -1500 {
                        self.currentIndexPos += 2
                    } else if self.currentPos == self.fullView && velocity > 1500 {
                        self.currentIndexPos -= 2
                    } else {
                        self.currentIndexPos += canMoveUp ? -1 : 1
                    }
                } else if velocity == 0 || limit <= self.fullView {
                    self.currentIndexPos = self.allPos.firstIndex(of: min.value) ?? 0
                }
                
                if self.currentPos == self.middleView || self.currentPos == self.partialView {
                    let contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: 0)
                    self.tableView.setContentOffset(contentOffset, animated: true)
                }
                self.view.frame = CGRect(x: 0, y: self.currentPos, width: self.view.frame.width, height: self.view.frame.height)
            })
        }
    }
    
    func nukeAllAnimations() {
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
}

extension FloatingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FloatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell: \(indexPath.row)"
        return cell
    }
    
}
