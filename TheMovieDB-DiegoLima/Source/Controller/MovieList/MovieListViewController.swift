//
//  MovieListViewController.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Lima on 09/03/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, Identifiable {
    
    // MARK: - Properties
    private var movieType: MovieType = .upcoming {
        didSet {
            switch movieType {
            case .upcoming:
                title = "movie_list.upcoming.title".localize()
            case .popular:
                title = "movie_list.popular.title".localize()
            }
        }
    }

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(MovieListViewController.refresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
//            collectionView.backgroundColor = UIColor.darkGray
        }
    }
    
    @IBOutlet weak var movieTypeSegmentedControl: UISegmentedControl! {
        didSet {
            movieTypeSegmentedControl.tintColor = UIColor.white
            movieTypeSegmentedControl.setTitle("movie_list.upcoming".localize(), forSegmentAt: 0)
            movieTypeSegmentedControl.setTitle("movie_list.popular".localize(), forSegmentAt: 1)
        }
    }
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainColor()
        collectionView?.refreshControl = refreshControl

//        loadMovies()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Methods
    
    private func loadMovies(refresh: Bool = false) {
        print("carregar da api")
    }
    
    @objc private func refresh() {
        loadMovies(refresh: true)
    }
    
    // MARK: - Actions
    
    @IBAction func didChangeMovieType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            movieType = .upcoming
        } else {
            movieType = .popular
        }
    }
}
