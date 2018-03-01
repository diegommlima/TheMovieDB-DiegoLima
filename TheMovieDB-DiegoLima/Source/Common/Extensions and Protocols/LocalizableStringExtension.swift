//
//  LocalizableStringExtension.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 2/28/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation

extension String {
    
    func localize(isAccessibility: Bool = false) -> String {
        return NSLocalizedString(self,
                                 tableName: isAccessibility ? "LocalizableAcessibility" : "Localizable",
                                 bundle: Bundle.main,
                                 value: "",
                                 comment: self)
    }
}
