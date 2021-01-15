//
//  MainTableViewController.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    var notes: [Note] = [Note(title: "Test 1", content: "This is a first test"),
                         Note(title: "Test 2", content: "This is a second test"),
                         Note(title: "Test 3", content: "This is a third test")]
    
    let addNoteViewController = AddNoteViewController(nibName: "AddNoteViewController", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QuickNote"
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "note-cell")
    }
    
    @objc private func addButton() {
        self.present(addNoteViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem = rightButton
        
     
    }

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note-cell", for: indexPath) as! NoteTableViewCell
        let note = self.notes[indexPath.row]
        
        cell.titleLabel.text = note.getTitle()
        cell.subtitleLabel.text = note.getContent()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete) {
            //remove the data from the array and update the tableview)
        }
    }
    
   
}
