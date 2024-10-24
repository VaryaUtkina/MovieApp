//
//  ViewController.swift
//  MovieApp
//
//  Created by Варвара Уткина on 23.10.2024.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet var miniView: UIView!
    @IBOutlet var mediumView: UIView!
    @IBOutlet var bigView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0) { [unowned self] in
                miniView.frame.origin.x = -80
                miniView.frame.origin.y = 200
                mediumView.frame.origin.x = -120
                mediumView.frame.origin.y = -50
                bigView.frame.origin.x = -20
            }
        fetchMovies()
    }
    
    override func viewWillLayoutSubviews() {
        miniView.layer.cornerRadius = miniView.frame.width / 2
        mediumView.layer.cornerRadius = mediumView.frame.width / 2
        bigView.layer.cornerRadius = bigView.frame.width / 2
    }

    private func fetchMovies() {
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
                print(error ?? "Error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let listOfMovies = try decoder.decode(ListOfMovies.self, from: data)
                print(listOfMovies)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

