//
//  MovieDetailResponse.swift
//  MovieList
//
//  Created by Toygun Çil on 26.07.2022.
//

import Foundation

struct MovieDetailResponse: Codable {
    let budget: Int?
    let title: String?
    let original_langugage: String?
    let original_title: String?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let overview: String?
    let poster_path: String?
    let genres: [Genres]? 
    //map
    let homepage: String?
    let id: Int?
    let vote_average: Float?
    let vote_count: Int?
    let popularity: Double?
    let production_companies: [Companies]? // ortak şirket - şirketler
}

