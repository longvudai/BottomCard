//
//  File.swift
//
//
//  Created by longvu on 25/05/2022.
//

import Combine
import UIKit

public struct ButtomCardConfiguration {
    let isObserveKeyboard: Bool
    let isSnapshotBackground: Bool
    let widthOffset: CGFloat
    let bottomOffset: CGFloat
    let maxWidth: CGFloat

    public init(
        isObserveKeyboard: Bool = true,
        isSnapshotBackground: Bool = true,
        widthOffset: CGFloat = 32,
        bottomOffset: CGFloat = 32,
        maxWidth: CGFloat = 400
    ) {
        self.isObserveKeyboard = isObserveKeyboard
        self.isSnapshotBackground = isSnapshotBackground
        self.widthOffset = widthOffset
        self.bottomOffset = bottomOffset
        self.maxWidth = maxWidth
    }
}

public enum BottomCardPresentationContentSizing {
    case autoLayout
    case preferredContentSize(size: CGSize)
}

public protocol BottomCardPresentationControllerDelegate: AnyObject {
    func presentedViewControllerDidDimiss()
}

class BottomCardPresentationController: UIPresentationController {
    private lazy var backdropView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "OverlayBackdrop", in: .module, compatibleWith: nil)
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBackdrop))
        v.addGestureRecognizer(tap)
        return v
    }()

    private lazy var presentingViewSnapshot: UIView? = presentingViewController.view
        .snapshotView(afterScreenUpdates: true)

    private var widthOffset: CGFloat { configuration.widthOffset }
    private var bottomOffset: CGFloat { configuration.bottomOffset }
    private var maximumContentSize: CGSize {
        guard let containerView else {
            return .zero
        }

        let maxWidth: CGFloat = configuration.maxWidth

        return CGSize(width: min(maxWidth, containerView.frame.width - widthOffset),
                      height: containerView.frame.height - bottomOffset)
    }

    private var cancellableSet = Set<AnyCancellable>()
    private var keyboardHeight = CurrentValueSubject<CGFloat, Never>(0)
    private lazy var keyboardManager: KeyboardManager = .init()

    private let configuration: ButtomCardConfiguration

    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        configuration: ButtomCardConfiguration = ButtomCardConfiguration()
    ) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupKeyboardSubscriptionsIfNeeded()
    }

    private func setupKeyboardSubscriptionsIfNeeded() {
        if configuration.isObserveKeyboard {
            cancellableSet = []

            let kbPresentation = keyboardManager.keyboardPresetationInfo
                .removeDuplicates(by: { $0.keyboardSize.height == $1.keyboardSize.height })

            kbPresentation
                .map(\.keyboardSize.height)
                .sink(receiveValue: { [weak self] value in
                    self?.keyboardHeight.value = value
                })
                .store(in: &cancellableSet)

            keyboardHeight
                .withLatestFrom(kbPresentation, resultSelector: { $1 })
                .map(\.animationDuration)
                .sink(receiveValue: { [weak self] animationDuration in
                    UIView.animate(
                        withDuration: animationDuration,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {
                            self?.containerView?.setNeedsLayout()
                            self?.containerView?.layoutIfNeeded()
                        }, completion: nil
                    )
                })
                .store(in: &cancellableSet)
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }

        var contentSize: CGSize = .zero

        if let presentationBehavior = presentedViewController as? PresentationBehavior {
            let style = presentationBehavior.bottomCardPresentationContentSizing
            switch style {
            case .autoLayout:
                let targetSize = CGSize(
                    width: min(maximumContentSize.width, containerView.frame.width),
                    height: min(maximumContentSize.height, containerView.frame.height)
                )

                // make sure we can calculate swiftui view content correctly
                _ = presentedView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

                contentSize = presentedView?.systemLayoutSizeFitting(
                    targetSize,
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ) ?? containerView.frame.size

            case let .preferredContentSize(preferredContentSize):
                contentSize = CGSize(
                    width: min(maximumContentSize.width, preferredContentSize.width),
                    height: min(maximumContentSize.height, preferredContentSize.height)
                )
            }
        } else {
            contentSize = CGSize(
                width: min(maximumContentSize.width, containerView.frame.width),
                height: min(maximumContentSize.height, presentedViewController.preferredContentSize.height)
            )
        }

        let newFrame = CGRect(
            x: containerView.bounds.midX - (contentSize.width / 2),
            y: containerView.bounds.height - contentSize.height - bottomOffset - keyboardHeight.value,
            width: contentSize.width,
            height: min(UIScreen.main.bounds.height, contentSize.height)
        )

        return newFrame
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentingViewSnapshot?.frame = containerView?.bounds ?? .zero
        backdropView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView else {
            return
        }

        if let presentingViewSnapshot, configuration.isSnapshotBackground {
            containerView.addSubview(presentingViewSnapshot)
        }

        containerView.addSubview(backdropView)

        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 1
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 0
            }, completion: { [weak self] _ in
                self?.backdropView.removeFromSuperview()
                self?.presentingViewSnapshot?.removeFromSuperview()

                if let source = self?.presentingViewController as? BottomCardPresentationControllerDelegate {
                    source.presentedViewControllerDidDimiss()
                }
            })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        NotificationCenter.default.post(name: .didDismissPresentedViewController, object: nil)
    }

    @objc
    private func handleTapOnBackdrop() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

private extension BottomCardPresentationController {
    final class KeyboardManager {
        struct KeyboardPresetationInfo {
            let animationDuration: TimeInterval
            let keyboardSize: CGSize
        }

        // MARK: Properties

        var keyboardPresetationInfo: AnyPublisher<KeyboardPresetationInfo, Never> {
            return keyboardPresetationInfoSubject.eraseToAnyPublisher()
        }

        private var keyboardPresetationInfoSubject = CurrentValueSubject<KeyboardPresetationInfo,
            Never>(KeyboardPresetationInfo(
            animationDuration: 0,
            keyboardSize: .zero
        ))

        private let notificationCenter = NotificationCenter.default
        private var cancellableSet = Set<AnyCancellable>()

        // MARK: Lifecycle

        init() {
            let kbWillHide = notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
                .compactMap { notification -> KeyboardPresetationInfo? in
                    if let animationTime = notification
                        .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                        return KeyboardPresetationInfo(
                            animationDuration: TimeInterval(animationTime.intValue),
                            keyboardSize: .zero
                        )
                    } else {
                        return nil
                    }
                }

            let kbWillShow = notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { notification -> KeyboardPresetationInfo? in
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                        .cgRectValue,
                        let animationTime = notification
                        .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                        return KeyboardPresetationInfo(
                            animationDuration: TimeInterval(animationTime.intValue),
                            keyboardSize: keyboardSize.size
                        )
                    } else {
                        return nil
                    }
                }

            Publishers.Merge(kbWillHide, kbWillShow)
                .subscribe(keyboardPresetationInfoSubject)
                .store(in: &cancellableSet)
        }
    }
}

extension Notification.Name {
    static let didDismissPresentedViewController = Notification.Name(rawValue: "didDismissPresentedViewController")
}
