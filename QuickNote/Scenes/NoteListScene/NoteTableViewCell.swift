//
//  NoteTableViewCell.swift
//  QuickNote
//
//  Created by Théo Brouillé on 22/02/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryLabel.layer.masksToBounds = true
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.font = .systemFont(ofSize: 10)
    
    }
}
