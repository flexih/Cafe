//
//  TransitionAnimator.swift
//  coffee
//
//  Created by flexih on 1/19/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Async

class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animation = CABasicAnimation(keyPath: "path")
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func circleRect(radius radius: CGFloat) -> CGRect {
        return CGRect(x: -radius, y: -radius, width: radius * 2, height:radius * 2)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        containerView.addSubview(toView)
        
        toView.frame = UIEdgeInsetsInsetRect(containerView.bounds, UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        
        let size = UIScreen.mainScreen().bounds.size
        let diagonal = ceil(sqrt(size.width * size.width + size.height * size.height))
        let startPath = UIBezierPath(ovalInRect: circleRect(radius: 27))
        let endPath = UIBezierPath(ovalInRect: circleRect(radius: diagonal))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.CGPath
        
        animation.fromValue = startPath.CGPath
        animation.toValue = endPath.CGPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = transitionDuration(transitionContext)
        animation.delegate = AnimationDelegate {
            toView.layer.mask = nil
            containerView.insertSubview(fromView, aboveSubview: toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            self.animation.delegate = nil
        }
        
        toView.layer.mask = maskLayer
        maskLayer.frame = toView.bounds
        maskLayer.addAnimation(animation, forKey: "reveal")
    }
}

class TransitionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    static var sharedAnimator = TransitionAnimator()
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimation()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}