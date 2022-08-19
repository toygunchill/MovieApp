//
//  CastMovieCell.swift
//  MovieList
//
//  Created by Toygun Çil on 19.08.2022.
//

import UIKit
import Kingfisher

class CastMovieCell: UICollectionViewCell {

    @IBOutlet weak var castMovieName: UILabel!
    @IBOutlet weak var castMovieImageView: UIImageView!
    
    func configureCastMovie(with castMovie: CastBasic? ) {
        castMovieName.text = castMovie?.name
        if let imagePath = castMovie?.poster_path {
            let imageString = "https://image.tmdb.org/t/p/w500\(imagePath)"
            let imageURL = URL(string: imageString)
            castMovieImageView.kf.setImage(with: imageURL)
        }
    }
}
