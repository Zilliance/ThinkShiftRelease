//
//  SummaryViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import PDFGenerator

enum SummaryGoto {
    case thinkFirstSegment
    case thinkSecondSegment
    case shiftFirstSegment
    case shiftSecondSegment
    case release
}

protocol SummaryItemViewController {
    
    var goto: ((SummaryGoto) -> ())? { get set }
    var stressor: Stressor? { get set }
}

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var cardView: CardView!
    
    var item: SummaryItem? = nil {
        didSet {
            self.titleLabel.text = item?.title
            self.setupView()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.setupView()
        }
    }
    
    private func setupView () {
        self.titleLabel.textColor = isSelected ? .itemCellText : .white
        self.cardView.backgroundColor = isSelected ? .white : item?.unselectedColor
        self.iconImage.image = isSelected ? item?.imageActive : item?.imageInactive
        
    }
    
    
}

enum ItemSection: Int {
    case think = 0
    case shift
    case release
}

struct SummaryItem {
    let title: String
    let imageActive: UIImage
    let imageInactive: UIImage
    let unselectedColor: UIColor
    let viewController: UIViewController
    
}

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vcContainerView: UIView!

    var itemSection: ItemSection = .think
    
    var stressor: Stressor!
    var updatedStressor: ((Stressor) -> ())?
    
    fileprivate var currentViewController: UIViewController?
    fileprivate var currentIndex = 0
    
    fileprivate var tapHint: OnboardingPopover?
    
    fileprivate let items: [SummaryItem] = [
        SummaryItem(title: "Think", imageActive: #imageLiteral(resourceName: "thinkActive"), imageInactive: #imageLiteral(resourceName: "thinkInactive"), unselectedColor: UIColor.thinkGreen, viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "think")),
        SummaryItem(title: "Shift", imageActive: #imageLiteral(resourceName: "shiftActive"), imageInactive: #imageLiteral(resourceName: "shiftInactive"), unselectedColor: UIColor.shiftPurple , viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "shift")),
        SummaryItem(title: "Release", imageActive: #imageLiteral(resourceName: "releaseActive"), imageInactive: #imageLiteral(resourceName: "releaseInactive"), unselectedColor: UIColor.releaseBlue, viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "release"))
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.presentingViewController {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        }
        
        self.title = self.stressor.title
        
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2)
        
        self.showViewController(controller: items[self.itemSection.rawValue].viewController)
        
        // pre select first position
        self.collectionView.selectItem(at: IndexPath(item: self.itemSection.rawValue, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        if var item = items[0].viewController as? SummaryItemViewController {
            item.goto = {  [unowned self] goto in
                
                self.goto(summaryGoto: goto)
                
            }
        }
        
        self.showTapHint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let loadedVCs = self.items.map { $0.viewController }.filter { $0.isViewLoaded } as? [SummaryItemViewController]
        
        loadedVCs?.forEach({ item in
            var itemvc = item
            itemvc.stressor = self.stressor
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            if (self.isMovingToParentViewController || navigationController.isBeingDismissed) {
                self.updatedStressor?(self.stressor)
                self.updateDatabase()
            }
        }
        
        
    }
    
    private func updateDatabase() {
        
        let update = Database.shared.user.stressors.filter { $0.id == self.stressor.id }.count > 0
        
        if (update) {
            Database.shared.add(realmObject: self.stressor, update: true)
        }
        else {
            Database.shared.save {
                Database.shared.user.stressors.append(self.stressor)
            }
        }
    }
    
    
    fileprivate func showViewController(controller: UIViewController) {
        
        if (currentViewController != nil)
        {
            currentViewController?.willMove(toParentViewController: nil)
            currentViewController?.view.removeFromSuperview()
            currentViewController?.didMove(toParentViewController: nil)
        }
        
        self.vcContainerView.addSubview(controller.view)
        self.addChildViewController(controller)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: self.vcContainerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: self.vcContainerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: self.vcContainerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: self.vcContainerView.bottomAnchor)
            ])
        
        currentViewController = controller
        
        if var itemViewController = controller as? SummaryItemViewController {
            itemViewController.stressor = self.stressor
            
            itemViewController.goto = {  [unowned self] goto in
                
                self.goto(summaryGoto: goto)
                
            }

        }
        
    }

    fileprivate func goto(summaryGoto: SummaryGoto) {
        
        guard let thinkViewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateInitialViewController() as? ThinkViewController, let shiftViewController = UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateInitialViewController() as? ShiftViewController, let releaseViewController = UIStoryboard(name: "ReleaseViewController", bundle: nil).instantiateInitialViewController() as? ReleaseViewController else {
            assertionFailure()
            return
        }
        
        thinkViewController.stressor = self.stressor
        shiftViewController.stressor = self.stressor
        releaseViewController.stressor = self.stressor
        
        switch summaryGoto {
        case .thinkFirstSegment:
            thinkViewController.segment = 0
            self.navigationController?.pushViewController(thinkViewController, animated: true)
        case .thinkSecondSegment:
            thinkViewController.segment = 1
            self.navigationController?.pushViewController(thinkViewController, animated: true)
        case .shiftFirstSegment:
            shiftViewController.segment = 0
            self.navigationController?.pushViewController(shiftViewController, animated: true)
        case .shiftSecondSegment:
            shiftViewController.segment = 1
            self.navigationController?.pushViewController(shiftViewController, animated: true)
        case .release:
            releaseViewController.segment = 0
            self.navigationController?.pushViewController(releaseViewController, animated: true)
            
        }
    }

    //MARK -- User Actions
    
    @IBAction func close(_ sender: Any?) {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    // MARK: - Hint
    
    fileprivate func showTapHint() {
        guard !UserDefaults.standard.bool(forKey: "SummaryTapHintShown") else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let ss = self, ss.view.window != nil else {
                return
            }
            
            var center = CGPoint(x: ss.view.frame.midX, y: ss.view.frame.midY)
            center.y += 10
            
            ss.tapHint = OnboardingPopover()
            
            ss.tapHint?.title = "Click on any blank sections to complete the activities in each of the TSR tabs"
            ss.tapHint?.hasShadow = true
            ss.tapHint?.shadowColor = UIColor(white: 0, alpha: 0.4)
            ss.tapHint?.arrowLocation = .centeredOnTarget
            ss.tapHint?.present(in: ss.view, at: center, from: .below)
            
            UserDefaults.standard.set(true, forKey: "SummaryTapHintShown")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.dismissTapHint()
            }
        }
    }
    
    fileprivate func dismissTapHint() {
        self.tapHint?.dismiss()
    }
}

