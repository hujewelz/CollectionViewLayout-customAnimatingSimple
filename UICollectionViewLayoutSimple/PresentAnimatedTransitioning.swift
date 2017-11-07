//
//  PresentAnimatedTransitioning.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

class PresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame: CGRect = CGRect.zero
    
    init(originFrame: CGRect = .zero) {
        self.originFrame =  originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVc = transitionContext.viewController(forKey: .from) as? ViewController
            ,let toVc = transitionContext.viewController(forKey: .to) as? PresentedViewController else {
                return
        }
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVc)
        
        guard let indexPath = fromVc.collectionView.indexPathsForSelectedItems?.last,
            let selectedCell = fromVc.collectionView.cellForItem(at: indexPath) else { return }
        
        let snapshot = toVc.view.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = initialFrame
        
        toVc.view.isHidden = true
        containerView.addSubview(snapshot)
        containerView.addSubview(toVc.view)
        
        selectedCell.isHidden = true
       
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            snapshot.frame = finalFrame
           
        }) { (finished) in
            toVc.view.isHidden = false
          
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
    
}
