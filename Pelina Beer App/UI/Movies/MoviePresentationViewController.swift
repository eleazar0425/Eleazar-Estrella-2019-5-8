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
            cell.posterImageView.image = nil
            Nuke.loadImage(with: URL(string: AppConfig.IMAGE_BASE_PATH + (movie.poster ?? ""))!, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33), failureImage: UIImage(named: "placeholder")), into: cell.posterImageView)
        }.disposed(by: disposeBag)
        
        //Binds contentOffset to viewmodel#loadMore, so it will emit true or false depending on the status of the scroll
        //If scroll is reaching bottom it'll call loadMore (true)
        self.colllectionView.rx
            .contentOffset
            .flatMap { [unowned self] _ in
                return Observable.just(self.colllectionView.isNearTheBottomEdge())
            }.distinctUntilChanged()
            .bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
    }
}

