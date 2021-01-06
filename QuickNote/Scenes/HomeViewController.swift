//
//  HomeViewController.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QuickNote"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
    }
}
