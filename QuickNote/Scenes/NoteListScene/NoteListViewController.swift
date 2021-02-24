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
        
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "note-cell")
        noteTableView.estimatedRowHeight = 86
        noteTableView.rowHeight = UITableView.automaticDimension
        
        noteTableView.dataSource = self
        noteTableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = PLACEHOLDER_SEARCH
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Note.Category.allCases.map {
            if $0.rawValue == "" {
                return LABEL_ALL
            } else {
                return $0.rawValue
            }
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "note-cell", for: indexPath) as! NoteTableViewCell
        cell.titleLabel?.text = note.title
        cell.contentLabel?.text = note.content
        
        if note.category.rawValue == "" {
            cell.categoryLabel.isHidden = true
        } else {
            cell.categoryLabel.isHidden = false
            cell.categoryLabel.text = note.category.rawValue
            cell.categoryLabel.backgroundColor = note.category.color
        }

        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        
        let shareButton = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let shareViewController = UIActivityViewController(activityItems: [String(format: MESSAGE_SHARE_NOTE, note.title, note.content)],
                                                               applicationActivities: nil)
            
            self.present(shareViewController, animated: true, completion: nil)
            
        })
        
        shareButton.image = UIBarButtonItem.SystemItem.action.image()
        shareButton.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareButton])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: LABEL_DELETE,
                                          message: MESSAGE_CONFIRM_DELETE,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ACTION_NO, style: .default, handler: { (negative) in
                self.dismiss(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: ACTION_YES, style: .destructive, handler: { (positive) in
                QuickNoteClient.deleteNote(forUser: self.userID, withID: self.notes[indexPath.row].id) { (success) in
                    if success {
                        if self.isFiltering {
                            let noteID = self.filteredNotes[indexPath.row].id
                            var noteINDEX: Int = 0
                            for (index, note) in self.notes.enumerated() {
                                if note.id == noteID {
                                   noteINDEX = index
                                }
                            }
                            self.filteredNotes.remove(at: indexPath.row)
                            self.notes.remove(at: noteINDEX)
                        } else {
                            self.notes.remove(at: indexPath.row)
                        }
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
        })
        
        deleteButton.image = UIBarButtonItem.SystemItem.trash.image()
        deleteButton.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteButton])
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
    
    func filterContentForSearchText(_ searchText: String, category: Note.Category?) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            let searchTitle = note.title.lowercased().contains(searchText.lowercased())
            let searchContent = note.content.lowercased().contains(searchText.lowercased())
            let matchCategory = category == .none || note.category == category
            
            if isSearchBarEmpty {
                return matchCategory
            } else {
                return matchCategory && (searchTitle || searchContent)
            }
        }
        noteTableView.reloadData()
    }
}

extension NoteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Note.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension UIBarButtonItem.SystemItem {
    func image() -> UIImage? {
        let tempItem = UIBarButtonItem(barButtonSystemItem: self,
                                       target: nil,
                                       action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem],
                     animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if let button = view as? UIButton,
               let image = button.imageView?.image {
                return image.withRenderingMode(.alwaysTemplate)
            }
        }
        
        return nil
    }
}

