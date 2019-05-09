//
//  MovieCollectionViewCell.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import UIKit
import Nuke

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var favoriteToggle: UIButton!
    
    var viewModel: MovieCellViewModelType = MovieCellViewModel()
    var movie: Movie?
    
    var favorite: Bool! {
        didSet {
            favoriteToggle?.isSelected = favorite
        }
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.movieTitle.text = ""
    }
    
    @IBAction func toggleFavoriteAction(_ sender: Any) {
        favorite = !favorite
        guard let movie = movie else { return }
        viewModel.isFavoriteAction.execute(Favorite(movie: movie, isFavorite: favorite))
    }
    
    override func awakeFromNib() {
        self.favorite = false
        favoriteToggle?.isSelected = false
        favoriteToggle?.setImage(#imageLiteral(resourceName: "favoriteIcon").withRenderingMode(.alwaysOriginal), for : .selected)
        favoriteToggle?.setImage(#imageLiteral(resourceName: "notFavoriteIcon").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func bind(movie: Movie){
        Nuke.loadImage(with: URL(string: AppConfig.IMAGE_BASE_PATH + (movie.poster ?? ""))!, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33), failureImage: UIImage(named: "placeholder")), into: self.posterImageView)
        self.movieTitle.text = movie.title
        self.movie = movie
    }
}
