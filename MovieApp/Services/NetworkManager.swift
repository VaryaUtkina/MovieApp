//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Варвара Уткина on 23.10.2024.
//

import UIKit


enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchMovies(completion: @escaping((Result<ListOfMovies, NetworkError>) -> Void)) {
        let headers = [
            "x-rapidapi-key": "8b70de7122mshf7d8da5b54e7c8ap129e91jsn91405a76579c",
            "x-rapidapi-host": "ott-details.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://ott-details.p.rapidapi.com/advancedsearch?start_year=1970&end_year=2020&min_imdb=6&max_imdb=7.8&genre=action&language=english&type=movie&sort=latest&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            guard let data else {
                print(error ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let listOfMovies = try decoder.decode(ListOfMovies.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(listOfMovies))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(fromMovie movie: Movie, toImage image: UIImageView) {
        DispatchQueue.global().async {
            if let imageUrlString = movie.imageurl.first,
                let url = URL(string: imageUrlString),
                let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    image.image = UIImage(data: imageData)
                }
            } else {
                DispatchQueue.main.async {
                    image.image = UIImage(systemName: "movieclapper")
                    image.tintColor = .customGrey
                }
            }
        }
    }
}
