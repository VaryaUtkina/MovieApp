//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Варвара Уткина on 24.10.2024.
//

import UIKit

final class MoviesViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var movies: [Movie] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        tableView.rowHeight = 80
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movie = sender as? Movie else { return }
        guard let movieDetailsVC = segue.destination as? MovieDetailsViewController else { return }
        movieDetailsVC.movie = movie
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
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        print(movie)
        performSegue(withIdentifier: "showMovie", sender: movie)
    }
    
    // MARK: - Private Methods
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
