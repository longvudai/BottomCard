//
//  ViewController.swift
//  BottomCardExample
//
//  Created by longvu on 25/05/2022.
//

import BottomCard
import UIKit

class ViewController: UIViewController {
    private lazy var targetViewController = TargetViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        DispatchQueue.main.async {
            self.presentAsBottomCard(for: self.targetViewController, animated: true)
        }
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
