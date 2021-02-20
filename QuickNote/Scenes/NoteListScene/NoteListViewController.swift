//
//  NoteListViewController.swift
//  QuickNote
//
//  Created by Théo Brouillé on 17/02/2021.
//

import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet weak var noteTableView: UITableView!
    
    var userID: String = ""
    var notes: [Note] = [] {
        didSet {
            noteTableView.reloadData()
        }
    }
    var filteredNotes: [Note] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            userID = uuid
        }
        
        noteTableView.dataSource = self
        noteTableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = PLACEHOLDER_SEARCH
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Note.Category.allCases
          .map { $0.rawValue }
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "QuickNote"
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonAction))
        
        QuickNoteClient.getNotes(forUser: userID) { (success, notes) in
            if success,
               let notes = notes {
                self.notes = notes
            } else {
                let alert = UIAlertController(title: LABEL_ERROR,
                                              message: MESSAGE_ERROR_LIST,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ACTION_OK, style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func addButtonAction() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.userID = userID
        present(addNoteViewController, animated: true, completion: nil)
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        let cell = getNoteCell(tableView: tableView)
        cell.textLabel?.text = note.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isFiltering
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: LABEL_DELETE,
                                          message: MESSAGE_CONFIRM_DELETE,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ACTION_NO, style: .default, handler: { (negative) in
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: ACTION_YES, style: .destructive, handler: { (positive) in
                QuickNoteClient.deleteNote(forUser: self.userID, withID: self.notes[indexPath.row].id) { (success) in
                    if success {
                        self.notes.remove(at: indexPath.row)
                    } else {
                        let alert = UIAlertController(title: LABEL_ERROR,
                                                      message: MESSAGE_ERROR_DELETE,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: ACTION_OK, style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }))
            self.present(alert, animated: true)
        }
    }
    
    func getNoteCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "note-cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "note-cell")
        }
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = isFiltering ? self.filteredNotes[indexPath.row] : self.notes[indexPath.row]
        let controller = NoteDetailsViewController.newInstance(nibName: "NoteDetailsViewController", userID: userID, note: note)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NoteListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Note.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: category)
    }
    
    func filterContentForSearchText(_ searchText: String, category: Note.Category? = nil) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            let searchTitle = note.title.lowercased().contains(searchText.lowercased())
            let searchContent = note.content.lowercased().contains(searchText.lowercased())
            let matchCategory = category == .all //|| note.category == category
            
            if isSearchBarEmpty {
                return matchCategory
            } else {
                return matchCategory && searchTitle && searchContent
            }
        }
        noteTableView.reloadData()
    }
}

extension NoteListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = Note.Category(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}


