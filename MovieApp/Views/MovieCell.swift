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
    @IBOutlet var movieView: UIView!
    
    func configure(with movie: Movie) {
        nameLabel.text = movie.title
        rateLabel.text = movie.imdbrating.formatted()
        yearAndTypeLabel.text = "\(movie.released), \(movie.type)"
    }
}
