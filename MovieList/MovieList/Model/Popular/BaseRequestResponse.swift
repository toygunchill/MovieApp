//
//  BaseRequestResponse.swift
//  MovieList
//
//  Created by Toygun Çil on 26.07.2022.
//

import Foundation

struct BaseRequestResponse: Codable {
    let results: [Movie]?
    let page: Int?
    let total_page: Int?
}
