//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Варвара Уткина on 28.10.2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {

    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var releasedAndTypeLabel: UILabel!
    @IBOutlet var imdbRatingLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var synopsisLabel: UILabel!
    
    var movie: Movie!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        networkManager.fetchImage(fromMovie: movie, toImage: movieImageView)
        movieTitle.text = movie.title
        releasedAndTypeLabel.text = "\(movie.released), \(movie.type)"
        
        imdbRatingLabel.text = movie.imdbrating.formatted()
        imdbRatingLabel.textColor = movie.imdbrating >= 7 ? .green : .gray
        
        genreLabel.text = "Genre: \(movie.genre.joined(separator: ", "))"
        synopsisLabel.text = "Synopsis: \(movie.synopsis)"
    }
}
