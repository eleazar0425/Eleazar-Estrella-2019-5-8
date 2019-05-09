//
//  MoviePresentationViewController.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Mapper
import Nuke


class MoviePresentationViewController: UIViewController {
    @IBOutlet weak var colllectionView: UICollectionView!
    var viewModel: MovieViewModelType!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bind movies to collectionView
        viewModel.movies.bind(to: self.colllectionView.rx.items(cellIdentifier: "movieCollectionViewCell", cellType: MovieCollectionViewCell.self)) { row, movie, cell in
            cell.bind(movie: movie)
        }.disposed(by: disposeBag)
        
        //Binds contentOffset to viewmodel#loadMore, so it will emit true or false depending on the status of the scroll
        //If scroll is reaching bottom it'll call loadMore (true)
        self.colllectionView.rx.reachedBottom()
            .skipUntil(viewModel.isRefreshing)
            .bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        self.colllectionView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [unowned self] movie in
                self.viewModel.movieDetailAction.execute(movie)
            }).disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"sortIcon"), style: .plain, target: self, action: #selector(showAlertSheet))

    }
    
    
    @objc func showAlertSheet(){
        //Create a fixed size array
        var actions = [UIAlertController.AlertAction]()
        for type in MovieOrderType.allCases {
            actions.append(.action(title: type.description))
        }
        UIAlertController
            .present(in: self, title: "Sort by: ", message: nil, style: .actionSheet, actions: actions)
            .flatMap { index in
                return Observable.just(MovieOrderType(rawValue: index)!)
            }.subscribe(onNext: { [unowned self] orderBy in
                self.viewModel.orderByAction.execute(orderBy)
            }).disposed(by: disposeBag)
    }
}

