//
//  MovieListCell.swift
//  MovieList
//
//  Created by Toygun Çil on 25.07.2022.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieOriginalLanguageLabel: UILabel!
    @IBOutlet weak var moviePopularityScoreLabel: UILabel!
    @IBOutlet weak var movieVoteCountLabel: UILabel!
    @IBOutlet weak var movieRatingPopLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    //MARK: - Functions
    func configureMovieListScreen(with movie: Movie?) {
        let movieRating = movie?.vote_average
        let movieReleaseDate = movie?.release_date
        let movieVoteC = movie?.vote_count
        let moviePopularityScore = movie?.popularity
        let movieOriginalLanguage = movie?.original_language
        let imagePath = movie?.poster_path
        let imageString = "https://image.tmdb.org/t/p/w500\(imagePath ?? "")"
        let imageURL = URL(string: imageString)
        movieTitleLabel.text = movie?.title ?? "notFound".localized()
        movieRatingPopLabel.text = " \(String(format: "%.1f", movieRating ?? 0.0))"
        movieReleaseDateLabel.text = "releaseDate".localized() + " \(movieReleaseDate ?? "notFound".localized())"
        movieVoteCountLabel.text = "voteCount".localized() + " \(movieVoteC ?? 0)"
        moviePopularityScoreLabel.text = "popularityScore".localized() + " \(moviePopularityScore ?? 0.0)"
        movieOriginalLanguageLabel.text = "language".localized() + "\(movieOriginalLanguage ?? "notFound".localized())"
        movieImageView.kf.setImage(with: imageURL)
    }
}
