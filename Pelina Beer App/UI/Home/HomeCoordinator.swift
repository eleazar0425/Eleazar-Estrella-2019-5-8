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
        let firstViewController = UIStoryboard.main().instantiateViewController(withIdentifier: "moviesPresentationViewController") as! MoviePresentationViewController
        firstViewController.title = "Pelina Beer App"
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        firstViewController.viewModel = MovieRemoteViewModel()
        
        let secondViewController = UIStoryboard.main().instantiateViewController(withIdentifier: "moviesPresentationViewController") as! MoviePresentationViewController
        secondViewController.title = "Favorites"
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        secondViewController.viewModel = MovieRemoteViewModel()
        
        return [UINavigationController(rootViewController: firstViewController), UINavigationController(rootViewController: secondViewController)]
    }
}
