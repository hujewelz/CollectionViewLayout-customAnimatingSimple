//
//  WaterFallLayout.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

protocol WaterFallLayoutDelegate: NSObjectProtocol {
    func waterFallLayout(_ waterFallLayout: WaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class WaterFallLayout: UICollectionViewLayout {
    
    weak var delegate: WaterFallLayoutDelegate?
    
    @IBInspectable var itemSpace: CGFloat = 4
    @IBInspectable var edgeSpace: CGFloat = 4
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var maxYOfColums: [CGFloat] = []
    private var oldScreenWidth: CGFloat = 0
    
    @IBInspectable var numberOfColums = 2 {
        didSet {
            for _ in 0..<numberOfColums {
                maxYOfColums.append(0)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let maxY = maxYOfColums.max()!
        return CGSize(width: 0, height: maxY)
    }
    
    override func prepare() {
        super.prepare()
        
        for _ in 0..<numberOfColums {
            maxYOfColums.append(0)
        }
        
        layoutAttributes = computeLayoutAttributes()
        oldScreenWidth = UIScreen.main.bounds.width
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != oldScreenWidth
    }
    
    private func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        let totalNums = collectionView!.numberOfItems(inSection: 0)
        let width = (collectionView!.bounds.width - edgeSpace * 2 - itemSpace * CGFloat(numberOfColums - 1)) / CGFloat(numberOfColums)
        
        var x: CGFloat
        var y: CGFloat
        var height: CGFloat
        var currentColum: Int
        
        
        var layoutAttributesArr: [UICollectionViewLayoutAttributes] = []
        
        guard let delegate = delegate else {
            return layoutAttributesArr
        }
        
        for index in 0..<numberOfColums {
            maxYOfColums[index] = 0
        }
        
        var indexPath: IndexPath
        for currentIndex in 0..<totalNums {
            indexPath = IndexPath(item: currentIndex, section: 0)
            height = delegate.waterFallLayout(self, heightForItemAt: indexPath)
            
            if currentIndex < numberOfColums { // 第一行直接添加到当前的列
                currentColum = currentIndex
            } else { // 其他行添加到最短的那一列
                let minMaxY = maxYOfColums.min()!
                currentColum = maxYOfColums.index(of: minMaxY)!
            }
            
            x = edgeSpace + CGFloat(currentColum) * (width + itemSpace)
            y = itemSpace + maxYOfColums[currentColum]
            
            maxYOfColums[currentColum] = y + height
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            
            layoutAttributesArr.append(attributes)
        }
        
        return layoutAttributesArr
    }
}
