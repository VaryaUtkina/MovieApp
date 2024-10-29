//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Варвара Уткина on 23.10.2024.
//

import Foundation


enum NetworkError: Error {
    case noData
    case decodingError
    case noImageData
    case wrongType
    case invalidURL
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
                completion(.failure(.noData))
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
    
    func fetchImage(fromMovie movie: Movie, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let imageUrl = movie.imageurl.first else {
            completion(.failure(.wrongType))
            return
        }
        guard let url = URL(string: imageUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(.failure(.noImageData))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                completion(.failure(.noImageData))
                return
            }
            
            guard let data else {
                completion(.failure(.noImageData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
        
    }
}
