//
//  Network.swift
//  MovieList
//
//  Created by Toygun Çil on 26.07.2022.
//

import Foundation
import Alamofire

//MARK: - Network Service
private let baseURL = "https://api.themoviedb.org/3"
private let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
struct Endpoint {
    static let movieList = "/movie/popular?api_key="
    static let movieSearch = "/search/movie?api_key="
    static let castSearch = "/search/person?api_key="
    static let castDetail = "/person/"
    static let movie = "/movie/"
    static let moviePage = "&page="
    static let movieQuerySearch = "&query="
    static let movieReview = "/reviews"
    static let movideDetailCredits = "/credits"
    static let movieDetailRecommendations = "/recommendations"
    static let movieApiKey = "?api_key="
    static let movieCombined = "/combined_credits"
    static let movieAdult = "&include_adult=false"
}
struct Language {
    static let language = "languageEndpoint".localized()
}

class NetworkService {
    static let sharedNetwork = NetworkService()
    private init() {}
    
    //MARK: - Functions
    func getFavMoviesData(with movieID: Int?, completion: @escaping (Result<MovieDetailResponse, AFError>) -> Void) {
        if let movieID = movieID {
            let favoritesNetworkURL = "\(baseURL)\(Endpoint.movie)\(movieID)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(favoritesNetworkURL, method: .get).responseDecodable(of: MovieDetailResponse.self) {
                favResponse in completion(favResponse.result)
            }
        }
    }
    
    func getMoviePopularData(with page: Int?, completion: @escaping (Result<BaseRequestResponse, AFError>) -> Void) {
        let popularNetworkURL = "\(baseURL)\(Endpoint.movieList)\(apiKey)\(Endpoint.moviePage)\(page ?? 1)\(Language.language)"
        AF.request(popularNetworkURL, method: .get).responseDecodable(of: BaseRequestResponse.self) {
            popResponse in completion(popResponse.result)
        }
    }
    
    func getMovieDetailData(with movieID: Int?, completion: @escaping (Result<MovieDetailResponse, AFError>) -> Void) {
        if let movieID = movieID {
            let detailNetworkURL = "\(baseURL)\(Endpoint.movie)\(movieID)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(detailNetworkURL, method: .get).responseDecodable(of: MovieDetailResponse.self) { detResponse in
                completion(detResponse.result)
            }
        }
    }
    
    func getMovieRecommendData(with movieID: Int?, completion: @escaping (Result<MovieRecommendResponse,AFError>) -> Void) {
        if let movieID = movieID {
            let recommenURL = "\(baseURL)\(Endpoint.movie)\(movieID)\(Endpoint.movieDetailRecommendations)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(recommenURL, method: .get).responseDecodable(of: MovieRecommendResponse.self) { recommendResponse in
                completion(recommendResponse.result)
            }
        }
    }
    
    func getMovieCastData(with movieID: Int?, completion: @escaping(Result<MovieCastResponse,AFError>) -> Void) {
        if let movieID = movieID {
            let creditsURL = "\(baseURL)\(Endpoint.movie)\(movieID)\(Endpoint.movideDetailCredits)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(creditsURL, method: .get).responseDecodable(of: MovieCastResponse.self) { castResponse in
                completion(castResponse.result)
            }
        }
    }
    
    func getMovieSearchData(with page: Int?, query: String?, competion: @escaping (Result<BaseRequestResponse,AFError>) -> Void) {
        if let query = query {
            let searchNetworkURL = "\(baseURL)\(Endpoint.movieSearch)\(apiKey)\(Endpoint.moviePage)\(page ?? 1)\(Language.language)\(Endpoint.movieQuerySearch)\(query)"
            AF.request(searchNetworkURL, method: .get).responseDecodable(of: BaseRequestResponse.self) { searchResponse in
                competion(searchResponse.result)
            }
        }
    }
    
    func getMovieCastDetailData(with personID: Int?,completion: @escaping (Result<MovieCastDetailResponse,AFError>) -> Void) {
        if let personID = personID {
            let castNetworkURL = "\(baseURL)\(Endpoint.castDetail)\(personID)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(castNetworkURL, method: .get).responseDecodable(of: MovieCastDetailResponse.self) { castResponse in
                completion(castResponse.result)
            }
        }
    }
    
    func getMovieReviewData(with movieID: Int?, completion: @escaping (Result<ReviewResponse,AFError>) -> Void) {
        if let movieID = movieID {
            let reviewNetworkURL = "\(baseURL)\(Endpoint.movie)\(movieID)\(Endpoint.movieReview)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)&page=1"
            AF.request(reviewNetworkURL, method: .get).responseDecodable(of: ReviewResponse.self) { reviewResponse in
                completion(reviewResponse.result)
            }
        }
    }
    
    func getCastSearchData(with query: String?, page: Int?, completion: @escaping (Result<CastSearchResponse,AFError>) -> Void) {
        if let query = query, let page = page {
            let castSearchNetworkURL = "\(baseURL)\(Endpoint.castSearch)\(apiKey)\(Language.language)\(Endpoint.moviePage)\(page)\(Endpoint.movieAdult)\(Endpoint.movieQuerySearch)\(query)"
            AF.request(castSearchNetworkURL, method: .get).responseDecodable(of: CastSearchResponse.self) { castSearchResponse in
                completion(castSearchResponse.result)
            }
        }
    }
    
    func getCastsMovieData(with personID: Int?, completion: @escaping (Result<CastMovieResponse,AFError>) -> Void) {
        if let personID = personID {
            let castMovieNetworkURL = "\(baseURL)\(Endpoint.castDetail)\(personID)\(Endpoint.movieCombined)\(Endpoint.movieApiKey)\(apiKey)\(Language.language)"
            AF.request(castMovieNetworkURL, method: .get).responseDecodable(of: CastMovieResponse.self) { castMovieResponse in
                completion(castMovieResponse.result)
            }
        }
    }
}
