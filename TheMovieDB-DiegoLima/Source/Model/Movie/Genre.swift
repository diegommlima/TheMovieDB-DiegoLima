//
//  Genre.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation

struct Genre: Codable {
    
    var identifier: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
    }
}
