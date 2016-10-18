//
//  FullScreenAnimationController.swift
//  TestCollectionView
//
//  Created by Dmytro Lohush on 10/18/16.
//  Copyright © 2016 tester. All rights reserved.
//

import UIKit

class FullScreenAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController)?.viewControllers[0] as? ViewController,
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? FullScreenViewController else {
                return
        }
        
        let cell = fromVC.collectionView.cellForItemAtIndexPath(fromVC.tappedItemIndexPath!)!
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        let oldPosition = cell.layer.position
        let oldFrame = cell.layer.frame
        let newLayerPosition = CGPoint(x:cell.layer.position.x, y: cell.layer.frame.height/2)
        
        
        containerView.addSubview(toVC.view)
        toVC.view.hidden = true

        let duration = transitionDuration(transitionContext)
        
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: {
                    cell.layer.position = newLayerPosition
                })

                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: {
                    cell.layer.transform = AnimationHelper.translatedAndScaledTransformUsingViewRect(finalFrame, fromRect: cell.layer.frame)
                })
            },
            completion: { _ in
                cell.layer.position = oldPosition
                cell.layer.frame = oldFrame
                toVC.view.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}



