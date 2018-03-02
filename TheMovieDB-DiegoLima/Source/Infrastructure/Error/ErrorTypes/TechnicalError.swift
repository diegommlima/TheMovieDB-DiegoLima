//
//  TechnicalError.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

enum ApiError: Error {
    case parse(String)
    case httpError(Int)
    case invalidURL
    case offlineMode
}
