//
//  NoteListViewController.swift
//  QuickNote
//
//  Created by Théo Brouillé on 17/02/2021.
//

import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet weak var noteTableView: UITableView!
    
    var notes: [Note] = [] {
        didSet {
            noteTableView.reloadData()
        }
    }
    var filteredNotes: [Note] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.dataSource = self
        noteTableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = PLACEHOLDER_SEARCH
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "QuickNote"
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonAction))
        
        QuickNoteClient.getNotes(forUser: "user") { (success, notes) in
            if success,
               let notes = notes {
                self.notes = notes
            } else {
                let alert = UIAlertController(title: LABEL_ERROR,
                                              message: MESSAGE_ERROR_LIST,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func addButtonAction() {
        let addNoteViewController = AddNoteViewController(nibName: "AddNoteViewController", bundle: nil)
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
            QuickNoteClient.deleteNote(forUser: "user", withID: notes[indexPath.row].id) { (success) in
                if success {
                    self.notes.remove(at: indexPath.row)
                } else {
                    let alert = UIAlertController(title: LABEL_ERROR,
                                                  message: MESSAGE_ERROR_DELETE,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
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
        let controller = NoteDetailsViewController.newInstance(nibName: "NoteDetailsViewController", note: note)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NoteListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            let searchTitle = note.title.lowercased().contains(searchText.lowercased())
            let searchContent = note.content.lowercased().contains(searchText.lowercased())
            return searchTitle || searchContent
        }
        noteTableView.reloadData()
    }
}
