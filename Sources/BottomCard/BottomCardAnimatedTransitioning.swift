//
//  File.swift
//
//
//  Created by longvu on 25/05/2022.
//

import UIKit

class BottomCardAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool

    static func presenting() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: true)
    }

    static func dimissing() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: false)
    }

    private init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.21
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            guard let presentingViewController = transitionContext.viewController(forKey: .to) else {
                return
            }

            let targetViewFrame = transitionContext.finalFrame(for: presentingViewController)
            transitionContext.containerView.addSubview(presentingViewController.view)
            presentingViewController.view.frame = CGRect(x: targetViewFrame.minX,
                                                         y: transitionContext.containerView.bounds.maxY,
                                                         width: targetViewFrame.width,
                                                         height: targetViewFrame.height)

            let animator = UIViewPropertyAnimator(
                duration: 0.21,
                controlPoint1: CGPoint(x: 0.05, y: 0.76),
                controlPoint2: CGPoint(x: 0.42, y: 0.94)
            ) {
                presentingViewController.view.frame = targetViewFrame
            }

            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break

                @unknown default:
                    break
                }
            }

            animator.startAnimation()
        } else {
            guard let dismissingViewController = transitionContext.viewController(forKey: .from) else {
                return
            }

            let dismissingFrame = CGRect(x: dismissingViewController.view.frame.minX,
                                         y: transitionContext.containerView.bounds.maxY,
                                         width: dismissingViewController.view.frame.width,
                                         height: dismissingViewController.view.frame.height)

            let animator = UIViewPropertyAnimator(
                duration: 0.21,
                controlPoint1: CGPoint(x: 0.05, y: 0.76),
                controlPoint2: CGPoint(x: 0.42, y: 0.94)
            ) {
                dismissingViewController.view.frame = dismissingFrame
            }

            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break

                @unknown default:
                    break
                }
            }

            animator.startAnimation()
        }
    }
}
