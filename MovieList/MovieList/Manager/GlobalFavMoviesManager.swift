//
//  GlobalFavoritesMovies.swift
//  MovieList
//
//  Created by Toygun Çil on 9.08.2022.
//

import Foundation

class GlobalFavMoviesManager {
    //MARK: - Properties
    static let sharedFav = GlobalFavMoviesManager()
    private init() {}
    var globalFavMovieId: [Int]? = [] {
        didSet {
            UserDefaults.standard.set(globalFavMovieId, forKey: "globalFavMovieId")
        }
    }
}
