//
//  ViewController.swift
//  MovieList
//
//  Created by Toygun Çil on 25.07.2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var movieReviewTableView: UITableView! {
        didSet {
            movieReviewTableView.dataSource = self
            movieReviewTableView.delegate = self
            movieReviewTableView.register(UINib(nibName: String(describing: ReviewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReviewCell.self))
        }
    }
    
    @IBOutlet weak var detailScrollView: UIScrollView! {
        didSet {
            detailScrollView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var castCellCollectionView: UICollectionView! {
        didSet {
            castCellCollectionView.dataSource = self
            castCellCollectionView.delegate = self
            castCellCollectionView.register(UINib(nibName: String(describing: CastCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CastCell.self))
        }
    }
    
    @IBOutlet weak var recommendationsCollectionView: UICollectionView! {
        didSet {
            recommendationsCollectionView.dataSource = self
            recommendationsCollectionView.delegate = self
            recommendationsCollectionView.register(UINib(nibName: String(describing: RecommendCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RecommendCell.self))
        }
    }
    
    @IBOutlet weak var movieLinkButton: UIButton!
    @IBOutlet weak var movieFavButton: UIButton!
    @IBOutlet weak var movieDetailsReleaseDate: UILabel!
    @IBOutlet weak var movieDetailLink: UILabel!
    @IBOutlet weak var movieDetailProdComp: UILabel!
    @IBOutlet weak var movieDetailRuntime: UILabel!
    @IBOutlet weak var movieDetailOverview: UILabel!
    @IBOutlet weak var movieDetailGenres: UILabel!
    @IBOutlet weak var movieDetailRevenue: UILabel!
    @IBOutlet weak var movieDetailBudget: UILabel!
    @IBOutlet weak var movieDetailOriginalLanguage: UILabel!
    @IBOutlet weak var movieDetailOriginalTitle: UILabel!
    @IBOutlet weak var movieDetailTitle: UILabel!
    @IBOutlet weak var movieDetailImageView: UIImageView!
    
    //MARK: - Properties
    private var movieTitle: String?
    private var originalTitle: String?
    private var originalLanguage: String?
    private var imagePath: String?
    private var genres: [Genres]? = []
    private var companies: [Companies]? = []
    private var budget: Int?
    private var revenue: Int?
    private var homePageLink: String?
    private var releaseDate: String?
    private var runtime: Int?
    private var overview: String?
    private var movieID: Int?
    private var review: [Comment]? {
        didSet {
            movieReviewTableView.reloadData()
        }
    }
    
    private var recommendMovie: [RecMovie]? = [] {
        didSet {
            recommendationsCollectionView.reloadData()
        }
    }
    
    private var castMovie: [Cast]? = [] {
        didSet {
            castCellCollectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "detMovieTitle".localized()
        updateFavButtonState()
    }
    
    //MARK: - IBActions
    @IBAction func movieLinkButtonTapped(_ sender: UIButton) {
        
        if let url = URL(string: homePageLink ?? "http://www.google.com"){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func movieFavButtonTapped(_ sender: UIButton) {
        let clickedImage = UIImage(systemName: "heart.fill")
        let nonClickedImage = UIImage(systemName: "heart")
        if movieFavButton.image(for: .normal) == nonClickedImage {
            movieFavButton.setImage(clickedImage, for: .normal)
            GlobalFavMoviesManager.sharedFav.globalFavMovieId?.append(movieID ?? 0)
        } else {
            movieFavButton.setImage(nonClickedImage, for: .normal)
            if let index = GlobalFavMoviesManager.sharedFav.globalFavMovieId?.firstIndex(of: movieID ?? 0) {
                GlobalFavMoviesManager.sharedFav.globalFavMovieId?.remove(at: index)
            }
        }
    }
    
    //MARK: - Functions
    func updateFavButtonState() {
        let clickedImage = UIImage(systemName: "heart.fill")
        let nonClickedImage = UIImage(systemName: "heart")
        if GlobalFavMoviesManager.sharedFav.globalFavMovieId?.contains(movieID ?? 0) == true {
            movieFavButton.setImage(clickedImage, for: .normal)
        } else {
            movieFavButton.setImage(nonClickedImage, for: .normal)
        }
    }
    
    func updateFavArr(movieDidSelectID: Int?) {
        movieID = movieDidSelectID
    }
    
    func configureMovieDetailNetwork(with movieID: Int?) {
        NetworkService.sharedNetwork.getMovieDetailData(with: movieID) { detresult in
            switch detresult {
            case .success(let detresponse):
                self.movieTitle = detresponse.title
                self.originalTitle = detresponse.original_title
                self.originalLanguage = detresponse.original_langugage
                self.imagePath = detresponse.poster_path
                self.releaseDate = detresponse.release_date
                self.budget = detresponse.budget
                self.revenue = detresponse.revenue
                self.runtime = detresponse.runtime
                self.overview = detresponse.overview
                self.movieID = detresponse.id
                self.genres = detresponse.genres
                self.companies = detresponse.production_companies
                self.homePageLink = detresponse.homepage
                
                self.configureMovieDetailScreen()
            case .failure(let deterror):
                print("Detail Network Error: \(deterror)")
            }
        }
        NetworkService.sharedNetwork.getMovieRecommendData(with: movieID) { recommendResult in
            switch recommendResult {
            case .success(let recResponse):
                self.recommendMovie = recResponse.results
            case .failure(let recError):
                print("Recommend Network Error: \(recError)")
            }
        }
        NetworkService.sharedNetwork.getMovieCastData(with: movieID) { castResult in
            switch castResult {
            case .success(let castResponse):
                self.castMovie = castResponse.cast
            case .failure(let castError):
                print("Cast Network Error: \(castError)")
            }
        }
        NetworkService.sharedNetwork.getMovieReviewData(with: movieID) { reviewResult in
            switch reviewResult {
            case .success(let reviewResponse):
                self.review = reviewResponse.results
            case .failure(let reviewError):
                print("Review Network Error: \(reviewError)")
            }
        }
    }
    
    func configureMovieDetailScreen() {
        let imageString = "https://image.tmdb.org/t/p/w500\(imagePath ?? "")"
        let imageURLDet = URL(string: imageString)
        self.movieDetailImageView.kf.setImage(with: imageURLDet)
        self.movieDetailTitle.text = self.movieTitle ?? "notFound".localized()
        self.movieDetailOriginalTitle.text = "originalTitle".localized() + " \(originalTitle ?? "notFound".localized())"
        self.movieDetailOriginalLanguage.text = "originalLanguage".localized() + " \(originalLanguage ?? "notFound".localized())"
        self.movieDetailsReleaseDate.text = "  " + "releaseDate".localized() + " \(releaseDate ?? "notFound".localized())"
        self.movieDetailBudget.text = "budget".localized() + " $\(String(format: "%d", self.budget ?? 0))"
        self.movieDetailRevenue.text = "revenue".localized() + " $\(String(format: "%d", self.revenue ?? 0))"
        self.movieDetailRuntime.text = "runtime".localized() + " \(String(format: "%d", self.runtime ?? 0))"
        self.movieDetailLink.text = "homePage".localized() + " \(homePageLink ?? "notFound".localized())"
        var genresString = "genres".localized()
        for genre in 0..<(genres?.count ?? 0) {
            genresString += " \(genres?[genre].name ?? "notFound".localized()),"
        }
        genresString.removeLast()
        self.movieDetailGenres.text = genresString
        
        var companiesString = "companies".localized()
        for companie in 0..<(companies?.count ?? 0) {
            companiesString += " \(companies?[companie].name ?? "notFound".localized()),"
        }
        companiesString.removeLast()
        self.movieDetailProdComp.text = companiesString
        self.movieDetailOverview.text = "overview".localized() + " \(overview ?? "notFound".localized())"
    }
}

//MARK: - Extensions
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == recommendationsCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recommendationsCollectionView {
            return recommendMovie?.count ?? 0
        } else {
            return castMovie?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendationsCollectionView {
            guard let recommendCell = recommendationsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendCell.self), for: indexPath) as? RecommendCell else {
                return UICollectionViewCell()
            }
            recommendCell.layer.borderWidth = 1
            let recommendImageString = "https://image.tmdb.org/t/p/w500\(recommendMovie?[indexPath.row].poster_path ?? "")"
            let recommendImageURL = URL(string: recommendImageString)
            recommendCell.recommendMovieImageView.kf.setImage(with: recommendImageURL)
            return recommendCell
        } else {
            guard let castCell = castCellCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCell.self), for: indexPath) as? CastCell else {
                return UICollectionViewCell()
            }
            castCell.layer.borderWidth = 1
            let castImageString = "https://image.tmdb.org/t/p/w500\(castMovie?[indexPath.row].profile_path ?? "")"
            let castImageURL = URL(string: castImageString)
            castCell.castCellImageView.kf.setImage(with: castImageURL)
            return castCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendationsCollectionView {
            if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
                let movieRecID = recommendMovie?[indexPath.row].id
                movieDetailVC.configureMovieDetailNetwork(with: movieRecID)
            }
        } else {
            if let movieCastDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieCastDetailViewController") as? MovieCastDetailViewController {
                self.navigationController?.pushViewController(movieCastDetailVC, animated: true)
                let movieCastID = castMovie?[indexPath.row].id
                movieCastDetailVC.configureCastDetailNetwork(with: movieCastID)
            }
        }
    }
}
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return review?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewCell = movieReviewTableView.dequeueReusableCell(withIdentifier: String(describing: ReviewCell.self), for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        let commentData = review?[indexPath.row]
        reviewCell.configureReviewCell(with: commentData)
        return reviewCell
    }
}
