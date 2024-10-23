//
//  Movie.swift
//  MovieApp
//
//  Created by Варвара Уткина on 23.10.2024.
//

import Foundation

struct Movie: Decodable {
    let genre: [String]
    let imageurl: [String]
    let imdbrating: Double
    let released: Int
    let synopsis: String
    let title: String
    let type: String
}

struct ListOfMovies: Decodable {
    let results: [Movie]
}
