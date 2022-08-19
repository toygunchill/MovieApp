//
//  ReviewResponse.swift
//  MovieList
//
//  Created by Toygun Çil on 18.08.2022.
//

import Foundation

struct ReviewResponse: Codable {
    let results: [Comment]?
}
