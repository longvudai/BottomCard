//
//  CustomPresentable.swift
//
//
//  Created by Long Vu on 7/7/24.
//

import Foundation
import UIKit

public protocol CustomPresentable: UIViewController {
    var transitionManager: UIViewControllerTransitioningDelegate? { get set }
    var dismissalHandlingScrollView: UIScrollView? { get }
    func updatePresentationLayout(animated: Bool)
}

public extension CustomPresentable {
    var dismissalHandlingScrollView: UIScrollView? { nil }
    var transitionManager: UIViewControllerTransitioningDelegate? { nil }

    func updatePresentationLayout(animated: Bool = true) {
        presentationController?.containerView?.setNeedsLayout()
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                options: .allowUserInteraction,
                animations: {
                    self.presentationController?.containerView?.layoutIfNeeded()
                },
                completion: nil
            )
        } else {
            presentationController?.containerView?.layoutIfNeeded()
        }
    }
}
