//
//  Movie.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    var identifier: Int?
    var voteAverage: Double?
    var title: String?
    var originalTitle: String?
    var popularity: Double?
    var posterPath: String?
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    var genres: [Genre]?
    var runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case voteAverage = "vote_average"
        case title
        case originalTitle = "original_title"
        case popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case genres
        case runtime
    }
}
