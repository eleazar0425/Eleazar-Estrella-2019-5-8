//
//  HomeViewController.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = HomeCoordinator(rootViewController: self)
        self.viewControllers = coordinator?.viewControllers()
    }
}
