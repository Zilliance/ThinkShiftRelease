//
//  OnboardingPageViewController.swift
//  Zilliance
//
//  Created by ricardo hernandez  on 4/6/17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import UIKit
import ZillianceShared

class TourPageViewController: UIPageViewController {
    
    private enum OnboardingScene: String {
        case first
        case second
        case third
        case fourth
        case fifth
    }
    
    enum TourPresentationMode {
        case fromFaq
        case fromMenu
    }
    
    fileprivate(set) lazy var introViewControllers: [UIViewController]  = {
        
        var viewControllers: [UIViewController] = [
            self.viewController(for: .first),
            self.viewController(for: .second),
            self.viewController(for: .third),
            self.viewController(for: .fourth),
            self.viewController(for: .fifth),
            ]
        
        return viewControllers
        
    }()
    
    var presentationType: TourPresentationMode = .fromFaq
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // show pageview contoller full screen (remove dots gap)
        var scrollView: UIScrollView? = nil
        self.view.subviews.forEach { (view) in
            if let subview = view as? UIScrollView {
                scrollView = subview
            }
        }
        
        scrollView?.frame = self.view.bounds
        self.pageControl?.currentPageIndicatorTintColor = .navBar
        self.pageControl?.pageIndicatorTintColor = .silverColor
        self.view.bringSubview(toFront: self.pageControl!)
    }
    
    private func setupView() {
        
        if self.presentationType == .fromFaq {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeView))
        }
        else if self.presentationType == .fromMenu {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(backTapped))
        }
        
        self.view.backgroundColor = .contentBackground
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = self.introViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
            Analytics.shared.send(event: ZillianceAnalytics.DetailedEvents.tourPagedViewed(0))

        }
    }

    private func viewController(for scene: OnboardingScene) -> UIViewController {
        
        return UIStoryboard(name: "Tour", bundle: nil).instantiateViewController(withIdentifier:scene.rawValue)
    
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let currentVC = self.viewControllers?.first, let index = self.introViewControllers.index(of: currentVC) else {
            return
        }
        
        Analytics.shared.send(event: ZillianceAnalytics.DetailedEvents.tourClosed(index))
    }
    
    
    @IBAction func backTapped() {
        self.sideMenuController?.toggle()
    }
}

extension TourPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.introViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.introViewControllers.count > previousIndex else {
            return nil
        }
        
        return self.introViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.introViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.introViewControllers.count
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return self.introViewControllers[nextIndex]
    }
    

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.introViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = self.introViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}

extension TourPageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentVC = pageViewController.viewControllers?.first, let index = self.introViewControllers.index(of: currentVC) else {
            return
        }

        Analytics.shared.send(event: ZillianceAnalytics.DetailedEvents.tourPagedViewed(index))
    }
}

extension UIPageViewController {
    var pageControl: UIPageControl? {
        for view in self.view.subviews {
            if view is UIPageControl {
                return view as? UIPageControl
            }
        }
        return nil
    }
}
