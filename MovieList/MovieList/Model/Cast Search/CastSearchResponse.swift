//
//  CastSearchResponse.swift
//  MovieList
//
//  Created by Toygun Çil on 19.08.2022.
//

import Foundation

class CastSearchResponse: Codable {
    let results: [CastSearch]?
    let page: Int?
}
