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
    }
    
    override func viewWillLayoutSubviews() {
        miniView.layer.cornerRadius = miniView.frame.width / 2
        mediumView.layer.cornerRadius = mediumView.frame.width / 2
        bigView.layer.cornerRadius = bigView.frame.width / 2
    }


}

