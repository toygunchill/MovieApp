//
//  FavoritesCell.swift
//  MovieList
//
//  Created by Toygun Çil on 31.07.2022.
//

import UIKit

class FavoritesCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var movieRatingFavLabel: UILabel!
    @IBOutlet weak var movieVoteCountFavLabel: UILabel!
    @IBOutlet weak var movieOriginalLanguageFavLabel: UILabel!
    @IBOutlet weak var moviePopularityScoreFavLabel: UILabel!
    @IBOutlet weak var movieReleaseDateFavLabel: UILabel!
    @IBOutlet weak var movieTitleFavLabel: UILabel!
    @IBOutlet weak var movieFavImageView: UIImageView!
    //MARK: - Functions
    func configureFavMovieScreen(movieTitle: String?, originalLanguage: String?, imagePath: String?, releaseDate: String?, movieRating: Float?, movieVoteCount: Int?, moviePopScore: Double?) {
        let movieRating = movieRating
        let movieReleaseDate = releaseDate
        let movieVoteC = movieVoteCount
        let moviePopularityScore = moviePopScore
        let movieOriginalLanguage = originalLanguage
        let imagePath = imagePath
        let imageString = "https://image.tmdb.org/t/p/w500\(imagePath ?? "")"
        let imageURL = URL(string: imageString)
        movieTitleFavLabel.text = movieTitle ?? "notFound".localized()
        movieRatingFavLabel.text = " \(String(format: "%.1f", movieRating ?? 0.0))"
        movieReleaseDateFavLabel.text = "releaseDate".localized() + " \(movieReleaseDate ?? "notFound".localized())"
        movieVoteCountFavLabel.text = "voteCount".localized() + " \(movieVoteC ?? 0)"
        moviePopularityScoreFavLabel.text = "popularityScore".localized() + " \(moviePopularityScore ?? 0.0)"
        movieOriginalLanguageFavLabel.text = "language".localized() + " \(movieOriginalLanguage ?? "notFound".localized())"
        movieFavImageView.kf.setImage(with: imageURL)
    }
}
