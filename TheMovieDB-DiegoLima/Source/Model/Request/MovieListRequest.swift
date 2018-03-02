//
//  MovieListRequest.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation

struct MovieListRequest: Codable {
    
    let apiKey = TheMovieDBApiProvider.apiSecret
    var page: Int?
    
    init(withPage page: Int = 1) {
        self.page = page
    }
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case page
    }
    
}
