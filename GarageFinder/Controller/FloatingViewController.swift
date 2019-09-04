//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {
    lazy var fullView: CGFloat = {
        return UIScreen.main.bounds.height * 0.15
    }()
    lazy var middleView: CGFloat = {
        return UIScreen.main.bounds.height * 0.65
    }()
    lazy var partialView: CGFloat = {
        return UIScreen.main.bounds.height - searchBar.frame.height * 2
    }()
    lazy var allPos: [CGFloat] = {
        return [partialView, middleView, fullView]
    }()

    weak var searchDelegate: SearchDelegate?

    var mapView: MapView?
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Onde deseja estacionar?"
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return sb
    }()

    var currentPos: CGFloat = 0
    var currentIndexPos = 0 {
        didSet {
            currentPos = allPos[currentIndexPos]
            if currentIndexPos == 1 || currentIndexPos == 0 {
                cancellSearch()
            }
        }
    }
    var lastTable: UITableView!
    var touchLocationY: CGFloat = 0
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.9, alpha: 1)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        view.addSubview(searchBar)
        tableView.bounces = false
        searchBar.delegate = self
        
        searchBar.anchor
            .top(view.layoutMarginsGuide.topAnchor)
            .left(view.leftAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8)
            .height(constant: 50)
        tableView.anchor
            .top(searchBar.bottomAnchor)
            .bottom(view.bottomAnchor)
            .left(view.leftAnchor)
            .right(view.rightAnchor)
        
        setupObserver()
        
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
    
    override func viewDidLayoutSubviews() {
        guard let tbv = view.subviews.filter ({ $0 is UITableView }).last as? UITableView else { return }
        lastTable = tbv
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
    }
    
    @objc func finishSearch(_ notification: Notification) {
        animTo(index: 1)
        cancellSearch()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            touchLocationY = recognizer.location(in: view).y
        }
        
        if lastTable.contentOffset.y <= 0 || touchLocationY <= view.frame.height - partialView {
            scroll(recognizer)
        } else {
            recognizer.setTranslation(.zero, in: view)
        }

        let fullOrMiddleView = allPos[currentIndexPos] == fullView
        lastTable.isScrollEnabled = fullOrMiddleView ? true : false
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
            lastTable.isScrollEnabled = true
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
            
            let canMoveUp = isDown && currentIndexPos != 0
            let canMoveDown = isUp && currentIndexPos != 2
            
            let didTouchedTop = tableView.contentOffset.y <= 0 || touchLocationY <= self.view.frame.height - partialView
            if (canMoveUp || canMoveDown) && didTouchedTop {
                if currentPos == partialView && velocity < -1500 {
                    currentIndexPos += 2
                } else if currentPos == fullView && velocity > 1500 {
                    currentIndexPos -= 2
                } else {
                    currentIndexPos += canMoveUp ? -1 : 1
                }
            } else if velocity == 0 || limit <= self.fullView {
                currentIndexPos = allPos.firstIndex(of: min.value) ?? 0
            }
            
            if self.currentPos == self.middleView || currentPos == partialView {
                let contentOffset = CGPoint(x: lastTable.contentOffset.x, y: 0)
                lastTable.setContentOffset(contentOffset, animated: true)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                           options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                self.view.frame = CGRect(x: 0, y: self.currentPos, width: self.view.frame.width, height: self.view.frame.height)
            })
        }
    }
    
    func animTo(index: Int) {
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                       options: [.curveEaseOut, .allowUserInteraction], animations: {
                        
            self.view.frame = CGRect(x: 0, y: self.allPos[index], width: self.view.frame.width, height: self.view.frame.height)
            self.currentIndexPos = index
        })
    }
}

extension FloatingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FloatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print("CELL: \(cell)")
        cell.textLabel?.text = "Cell: \(indexPath.row)"
        return cell
    }
    
}

extension FloatingViewController: UISearchBarDelegate {
    func showSearchVC() {
        
        guard let mapVC = self.parent as? MapViewController else { return }
        let searchVC = SearchResultViewController()
        searchVC.mapView = mapVC.mapView
        searchDelegate = searchVC

        addChild(searchVC)
        view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)

        searchVC.view.frame = CGRect(x: 0, y: searchBar.frame.height,
                                     width: view.frame.width,
                                     height: view.frame.height)
    
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animTo(index: 2)
        searchBar.showsCancelButton = true
        showSearchVC()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first as? SearchResultViewController {
            searchVC.didUpdateSearch(text: searchBar.text ?? "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        animTo(index: 1)
        cancellSearch()
    }
    
    func cancellSearch() {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)

        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first {
            searchVC.removeFromParent()
            searchVC.view.removeFromSuperview()
            
        }
    }
}
