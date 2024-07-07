//
//  File.swift
//
//
//  Created by longvu on 25/05/2022.
//

import UIKit

public extension UIViewController {
    func presentAsBottomCard(
        for targetViewController: UIViewController,
        animated: Bool,
        completionHandler: (() -> Void)? = nil
    ) {
        presentAsBottomCard(
            configuration: ButtomCardConfiguration(),
            for: targetViewController,
            animated: animated,
            completionHandler: completionHandler
        )
    }

    func presentAsBottomCard(
        configuration: ButtomCardConfiguration,
        for targetViewController: UIViewController,
        animated: Bool,
        completionHandler: (() -> Void)? = nil
    ) {
        targetViewController.modalPresentationStyle = .custom

        BottomCardQueuePresenter.shared.enqueueViewControllerForPresentation(.init(
            presentingViewController: self,
            presentedViewController: targetViewController,
            transitionDelegate: BottomCardAnimatedTransitioningDelegate(configuration: configuration),
            animated: animated,
            completion: completionHandler
        ))
    }
}
