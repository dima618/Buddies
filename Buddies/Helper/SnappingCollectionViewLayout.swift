//
//  SnappingCollectionViewLayout.swift
//  Buddies
//
//  Created by Dima Ilin on 4/22/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalOffset = proposedContentOffset.y + collectionView.contentInset.top
        
        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.y
            if fabsf(Float(itemOffset - verticalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
}
