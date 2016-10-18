//
//  AnimationHelper.swift
//  TestCollectionView
//
//  Created by Dmytro Lohush on 10/18/16.
//  Copyright © 2016 tester. All rights reserved.
//

import UIKit

struct AnimationHelper {
    static func translatedAndScaledTransformUsingViewRect(viewRect: CGRect, fromRect: CGRect) -> CATransform3D {
       let scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height)        
        let offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect))
        return CATransform3DMakeAffineTransform(CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y))
    }
}