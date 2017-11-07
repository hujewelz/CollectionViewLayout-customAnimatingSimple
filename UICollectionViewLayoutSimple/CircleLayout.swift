//
//  CircleLayout.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

class CircleLayout: UICollectionViewLayout {
    
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    var totalNum = 0
    var center = CGPoint(x: 0, y: 0)
    var radius: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        totalNum = collectionView!.numberOfItems(inSection: 0)
        
        layoutAttributes = []
        
        center = CGPoint(x: collectionView!.bounds.width/2, y: collectionView!.bounds.height/2)
        
        radius = min(collectionView!.bounds.width, collectionView!.bounds.height) / 3.0
        
        var indexPath: IndexPath
        for index in 0..<totalNum {
            indexPath = IndexPath(item: index, section: 0)
            
            layoutAttributes.append(layoutAttributesForItem(at: indexPath)!)
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView!.bounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        attributes.size = CGSize(width: 60, height: 60)
        
        let angle = 2 * CGFloat.pi * CGFloat(indexPath.row ) / CGFloat(totalNum)
        
        attributes.center = CGPoint(x: center.x + radius*cos(angle), y: center.y + radius*sin(angle))
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
