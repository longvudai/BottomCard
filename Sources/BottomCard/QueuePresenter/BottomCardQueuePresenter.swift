//
//  Created by longvu on 25/05/2022.
//

import Foundation
import UIKit

@MainActor
class BottomCardQueuePresenter {
    struct ViewControllerPair {
        let presentingViewController: UIViewController
        let presentedViewController: UIViewController
        let transitionDelegate: UIViewControllerTransitioningDelegate?
        let animated: Bool
        let completion: (() -> Void)?

        init(
            presentingViewController: UIViewController,
            presentedViewController: UIViewController,
            transitionDelegate: UIViewControllerTransitioningDelegate? = nil,
            animated: Bool = true,
            completion: (() -> Void)? = nil
        ) {
            self.presentingViewController = presentingViewController
            self.presentedViewController = presentedViewController
            self.transitionDelegate = transitionDelegate
            self.animated = animated
            self.completion = completion
        }
    }

    private var controllerQueue = Queue<ViewControllerPair>()
    private var isPresenting = false

    static let shared = BottomCardQueuePresenter()

    init() {
        NotificationCenter.default.addObserver(
            forName: .didDismissPresentedViewController,
            object: nil,
            queue: nil
        ) { _ in
            DispatchQueue.main.async {
                self.isPresenting = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showNextAlertIfPresent()
                }
            }
        }
    }

    // MARK: - Present

    func enqueueViewControllerForPresentation(_ viewControllerPair: ViewControllerPair) {
        controllerQueue.enqueue(viewControllerPair)
        showNextAlertIfPresent()
    }

    private func showNextAlertIfPresent() {
        guard !isPresenting, let viewControllerPair = controllerQueue.dequeue() else {
            return
        }

        let source = viewControllerPair.presentingViewController
        let destination = viewControllerPair.presentedViewController
        destination.transitioningDelegate = viewControllerPair.transitionDelegate

        isPresenting = true
        source.present(destination, animated: viewControllerPair.animated, completion: viewControllerPair.completion)
    }
}
