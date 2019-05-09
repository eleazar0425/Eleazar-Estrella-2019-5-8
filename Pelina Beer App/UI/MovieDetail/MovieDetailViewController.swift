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

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var calificationBar: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movie else {
            fatalError("In order to use this viewController you must set the movie property")
        }
        
        self.titleLabel.text = movie.title
        self.descriptionTextView.text = movie.overview
        self.calificationBar.rating = movie.voteAverage/2
        self.calificationBar.isUserInteractionEnabled = false
        Nuke.loadImage(with: URL(string: AppConfig.IMAGE_BASE_PATH + (movie.poster ?? ""))!,
                       options: ImageLoadingOptions(
                        transition: .fadeIn(duration: 0.33),
                        failureImage: UIImage(named: "placeholder")
        ), into: self.posterImageView)
        
        
        guard !movie.releaseDate.isEmpty else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: movie.releaseDate)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        self.releaseDateLabel.text = "Release date: \(dateFormatter.string(from: date!))"
    }
}
