//
//  ViewController.swift
//  MovieApp
//
//  Created by Варвара Уткина on 23.10.2024.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet var miniView: UIView!
    @IBOutlet var mediumView: UIView!
    @IBOutlet var bigView: UIView!
    
    private let networkManager = NetworkManager.shared
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0) { [unowned self] in
                miniView.frame.origin.x = -80
                miniView.frame.origin.y = 200
                mediumView.frame.origin.x = -120
                mediumView.frame.origin.y = -50
                bigView.frame.origin.x = -20
            }
        fetchMovies()
    }
    
    override func viewWillLayoutSubviews() {
        miniView.layer.cornerRadius = miniView.frame.width / 2
        mediumView.layer.cornerRadius = mediumView.frame.width / 2
        bigView.layer.cornerRadius = bigView.frame.width / 2
    }

    private func fetchMovies() {
        networkManager.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies.results
                print(self.movies)
            case .failure(let error):
                print(error)
            }
        }
    }
}

