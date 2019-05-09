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
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.movieTitle.text = ""
    }
    
    func bind(movie: Movie){
        Nuke.loadImage(with: URL(string: AppConfig.IMAGE_BASE_PATH + (movie.poster ?? ""))!, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33), failureImage: UIImage(named: "placeholder")), into: self.posterImageView)
        self.movieTitle.text = movie.title
    }
}
