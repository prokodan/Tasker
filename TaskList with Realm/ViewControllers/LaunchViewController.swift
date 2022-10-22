//
//  LaunchViewController.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 10.10.2022.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
//MARK: - IBOutlets
    @IBOutlet var animationView: AnimationView!
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        animate()
    }

    //MARK: - Private Methods
    private func animate() {
        let taskAnimation = Animation.named("taskman")
        animationView.animation = taskAnimation
        animationView.loopMode = .repeat(2)
        animationView.play { _ in
            self.performSegue(withIdentifier: K.firstSegue, sender: nil)
        }
    }
}
