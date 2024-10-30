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
    private var movies: [Movie]?
    private var filteredMovie: [Movie] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        fetchMovies()
        setupSearchController()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movie = sender as? Movie else { return }
        guard let movieDetailsVC = segue.destination as? MovieDetailsViewController else { return }
        movieDetailsVC.movie = movie
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredMovie.count : movies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        guard let cell = cell as? MovieCell else { return UITableViewCell() }
        let movie = isFiltering ? filteredMovie[indexPath.row] : movies?[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = isFiltering ? filteredMovie[indexPath.row] : movies?[indexPath.row]
        performSegue(withIdentifier: "showMovie", sender: movie)
    }
    
    // MARK: - Private Methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .customGrey
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .customGrey
        }

    }
    
    private func fetchMovies() {
        networkManager.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies.results
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContenForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContenForSearchText(_ searchText: String) {
        filteredMovie = movies?.filter { movie in
            movie.title.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
