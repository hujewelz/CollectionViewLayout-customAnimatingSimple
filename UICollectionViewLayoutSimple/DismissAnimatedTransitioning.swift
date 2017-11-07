//
//  DismissAnimatedTransitioning.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/4.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

class DismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var destinationFrame: CGRect = CGRect.zero
    
    
    init(destinationFrame: CGRect = .zero) {
       self.destinationFrame =  destinationFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVc = transitionContext.viewController(forKey: .from) as? PresentedViewController
            ,let toVc = transitionContext.viewController(forKey: .to) as? ViewController else {
                return
        }
        

        guard let indexPath = toVc.collectionView.indexPathsForSelectedItems?.last,
            let selectedCell = toVc.collectionView.cellForItem(at: indexPath) else { return }
        
        let bg = UIView()
        bg.frame = transitionContext.finalFrame(for: fromVc)
        bg.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
        let initialFrame = fromVc.imageView.frame//transitionContext.finalFrame(for: fromVc)
        let finalFrame = destinationFrame
        
        let snapshot = fromVc.imageView.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = initialFrame

        containerView.addSubview(toVc.view)
        containerView.addSubview(bg)
       
        containerView.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            snapshot.frame = finalFrame
            
        }) { (finished) in
            let success = !transitionContext.transitionWasCancelled
            
            selectedCell.isHidden = false
            bg.removeFromSuperview()
            snapshot.removeFromSuperview()
           
            transitionContext.completeTransition(success)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            bg.alpha = 0
        }, completion: nil)
    }
    
}
