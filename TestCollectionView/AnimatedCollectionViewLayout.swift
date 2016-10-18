//
//  AnimatedCollectionViewLayout.swift
//  TestCollectionView
//
//  Created by tester on 10/17/16.
//  Copyright © 2016 tester. All rights reserved.
//

import UIKit

class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    var insertIndexes: [NSIndexPath] = []
    var deleteIndexes: [NSIndexPath] = []
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if insertIndexes.contains(itemIndexPath) {
            if let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes {
                attributes.center = CGPoint(x: -attributes.size.width/2, y: -attributes.size.height/2)
                return attributes
            }
        }
        return super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if deleteIndexes.contains(itemIndexPath){
            if let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes {
                attributes.alpha = 0
                attributes.transform = CGAffineTransformMakeScale(1.5, 1.5)
                return attributes
            }
        }
        return super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Delete:
                if let index = updateItem.indexPathBeforeUpdate {
                    self.deleteIndexes.append(index)
                }
                
            case .Insert:
                if let index = updateItem.indexPathAfterUpdate {
                    self.insertIndexes.append(index)
                }
            default: break
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        insertIndexes.removeAll()
        deleteIndexes.removeAll()
    }
}