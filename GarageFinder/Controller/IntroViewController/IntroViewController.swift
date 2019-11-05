//
//  IntroViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController {
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Próximo", for: .normal)
        return button
    }()
    
    let pageControl = UIPageControl()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [PagesIntroViewController(withPage: FirstPageIntroView()),
                PagesIntroViewController(withPage: SecondPageIntroView()),
                PagesIntroViewController(withPage: ThirdPageIntroView())]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        setPageControl()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
        
        if let thirdView = (orderedViewControllers.last as? PagesIntroViewController)?.pageView as? ThirdPageIntroView {
            thirdView.action = startUsingApp
        }
        
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    @objc func nextAction() {
        pageControl.currentPage += 1
        setViewControllers([orderedViewControllers[pageControl.currentPage]],
        direction: .forward,
        animated: true,
        completion: nil)
        
        if pageControl.currentPage == 2 {
            nextButton.alpha = 0
        }
    }
    
    func startUsingApp() {
        dismiss(animated: true, completion: nil)
    }
    
    func setPageControl() {
        pageControl.numberOfPages = 3
        view.addSubviews([pageControl, nextButton])
        
        pageControl.anchor
            .bottom(view.bottomAnchor, padding: UIScreen.main.bounds.height / 6.5)
            .centerX(view.centerXAnchor)
            .width(constant: 100)
            .height(constant: 100)
        
        nextButton.anchor
            .top(pageControl.bottomAnchor, padding: 16)
            .right(view.rightAnchor, padding: 16)
    }
}

extension IntroViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}

extension IntroViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstViewController = pendingViewControllers.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
            if index == 2 {
                nextButton.alpha = 0
            }
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
                if index != 2 {
                    nextButton.alpha = 1
                }
                pageControl.currentPage = index
        }
    }
}
