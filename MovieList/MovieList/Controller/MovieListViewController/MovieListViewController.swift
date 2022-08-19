//
//  ViewController.swift
//  MovieList
//
//  Created by Toygun Çil on 25.07.2022.
//

import UIKit

class MovieListViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var movieListTableView: UITableView!{
        didSet{
            movieListTableView.dataSource = self
            movieListTableView.delegate = self
            movieListTableView.register(UINib(nibName: String(describing: MovieListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieListCell.self))
        }
    }
    //MARK: - Properties
    private var currentPage = 1
    private var totalPage: Int?
    private var page: Int? = 1
    private var movies: [Movie]? = [] {
        didSet {
            movieListTableView.reloadData()
        }
    }
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "popMovieListTitle".localized()
        configureMovieListNetwork()
    }
    //MARK: - Functions
    func configureMovieListNetwork() {
        NetworkService.sharedNetwork.getMoviePopularData(with: currentPage) { popresult in
            switch popresult {
            case .success(let popresponse):
                self.movies?.append(contentsOf: popresponse.results!)
                self.page = popresponse.page
                self.totalPage = popresponse.total_page
            case .failure(let poperror):
                print(poperror)
            }
        }
    }
}
//MARK: - Extensions
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectImage = UIImage(systemName: "heart.fill")
        let title = "addFavorites".localized()
        let slideAddAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            let controlMovieId = self.movies?[indexPath.section].id ?? 0
            if GlobalFavMoviesManager.sharedFav.globalFavMovieId?.firstIndex(of: controlMovieId) == nil {
                GlobalFavMoviesManager.sharedFav.globalFavMovieId?.append(self.movies?[indexPath.section].id ?? 0)
            }
            completion(true)
        }
        slideAddAction.image = selectImage
        slideAddAction.backgroundColor = .systemYellow
        let configureAdd = UISwipeActionsConfiguration(actions: [slideAddAction])
        return configureAdd
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteImage = UIImage(systemName: "heart")
        let title = "deleteFavorites".localized()
        let slideDellAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            let deleteMovieId = self.movies?[indexPath.section].id ?? 0
            if let index = GlobalFavMoviesManager.sharedFav.globalFavMovieId?.firstIndex(of: deleteMovieId) {
                GlobalFavMoviesManager.sharedFav.globalFavMovieId?.remove(at: index)
            }
            completion(true)
        }
        slideDellAction.image = deleteImage
        slideDellAction.backgroundColor = .systemRed
        let configureDell = UISwipeActionsConfiguration(actions: [slideDellAction])
        return configureDell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = movieListTableView.dequeueReusableCell(withIdentifier: String(describing: MovieListCell.self), for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        movieCell.layer.cornerRadius = 2
        movieCell.layer.masksToBounds = true
        movieCell.clipsToBounds = true
        movieCell.layer.borderWidth = 1
        let movieBasic = movies?[indexPath.section]
        movieCell.configureMovieListScreen(with: movieBasic)
        if indexPath.section == (movies?.count ?? 0) - 1 {
            if currentPage != totalPage {
                currentPage = currentPage + 1
            }
            configureMovieListNetwork()
        }
        return movieCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            self.navigationController?.pushViewController(movieDetailVC, animated: true)
            let moviePopToDetId = movies?[indexPath.section].id
            movieDetailVC.configureMovieDetailNetwork(with: moviePopToDetId)
            movieDetailVC.updateFavArr(movieDidSelectID: moviePopToDetId)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies?.count ?? 0
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
