//
//  MovieCastDetailReponse.swift
//  MovieList
//
//  Created by Toygun Çil on 15.08.2022.
//

import Foundation

struct MovieCastDetailResponse: Codable{
    let birthday: String?
    let name: String?
    let deathday: String?
    let profile_path: String?
    let place_of_birth: String?
}
