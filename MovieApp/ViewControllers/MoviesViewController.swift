//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Варвара Уткина on 24.10.2024.
//

import UIKit

final class MoviesViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        tableView.rowHeight = 120
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        guard let cell = cell as? MovieCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    private func fetchMovies() {
        networkManager.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies.results
                print(self.movies)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}
