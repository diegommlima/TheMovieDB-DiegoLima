//
//  AppDelegate.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 2/28/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let upcomingRequest = MovieListRequest()
        let request = try? JSONEncoder().encode(upcomingRequest)
        let parameters: NetworkParameters = (nil, request)
        
        _ = TheMovieDBApiProvider.sharedProvider.dataTaskFor(httpMethod: .get,
                                                             endPoint: "/movie/upcoming",
                                                             parameters: parameters,
                                                             header: nil,
                                                             progressCallback: { (progress) in
                                                                print("progress:\(progress)")
        },
                                                             completion: { (result) in
                                                                
                                                                guard let upcomingResult = try? result() else {
//                                                                    throw BusinessError.parse("Could not parse response Data: MovieBusiness.upcomingMovies")
                                                                    return
                                                                }
                                                                
                                                                guard let upcomingList = try? JSONDecoder().decode(MovieList.self, from: upcomingResult) else {
//                                                                    throw BusinessError.parse("""
//                            Could not parse response Json into Object: MovieBusiness.upcomingMovies")
//                        """)
                                                                    return
                                                                }
                                                                
                                                                
                                                                
                                                                print("result:\(upcomingList)")

        })

        return true
    }
}
