//
//  ViewController.swift
//  BottomCardExample
//
//  Created by longvu on 25/05/2022.
//

import BottomCard
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let showButton = UIButton(
            configuration: .filled(),
            primaryAction: UIAction(title: "Show Bottom Card") { [weak self] _ in
                self?.presentAsBottomCard(for: TargetViewController(), animated: true)
            }
        )
        showButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showButton)

        NSLayoutConstraint.activate([
            showButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            showButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        ])
    }
}

class TargetViewController: UIViewController, PresentationBehavior {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        view.layer.cornerRadius = 10
    }

    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing {
        return .preferredContentSize(size: CGSize(width: 300, height: 300))
    }
}
