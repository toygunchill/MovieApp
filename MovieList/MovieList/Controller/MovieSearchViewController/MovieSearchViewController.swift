//
//  MovieSearchViewController.swift
//  MovieList
//
//  Created by Toygun Çil on 1.08.2022.
//

import UIKit

class MovieSearchViewController: UIViewController {
 //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var searchChooseButton: UISegmentedControl!
    @IBOutlet weak var movieSearchTableView: UITableView! {
        didSet {
            movieSearchTableView.delegate = self
            movieSearchTableView.dataSource = self
            movieSearchTableView.register(UINib(nibName: String(describing: SearchCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SearchCell.self))
        }
    }
 //MARK: - Properties
    private var totalPage: Int?
    private var currentSearchPage = 1
    private var searchText: String?
    private var searchMovies: [Movie]? = [] {
        didSet {
            movieSearchTableView.reloadData()
        }
    }
    private var searchCasts: [CastSearch]? = [] {
        didSet {
            movieSearchTableView.reloadData()
        }
    }
 //MARK: - Lifecyles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "searchMovieTitle".localized()
    }
 //MARK: - Functions
    func configureMovieSearchNetwork(with currentSearchPage: Int?, searchText: String?) {
        NetworkService.sharedNetwork.getMovieSearchData(with: currentSearchPage, query: searchText) { searchResult in
            switch searchResult {
            case .success(let searchResponse):
                self.searchMovies = searchResponse.results
                self.totalPage = searchResponse.total_page
            case .failure(let searchError):
                print(searchError)
            }
        }
    }
    func configureCastSearchNetwork(with currentSearchPage: Int?, searchText: String?) {
        NetworkService.sharedNetwork.getCastSearchData(with: searchText, page: currentSearchPage) { castSearchResult in
            switch castSearchResult {
            case .success(let castSearchResponse):
                self.searchCasts = castSearchResponse.results
                self.totalPage = castSearchResponse.page
            case .failure(let castSearchError):
                print(castSearchError)
            }
        }
    }
}
//MARK: - Extensions
extension MovieSearchViewController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchText = searchBar.text
        if searchChooseButton.selectedSegmentIndex == 0 {
            configureMovieSearchNetwork(with: currentSearchPage, searchText: searchText)
        } else {
            configureCastSearchNetwork(with: currentSearchPage, searchText: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 || searchText == "" {
            if searchChooseButton.selectedSegmentIndex == 0 {
                configureMovieSearchNetwork(with: currentSearchPage, searchText: searchText)
            } else {
                configureCastSearchNetwork(with: currentSearchPage, searchText: searchText)
            }
        } 
    }
}
extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectImage = UIImage(systemName: "heart.fill")
        let title = "addFavorites".localized()
        let slideAddAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            let controlMovieId = self.searchMovies?[indexPath.section].id ?? 0
            if GlobalFavMoviesManager.sharedFav.globalFavMovieId?.firstIndex(of: controlMovieId) == nil {
                GlobalFavMoviesManager.sharedFav.globalFavMovieId?.append(self.searchMovies?[indexPath.section].id ?? 0)
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
            let deleteMovieId = self.searchMovies?[indexPath.section].id ?? 0
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchChooseButton.selectedSegmentIndex == 0 {
            return searchMovies?.count ?? 0
        } else {
            return searchCasts?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchCell = movieSearchTableView.dequeueReusableCell(withIdentifier: String(describing: SearchCell.self), for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        searchCell.layer.cornerRadius = 5
        searchCell.layer.masksToBounds = true
        searchCell.clipsToBounds = true
        searchCell.layer.borderWidth = 1
        
        if searchChooseButton.selectedSegmentIndex == 0 {
            let searchData = searchMovies?[indexPath.section]
            searchCell.configureMovieSearchScreen(with: searchData)
        } else {
            let searchData = searchCasts?[indexPath.section]
            searchCell.configureCastSearchScreen(with: searchData)
        }
        
        if indexPath.section == (searchMovies?.count ?? 0) - 1 {
            if currentSearchPage != totalPage {
                currentSearchPage = currentSearchPage + 1
            }
            if searchChooseButton.selectedSegmentIndex == 0 {
                NetworkService.sharedNetwork.getMovieSearchData(with: currentSearchPage, query: searchText) { searchResult in
                    switch searchResult {
                    case .success(let searchResponse):
                        self.searchMovies?.append(contentsOf: searchResponse.results!)
                    case .failure(let searchError):
                        print(searchError)
                    }
                }
            } 
        }
        return searchCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchChooseButton.selectedSegmentIndex == 0 {
            if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
                print(indexPath.section)
                let movieSearchToDetId = searchMovies?[indexPath.section].id
                movieDetailVC.configureMovieDetailNetwork(with: movieSearchToDetId)
                movieDetailVC.updateFavArr(movieDidSelectID: movieSearchToDetId)
            }
        } else {
            if let castDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieCastDetailViewController") as? MovieCastDetailViewController {
                self.navigationController?.pushViewController(castDetailVC, animated: true)
                print(indexPath.section)
                let castSearchToDetId = searchCasts?[indexPath.section].id
                castDetailVC.configureCastDetailNetwork(with: castSearchToDetId)
            }
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
