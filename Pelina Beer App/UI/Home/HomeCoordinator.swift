//
//  HomeCoordinator.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator {
    func viewControllers() -> [UIViewController]{
        let firstViewController = UIStoryboard.main().instantiateViewController(withIdentifier: "moviesPresentationViewController")
        firstViewController.title = "Pelina Beer App"
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        let secondViewController = UIStoryboard.main().instantiateViewController(withIdentifier: "moviesPresentationViewController")
        secondViewController.title = "Favorites"
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return [UINavigationController(rootViewController: firstViewController), UINavigationController(rootViewController: secondViewController)]
    }
}
