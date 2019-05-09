//
//  HomeCoordinator.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func transition(to target: TargetSource)
    func pop(animated: Bool)
    func presentSimpleDialog(alertViewModel: AlertViewModel)
}

struct AlertViewModel {
    var message, title: String
}

class HomeCoordinator: Coordinator {
    
    var rootViewController: UIViewController

    static var shared: HomeCoordinator?
    
    init(rootViewController: UIViewController){
        self.rootViewController = rootViewController
        HomeCoordinator.shared = self
    }
    
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
    
    func transition(to viewCotroller: UIViewController){
        actualViewController().navigationController?.pushViewController(viewCotroller, animated: true)
    }
    
    func transition(to target: TargetSource) {
        switch target {
        case let .movieDetail(movie):
            let viewController = UIStoryboard.main().instantiateViewController(withIdentifier: "movieDetailViewController") as! MovieDetailViewController
            viewController.movie = movie
            transition(to: viewController)
        }
    }
    
    func pop(animated: Bool) {
        actualViewController().navigationController?.popViewController(animated: animated)
    }
    
    func actualViewController() -> UIViewController {
        if let tabBarController = self.rootViewController as? UITabBarController {
            guard let selectedViewController = tabBarController.selectedViewController else { return tabBarController }
            
            if let navigationController = selectedViewController as? UINavigationController {
                return navigationController.viewControllers.first!
            }else {
                 return selectedViewController
            }
        }
        return rootViewController
    }
    
    func presentSimpleDialog(alertViewModel: AlertViewModel){
        let viewController = UIAlertController(title: alertViewModel.title, message: alertViewModel.message, preferredStyle: .alert)
        viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            viewController.dismiss(animated: true, completion: nil)
        }))
        actualViewController().present(viewController, animated: true, completion: nil)
    }
}
