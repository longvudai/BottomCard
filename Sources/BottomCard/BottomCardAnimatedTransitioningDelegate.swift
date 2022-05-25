//
//  File.swift
//  
//
//  Created by longvu on 25/05/2022.
//

import UIKit

class BottomCardAnimatedTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let configuration: ButtomCardConfiguration
    init(configuration: ButtomCardConfiguration) {
        self.configuration = configuration
        super.init()
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.dimissing()
    }

    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.presenting()
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source _: UIViewController) -> UIPresentationController? {
        return BottomCardPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            configuration: configuration
        )
    }
}
