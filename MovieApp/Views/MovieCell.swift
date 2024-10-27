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
    
    func configure(with movie: Movie) {
        nameLabel.text = movie.title
        rateLabel.text = movie.imdbrating.formatted()
        yearAndTypeLabel.text = "\(movie.released), \(movie.type)"
        
        DispatchQueue.global().async {
            if let imageUrlString = movie.imageurl.first,
                let url = URL(string: imageUrlString),
                let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [unowned self] in
                    movieView.image = UIImage(data: imageData)
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    movieView.image = UIImage(systemName: "movieclapper")
                    movieView.tintColor = .black
                }
            }
        }
    }
}
