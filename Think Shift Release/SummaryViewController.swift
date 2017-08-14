//
//  SummaryViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import PDFGenerator

protocol SummaryItemViewController {
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
    
    enum ItemSection: Int {
        case think = 0
        case shift
        case release
    }

    var itemSection: ItemSection = .think
    
    var stressor: Stressor!
    
    fileprivate var currentViewController: UIViewController?
    
    fileprivate var currentIndex = 0
    
    
    fileprivate let items: [SummaryItem] = [SummaryItem(title: "Think", imageActive: #imageLiteral(resourceName: "thinkActive"), imageInactive: #imageLiteral(resourceName: "thinkInactive"), unselectedColor: UIColor.thinkGreen, viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "think")), SummaryItem(title: "Shift", imageActive: #imageLiteral(resourceName: "shiftActive"), imageInactive: #imageLiteral(resourceName: "shiftInactive"), unselectedColor: UIColor.shiftPurple , viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "shift")), SummaryItem(title: "Release", imageActive: #imageLiteral(resourceName: "releaseActive"), imageInactive: #imageLiteral(resourceName: "releaseInactive"), unselectedColor: UIColor.releaseBlue, viewController: UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateViewController(withIdentifier: "release"))]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.presentingViewController {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        }
        
        self.title = self.stressor.title
        
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2)
        
        self.showViewController(controller: items[0].viewController)
        
        // pre select first position
        self.collectionView.selectItem(at: IndexPath(item: self.itemSection.rawValue, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    fileprivate func showViewController(controller: UIViewController) {
        
        if (currentViewController != nil)
        {
            currentViewController?.willMove(toParentViewController: nil)
            currentViewController?.view.removeFromSuperview()
            currentViewController?.didMove(toParentViewController: nil)
        }
        
        controller.willMove(toParentViewController: self)
        self.vcContainerView.addSubview(controller.view)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: self.vcContainerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: self.vcContainerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: self.vcContainerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: self.vcContainerView.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
        
        currentViewController = controller
        
        if var itemViewController = controller as? SummaryItemViewController {
            itemViewController.stressor = self.stressor
        }
        
    }


    //MARK -- User Actions
    
    @IBAction func reminderAction(_ sender: Any) {
        
        
        guard let scheduler = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController else {
            assertionFailure()
            return
        }
        
        self.navigationController?.pushViewController(scheduler, animated: true)
    }
    
    @IBAction func close(_ sender: Any?) {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
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
