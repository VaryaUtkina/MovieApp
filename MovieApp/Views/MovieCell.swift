//
//  MovieCell.swift
//  MovieApp
//
//  Created by Варвара Уткина on 26.10.2024.
//

import UIKit

final class MovieCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var yearAndTypeLabel: UILabel!
    @IBOutlet var movieView: UIImageView!
    
    private let networkManager = NetworkManager.shared
    private var spinnerView = UIActivityIndicatorView()
    
    func configure(with movie: Movie?) {
        guard let movie else { return }
        nameLabel.text = movie.title
        rateLabel.text = movie.imdbrating.formatted()
        rateLabel.textColor = movie.imdbrating >= 7 ? .customGreen : .customGrey
        yearAndTypeLabel.text = "\(movie.released), \(movie.type)"
        
        networkManager.fetchImage(fromMovie: movie) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageData):
                movieView.image = UIImage(data: imageData)
                spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    movieView.image = UIImage(systemName: "movieclapper")
                    movieView.tintColor = .customGrey
                    spinnerView.stopAnimating()
                }
            }
        }
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
