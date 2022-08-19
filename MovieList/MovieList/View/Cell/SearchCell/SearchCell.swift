//
//  SearchCell.swift
//  MovieList
//
//  Created by Toygun Çil on 1.08.2022.
//

import UIKit

class SearchCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var movieRatingButton: UIButton!
    @IBOutlet weak var movieTitleSearchLabel: UILabel!
    @IBOutlet weak var movieReleaseDateSearchLabel: UILabel!
    @IBOutlet weak var moviePopularityScoreSearchLabel: UILabel!
    @IBOutlet weak var movieOriginalLanguageSearchLabel: UILabel!
    @IBOutlet weak var movieVoteCountSearchLabel: UILabel!
    @IBOutlet weak var movieSearchImageView: UIImageView!
    @IBOutlet weak var movieRatingScoreSearchLabel: UILabel!
    //MARK: - Properties
    var hiddenControl: Bool?
    //MARK: - Functions
    func configureMovieSearchScreen(with searchMovie: Movie?) {
        let movieRatingSearch = searchMovie?.vote_average
        let movieReleaseDateSearch = searchMovie?.release_date
        let movieVoteCSearch = searchMovie?.vote_count
        let moviePopularityScoreSearch = searchMovie?.popularity
        let movieOriginalLanguageSearch = searchMovie?.original_language
        let imagePath = searchMovie?.poster_path
        let imageString = "https://image.tmdb.org/t/p/w500\(imagePath ?? "")"
        let imageURL = URL(string: imageString)
        hiddenControl = false
        hiddenFunction(with: hiddenControl)
        movieTitleSearchLabel.text = searchMovie?.title ?? "notFound".localized()
        movieRatingScoreSearchLabel.text = " \(String(format: "%.1f", movieRatingSearch ?? 0.0))"
        movieReleaseDateSearchLabel.text = "releaseDate".localized() + " \(movieReleaseDateSearch ?? "notFound".localized())"
        movieVoteCountSearchLabel.text = "voteCount".localized() + " \(movieVoteCSearch ?? 0)"
        moviePopularityScoreSearchLabel.text = "popularityScore".localized() + " \(moviePopularityScoreSearch ?? 0.0)"
        movieOriginalLanguageSearchLabel.text = "language".localized() + " \(movieOriginalLanguageSearch ?? "notFound".localized())"
        movieSearchImageView.kf.setImage(with: imageURL)
    }
    func configureCastSearchScreen(with searchCast: CastSearch?) {
        hiddenControl = true
        hiddenFunction(with: hiddenControl)
        if let imagePath = searchCast?.profile_path {
            let imageString = "https://image.tmdb.org/t/p/w500\(imagePath)"
            let imageURL = URL(string: imageString)
            movieSearchImageView.kf.setImage(with: imageURL)
        }
        movieTitleSearchLabel.text = searchCast?.name
    }
    func hiddenFunction(with control: Bool?) {
        if control == true {
            movieVoteCountSearchLabel.isHidden = true
            movieRatingScoreSearchLabel.isHidden = true
            movieReleaseDateSearchLabel.isHidden = true
            moviePopularityScoreSearchLabel.isHidden = true
            movieOriginalLanguageSearchLabel.isHidden = true
            movieRatingButton.isHidden = true
        } else {
            movieVoteCountSearchLabel.isHidden = false
            movieRatingScoreSearchLabel.isHidden = false
            movieReleaseDateSearchLabel.isHidden = false
            moviePopularityScoreSearchLabel.isHidden = false
            movieOriginalLanguageSearchLabel.isHidden = false
            movieRatingButton.isHidden = false
        }
    }
}
