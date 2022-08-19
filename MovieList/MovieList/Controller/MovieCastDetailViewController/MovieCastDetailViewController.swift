//
//  MovieCastDetailViewController.swift
//  MovieList
//
//  Created by Toygun Çil on 15.08.2022.
//

import UIKit
import Kingfisher

class MovieCastDetailViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var castMovieCollectionView: UICollectionView! {
        didSet {
            castMovieCollectionView.dataSource = self
            castMovieCollectionView.delegate = self
            castMovieCollectionView.reloadData()
            castMovieCollectionView.register(UINib(nibName: String(describing: CastMovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CastMovieCell.self))
        }
    }
    @IBOutlet weak var castDetailNameLabel: UILabel!
    @IBOutlet weak var castDetailDeathday: UILabel!
    @IBOutlet weak var castDetailBirthday: UILabel!
    @IBOutlet weak var castDetailBirthPlace: UILabel!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var castDetailImageView: UIImageView!
    //MARK: - Properties
    private var castName: String?
    private var birthday: String?
    private var deathday: String?
    private var placeBirth: String?
    private var imagePath: String?
    private var castMovie: [CastBasic]? {
        didSet {
            castMovieCollectionView.reloadData()
        }
    }
    //MARK: - Lifecyles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - Functions
    func configureCastDetailNetwork(with personID: Int?) {
        NetworkService.sharedNetwork.getMovieCastDetailData(with: personID) { castDetResult in
            switch castDetResult {
            case .success(let castDetResponse):
                self.castName = castDetResponse.name
                self.imagePath = castDetResponse.profile_path
                self.birthday = castDetResponse.birthday
                self.deathday = castDetResponse.deathday
                self.placeBirth = castDetResponse.place_of_birth
                self.configureCastDetailScreen()
            case .failure(let castDetError):
                print("Detail Network Error: \(castDetError)")
            }
        }
        NetworkService.sharedNetwork.getCastsMovieData(with: personID) { castMovieResult in
            switch castMovieResult {
            case .success(let castMovieResponse):
                self.castMovie = castMovieResponse.cast
            case .failure(let castMovieError):
                print(castMovieError)
            }
        }
    }
    func configureCastDetailScreen() {
        let imageCastDetString = "https://image.tmdb.org/t/p/w500\(imagePath ?? "")"
        let imageCasDetURL = URL(string: imageCastDetString)
        castNameLabel.text = castName
        castDetailNameLabel.text = "  " + "name".localized() + " \(castName ?? "nameNotFound".localized())"
        castDetailBirthPlace.text = "  " + "birthPlace".localized() + " \(placeBirth ?? "birthPlaceNotFound".localized())"
        castDetailBirthday.text = "  " + "birthday".localized() + " \(birthday ?? "birthdayNotFound".localized())"
        if deathday != nil {
            castDetailDeathday.text = "  " + "deathday".localized() + " \(deathday ?? "deathdayNotFound".localized())"
        } else {
            castDetailDeathday.isHidden = true
        }
        castDetailImageView.kf.setImage(with: imageCasDetURL)
    }
}

extension MovieCastDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castMovie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castMovieCell = castMovieCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastMovieCell.self), for: indexPath) as? CastMovieCell else {
            return UICollectionViewCell()
        }
        let castMovie = castMovie?[indexPath.row]
        castMovieCell.configureCastMovie(with: castMovie)
        return castMovieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            self.navigationController?.pushViewController(movieDetailVC, animated: true)
            let castMovieID = castMovie?[indexPath.row].id
            movieDetailVC.configureMovieDetailNetwork(with: castMovieID)
            movieDetailVC.updateFavArr(movieDidSelectID: castMovieID)
        }
    }
}
