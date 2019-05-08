//
//  HomeViewController.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    let coordinator = HomeCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = coordinator.viewControllers()
    }
}
