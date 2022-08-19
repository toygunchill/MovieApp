//
//  Movie.swift
//  MovieList
//
//  Created by Toygun Çil on 26.07.2022.
//

import Foundation

struct Movie: Codable {
    let title: String?
    let poster_path: String?
    let release_date: String?
    let vote_average: Float?
    let vote_count: Int?
    let popularity: Double?
    let original_title: String?
    let original_language: String?
    let id: Int?
}

