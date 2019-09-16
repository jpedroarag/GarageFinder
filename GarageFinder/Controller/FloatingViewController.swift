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
        return UIScreen.main.bounds.height - floatingView.searchBar.frame.height * 2
    }()
    lazy var allPos: [CGFloat] = {
        return [partialView, middleView, fullView]
    }()

    weak var searchDelegate: SearchDelegate?
    var garageDetailVC: GarageDetailViewController?
    var mapView: MapView?
    
    var floatingView = FloatingView(frame: CGRect.zero)
    
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
    
    var favoriteGarages: [String] = ["Garagem1", "Garagem2", "Garagem3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGray
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        view.backgroundColor = .clear
        floatingView.tableView.register(FavAddressTableViewCell.self, forCellReuseIdentifier: "FavAddress")
        floatingView.tableView.register(FavGaragesTableViewCell.self, forCellReuseIdentifier: "FavGarages")
        setupFloatingView()
        setupObserver()
    }
    
    func setupFloatingView() {
        view.addSubview(floatingView)
        floatingView.searchBar.delegate = self
        floatingView.tableView.dataSource = self
        lastTable = floatingView.tableView
        
        floatingView.anchor
        .top(view.topAnchor)
        .left(view.leftAnchor)
        .right(view.rightAnchor)
        .bottom(view.bottomAnchor)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
    }
    
    @objc func finishSearch(_ notification: Notification) {
        animTo(positionY: partialView)
        cancellSearch()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            touchLocationY = recognizer.location(in: view).y
        }
        
        let iSTouchingSearchBar = touchLocationY <= floatingView.searchBar.frame.height * 0.9
        
//        let cell = floatingView.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FavAddressTableViewCell
//        let cellFrame = cell?.collectionView.frame
//        guard let touchInCell = cellFrame?.contains(recognizer.location(in: floatingView.tableView)) else { return }
        
        if lastTable.contentOffset.y <= 0 || iSTouchingSearchBar {
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
            
            let top = abs(minY - fullView)
            let middle = abs(minY - middleView)
            let bottom = abs(minY - partialView)
            
            let screenPositionValues: [CGFloat: CGFloat] = [top: fullView, middle: middleView, bottom: partialView]
            guard let min = screenPositionValues.min(by: { itemA, itemB in
                itemA.key < itemB.key
            }) else { return }
            
            let velocity = recognizer.velocity(in: view).y
            let isUp = velocity < -400
            let isDown = velocity > 400
            let limit = minY + recognizer.translation(in: view).y
            
            let canMoveUp = isDown && currentIndexPos != 0
            let canMoveDown = isUp && currentIndexPos != 2
            
            if canMoveUp || canMoveDown {
                if currentPos == partialView && velocity < -1500 {
                    currentIndexPos += 2
                } else if currentPos == fullView && velocity > 1500 {
                    currentIndexPos -= 2
                } else {
                    currentIndexPos += canMoveUp ? -1 : 1
                }
            } else if limit <= fullView {
                currentIndexPos = allPos.firstIndex(of: min.value) ?? 0
            }
            
            if currentPos == middleView || currentPos == partialView {
                let contentOffset = CGPoint(x: lastTable.contentOffset.x, y: 0)
                lastTable.setContentOffset(contentOffset, animated: true)
            }
            
            if currentPos == 0 { return }
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                           options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.view.frame = CGRect(x: 0, y: self.currentPos, width: self.view.frame.width, height: self.view.frame.height)
            })
        }
    }
    
    func animTo(positionY: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
                           options: [.curveEaseOut, .allowUserInteraction], animations: {
                            
                self.view.frame = CGRect(x: 0, y: positionY, width: self.view.frame.width, height: self.view.frame.height)

                self.currentIndexPos = self.allPos.firstIndex(of: positionY) ?? 0
            })
        }
    }
}

extension FloatingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //If the other gesture recognizer is CollectionView, dont recognize simultaneously
        if otherGestureRecognizer.view as? UICollectionView != nil {
            return false
        }
        return true
    }
}

// MARK: TableViewDataSource
extension FloatingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Endereços"
        default:
            return "Garagens"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return favoriteGarages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            if let favAddressCell = tableView.dequeueReusableCell(withIdentifier: "FavAddress", for: indexPath) as? FavAddressTableViewCell {
                cell = favAddressCell
            }
        default:
            if let favGaragesCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell {
                favGaragesCell.loadData(titleLabel: "Garagem de Marcus", address: "Av 13 de Maio, 152")
                cell = favGaragesCell
            }
        }

        return cell ?? UITableViewCell()
    }
    
}

extension FloatingViewController: UISearchBarDelegate {
    func showSearchVC() {
        
        guard let mapVC = self.parent as? MapViewController else { return }
        let searchVC = SearchResultViewController()
        searchVC.mapView = mapVC.mapView
        searchDelegate = searchVC
        lastTable = searchVC.tableView
        addChild(searchVC)
        view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)

        searchVC.view.frame = CGRect(x: 0, y: floatingView.searchBar.frame.height * 2,
                                     width: view.frame.width,
                                     height: view.frame.height)
    
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animTo(positionY: fullView)
        searchBar.showsCancelButton = true
        showSearchVC()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first as? SearchResultViewController {
            searchVC.didUpdateSearch(text: searchBar.text ?? "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        animTo(positionY: middleView)
        cancellSearch()
    }
    
    func cancellSearch() {
        floatingView.searchBar.text = ""
        floatingView.searchBar.showsCancelButton = false
        floatingView.searchBar.endEditing(true)

        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first {
            searchVC.removeFromParent()
            searchVC.view.removeFromSuperview()
            lastTable = floatingView.tableView
            
        }
    }
}

extension FloatingViewController: SelectGarageDelegate {
    func showGarageDetailVC() {
        if garageDetailVC == nil {
            garageDetailVC = GarageDetailViewController()
            guard let garageVC = garageDetailVC else { return }
            addChild(garageVC)
            view.addSubview(garageVC.view)
            garageVC.didMove(toParent: self)
            animTo(positionY: middleView)
        } else {
            removeGarageVC()
            showGarageDetailVC()
        }
    }
    
    func removeGarageVC() {
        garageDetailVC?.removeFromParent()
        garageDetailVC?.view.removeFromSuperview()
        garageDetailVC = nil
    }
    
    func didSelectGarage() {
        showGarageDetailVC()
    }
    
    func didDeselectGarage() {
    
    }
}