extension SummaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        let item = self.items[indexPath.row]
        cell.item = item
        
        return cell
        
    }
}

extension SummaryViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //change view controller.
        let newViewController = self.items[indexPath.row].viewController
        
        if (newViewController != currentViewController)
        {
            self.showViewController(controller: newViewController)
        }
        
        self.currentIndex = indexPath.row
    }
    
}

extension SummaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(self.items.count) - 8, height: 77)
    }
    
}

extension SummaryViewController {
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        self.generatePDF { [unowned self] (destinationURL,error) in
            
            if let destinationURL = destinationURL {
                
                let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
                
                self.present(activityViewController,
                             animated: true,
                             completion: nil)
            }
            else {
                
                //todo handle errors?
                
            }
            
        }
        
    }
    
    
    func generatePDF(completion: (URL?, Error?) -> ()) {
        let storyboard = UIStoryboard(name: "SummaryViewController", bundle: nil)
        
        let thinkVC = storyboard.instantiateViewController(withIdentifier: "think") as! SummaryThinkViewController
        thinkVC.view.frame = self.view.frame
        thinkVC.view.layoutIfNeeded()
        
        let shiftVC = storyboard.instantiateViewController(withIdentifier: "shift") as! SummaryShiftViewController
        shiftVC.mediaCardHidden = true
        shiftVC.view.frame = self.view.frame
        shiftVC.view.layoutIfNeeded()

        let releaseVC = storyboard.instantiateViewController(withIdentifier: "release") as! SummaryReleaseViewController
        releaseVC.breatheCardHidden = true
        releaseVC.view.frame = self.view.frame
        releaseVC.view.layoutIfNeeded() 
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("stressor.pdf"))
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([thinkVC.contentView, shiftVC.contentView, releaseVC.contentView], to: dst)
            
            print("PDF saved in: " + dst.absoluteString)
            completion(dst, nil)
            
        } catch (let error) {
            print(error)
            completion(nil, error)
        }
    }
    
    
}
