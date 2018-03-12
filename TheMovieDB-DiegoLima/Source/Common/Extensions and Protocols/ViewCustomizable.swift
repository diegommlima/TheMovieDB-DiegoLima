//
//  ViewCustomizable.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Lima on 09/03/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import UIKit

/// Protocol to specifiy when a controller has a mainView with a custom class
/// use with typealias = <CustomView>
protocol ViewCustomizable: class {
    associatedtype CustomView
    
    var customView: CustomView { get }
}

extension ViewCustomizable where Self : UIViewController {
    
    var customView: CustomView {
        guard let customView = self.view as? CustomView else { fatalError("Could not cast Custom View") }
        return customView
    }
}
