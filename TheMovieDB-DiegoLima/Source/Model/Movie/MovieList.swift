//
//  MovieList.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
