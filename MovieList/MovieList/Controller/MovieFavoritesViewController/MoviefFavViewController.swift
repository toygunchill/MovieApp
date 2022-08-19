//
//  MoviefFavViewController.swift
//  MovieList
//
//  Created by Toygun Çil on 31.07.2022.
//

import UIKit

class MovieFavViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var movieFavTableView: UITableView! {
        didSet {
            movieFavTableView.dataSource = self
            movieFavTableView.delegate = self
            movieFavTableView.register(UINib(nibName: String(describing: FavoritesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FavoritesCell.self))
        }
    }
    //MARK: - Properties
    private var originalLanguage: [String]? = []
    private var imagePath: [String]? = []
    private var releaseDate: [String]? = []
    private var movieRating: [Float]? = []
    private var movieVoteCount: [Int]? = []
    private var moviePopScore: [Double]? = []
    private var movieID: [Int]? = []
    private var movieTitle: [String]? = [] {
        didSet{
            movieFavTableView.reloadData()
        }
    }
    //MARK: - Lifecyles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "favoritesMovieTitle".localized()
        movieFavTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        movieFavTableView.reloadData()
        configureFavMovieNetwork()
    }
    override func viewDidDisappear(_ animated: Bool) {
        movieTitle = []
        originalLanguage = []
        imagePath = []
        releaseDate = []
        movieRating = []
        movieVoteCount = []
        moviePopScore = []
        movieID = []
    }
    //MARK: - Functions
    func configureFavMovieNetwork() {
        for movieID in GlobalFavMoviesManager.sharedFav.globalFavMovieId ?? [] {
            NetworkService.sharedNetwork.getFavMoviesData(with: movieID) { favresult in
                switch favresult {
                case .success(let favResponse):
                    self.movieTitle?.append(favResponse.title ?? "notFound".localized())
                    self.originalLanguage?.append(favResponse.original_langugage ?? "notFound".localized())
                    self.imagePath?.append(favResponse.poster_path ?? "notFound".localized())
                    self.releaseDate?.append(favResponse.release_date ?? "notFound".localized())
                    self.movieID?.append(favResponse.id ?? 0)
                    self.movieRating?.append(favResponse.vote_average ?? 0.0)
                    self.movieVoteCount?.append(favResponse.vote_count ?? 0)
                    self.moviePopScore?.append(favResponse.popularity ?? 0.0)
                case .failure(let deterror):
                    print("Detail Network Error: \(deterror)")
                }
            }
        }
    }
}
//MARK: - Extensions
extension MovieFavViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteImage = UIImage(systemName: "heart")
        let title = "deleteFavorites".localized()
        let slideDellAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            let deleteMovieId = self.movieID?[indexPath.section] ?? 0
            if let index = GlobalFavMoviesManager.sharedFav.globalFavMovieId?.firstIndex(of: deleteMovieId) {
                GlobalFavMoviesManager.sharedFav.globalFavMovieId?.remove(at: index)
                self.movieTitle?.remove(at: index)
                self.originalLanguage?.remove(at: index)
                self.imagePath?.remove(at: index)
                self.releaseDate?.remove(at: index)
                self.movieRating?.remove(at: index)
                self.movieVoteCount?.remove(at: index)
                self.moviePopScore?.remove(at: index)
                self.movieID?.remove(at: index)
            }
            self.movieFavTableView.reloadData()
            completion(true)
        }
        slideDellAction.image = deleteImage
        slideDellAction.backgroundColor = .systemRed
        let configureDell = UISwipeActionsConfiguration(actions: [slideDellAction])
        return configureDell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieTitle?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favCell = movieFavTableView.dequeueReusableCell(withIdentifier: String(describing: FavoritesCell.self), for: indexPath) as? FavoritesCell else {
            return UITableViewCell()
        }
        favCell.layer.cornerRadius = 5 //Cell köşelerini yuvarlama
        favCell.layer.masksToBounds = true
        favCell.clipsToBounds = true // Daralan alanda kalan parçaları sil
        favCell.layer.borderWidth = 1
        favCell.configureFavMovieScreen(movieTitle: self.movieTitle?[indexPath.section], originalLanguage: self.originalLanguage?[indexPath.section], imagePath: self.imagePath?[indexPath.section], releaseDate: self.releaseDate?[indexPath.section], movieRating: self.movieRating?[indexPath.section], movieVoteCount: self.movieVoteCount?[indexPath.section], moviePopScore: self.moviePopScore?[indexPath.section])
        return favCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
                let movieFavToDetId = movieID?[indexPath.section]
                movieDetailVC.configureMovieDetailNetwork(with: movieFavToDetId)
                movieDetailVC.updateFavArr(movieDidSelectID: movieFavToDetId)
            }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = view.backgroundColor
        return spaceView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
