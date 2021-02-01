//
//  MainTableViewController.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    //let searchBar = UISearchBar()
    
    var filteredNotes: [Note] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    var notes: [Note] = [Note(title: "Test 1", content: "This is a first test"),
                         Note(title: "Test 2", content: "This is a second test"),
                         Note(title: "Test 3", content: "This is a third test"),
                         Note(title: "Test fgyabda ubdaubdau bdaud bdaudadua4", content: "This is a first This is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first testThis is a first test"),
                         Note(title: "Test 5", content: "This is a second test"),
                         Note(title: "Test 6", content: "This is a third test"),
                         Note(title: "Test 7", content: "This is a first test"),
                         Note(title: "Test 8", content: "This is a second test"),
                         Note(title: "Test 9", content: "This is a third test"),
                         Note(title: "Test 10", content: "This is a first test"),
                         Note(title: "Test 11", content: "This is a second test"),
                         Note(title: "Test 12", content: "This is a third test"),
                         Note(title: "Test 13", content: "This is a first test"),
                         Note(title: "Test 14", content: "This is a second test"),
                         Note(title: "Test 15", content: "This is a third test"),
                         Note(title: "Test 16", content: "This is a third test"),
                         Note(title: "Test 17", content: "This is a first test"),
                         Note(title: "Test 18", content: "This is a second test"),
                         Note(title: "Test 19", content: "This is a third test"),
                         Note(title: "Test 20", content: "This is a first test"),
                         Note(title: "Test 21", content: "This is a second test"),
                         Note(title: "Test 22", content: "This is a third test"),]
    
    let addNoteViewController = AddNoteViewController(nibName: "AddNoteViewController", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QuickNote"

//        navigationItem.titleView = searchBar
//        searchBar.placeholder = "Search a note"

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("controller.search_bar.placeholder", comment: "")

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
        if isFiltering {
            return filteredNotes.count
          }
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note-cell", for: indexPath) as! NoteTableViewCell
        let note: Note
        if isFiltering {
            note = self.filteredNotes[indexPath.row]
        } else {
            note = self.notes[indexPath.row]
        }
        
        cell.titleLabel.text = note.getTitle()
        cell.subtitleLabel.text = note.getContent()
        
        return cell
        
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNote : Note
        
        if isFiltering {
                selectedNote = filteredNotes[indexPath.row]
            } else {
                selectedNote = notes[indexPath.row]
            }
        
        let noteViewController = NoteViewController.newInstance(nibName: "NoteViewController", title: selectedNote.getTitle(), content: selectedNote.getContent())
        
            self.navigationController?.pushViewController(noteViewController, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete) {
            //remove the data from the array and update the tableview)
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredNotes = notes.filter { (note: Note) -> Bool in
        let searchTitle = note.getTitle().lowercased().contains(searchText.lowercased())
        let searchContent = note.getContent().lowercased().contains(searchText.lowercased())
        
        return searchTitle || searchContent
      }
      
      tableView.reloadData()
    }
   
}

//MARK: - Search Controller

extension MainTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

