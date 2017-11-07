//
//  ViewController.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var destinationRect: CGRect = .zero
    
    private var presentAnimatedTrabsitioning = PresentAnimatedTransitioning()
    private var dismissAnimatedTrabsitioning = DismissAnimatedTransitioning()
    
    private var interactiveTransition = CustomInteractionController()
    
    fileprivate var itemHeights: [CGFloat] = []
    fileprivate lazy var images: [UIImage] = {
        return Array(0...9).flatMap{ UIImage(named: String(format: "%d.jpeg",$0))}
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.delegate = self
        
        let width = (self.view.frame.width - 10 * 3) / 2
        itemHeights = images.map { width * $0.size.height / $0.size.width }
        
        let layout = collectionView.collectionViewLayout as! WaterFallLayout
        layout.delegate = self
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? HomeCell else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let presentedVc = segue.destination as! PresentedViewController
        presentedVc.transitioningDelegate = self
        presentedVc.image = images[indexPath.item]
        destinationRect = collectionView.convert(cell.frame, to: self.view)
      //  interactiveTransition.write(to: presentedVc)
    }
    

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

extension ViewController: WaterFallLayoutDelegate {
    func waterFallLayout(_ waterFallLayout: WaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return itemHeights[indexPath.item]//CGFloat(200 + arc4random() % 100)
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            presentAnimatedTrabsitioning.originFrame = destinationRect
            return presentAnimatedTrabsitioning
        } else {
            dismissAnimatedTrabsitioning.destinationFrame = destinationRect
            return dismissAnimatedTrabsitioning
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteractionInProgress ? interactiveTransition : nil
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentAnimatedTrabsitioning.originFrame = destinationRect
        return presentAnimatedTrabsitioning
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimatedTrabsitioning.destinationFrame = destinationRect
        return dismissAnimatedTrabsitioning
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteractionInProgress ? interactiveTransition : nil
    }
}

