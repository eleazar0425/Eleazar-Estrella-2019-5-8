//
//  MovieDetailViewController.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import UIKit
import Cosmos
import Nuke
import RxSwift

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var calificationBar: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteToggle: UIButton!
    
    var movie: Movie?
    
    var viewModel: MovieCellViewModelType! = MovieCellViewModel()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movie else {
            fatalError("In order to use this viewController you must set the movie property")
        }
        
        defer {
            self.viewModel.movieAction.execute(movie)
        }
        
        favoriteToggle.isSelected = false
        favoriteToggle.setImage(#imageLiteral(resourceName: "favoriteIcon").withRenderingMode(.alwaysOriginal), for : .selected)
        favoriteToggle.setImage(#imageLiteral(resourceName: "notFavoriteIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.titleLabel.text = movie.title
        self.descriptionTextView.text = movie.overview
        self.calificationBar.rating = movie.voteAverage/2
        self.calificationBar.isUserInteractionEnabled = false
        
        Nuke.loadImage(with: URL(string: AppConfig.IMAGE_BASE_PATH + (movie.poster ?? ""))!,
                       options: ImageLoadingOptions(
                        transition: .fadeIn(duration: 0.33),
                        failureImage: UIImage(named: "placeholder")
        ), into: self.posterImageView)
        
        
        if !movie.releaseDate.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: movie.releaseDate)
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            self.releaseDateLabel.text = "Release date: \(dateFormatter.string(from: date!))"
        }

        viewModel.favoriteMovieOutput
            .subscribe(onNext: {
                self.favoriteToggle.isSelected = $0.isFavorite
            }).disposed(by: disposeBag)
        
    }
    @IBAction func toggleFavoriteAction(_ sender: Any) {
        let isFavorite = !favoriteToggle.isSelected
        favoriteToggle.isSelected = isFavorite
        viewModel.isFavoriteAction.execute(Favorite(movie: movie!, isFavorite: isFavorite))
    }
}
