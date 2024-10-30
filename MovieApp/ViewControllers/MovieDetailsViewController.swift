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
    private var spinnerView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(in: movieImageView)
        setupUI()
    }
    
    private func setupUI() {
        networkManager.fetchImage(fromMovie: movie) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageData):
                movieImageView.image = UIImage(data: imageData)
                spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    movieImageView.image = UIImage(systemName: "movieclapper")
                    movieImageView.tintColor = .customGrey
                    spinnerView.stopAnimating()
                }
            }
        }
        
        movieTitle.text = movie.title
        releasedAndTypeLabel.text = "\(movie.released), \(movie.type)"
        
        imdbRatingLabel.text = movie.imdbrating.formatted()
        imdbRatingLabel.textColor = movie.imdbrating >= 7 ? .customGreen : .customGrey
        
        genreLabel.text = "Genre: \(movie.genre.joined(separator: ", "))"
        synopsisLabel.text = "Synopsis: \(movie.synopsis)"
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.color = .customGrey
        spinnerView.startAnimating()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
}
