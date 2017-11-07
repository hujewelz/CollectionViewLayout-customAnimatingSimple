//
//  ScalelLayout.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

let PageWidth: CGFloat = 400


class ScaleLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scrollDirection = .horizontal
    }
    
    override func prepare() {
        super.prepare()
        
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.contentInset = UIEdgeInsets(
            top: 0,
            left: collectionView!.bounds.width / 2 - PageWidth / 2,
            bottom: 0,
            right: collectionView!.bounds.width / 2 - PageWidth / 2
        )
    }
    
    override var collectionViewContentSize: CGSize {
        let row = collectionView?.numberOfItems(inSection: 0) ?? 0
        return CGSize(width: CGFloat(row) * collectionView!.bounds.width, height: 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)!
        
        for attributes in array {
            let frame = attributes.frame
            
            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            //5
            let scale = 0.7 * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            //6
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
