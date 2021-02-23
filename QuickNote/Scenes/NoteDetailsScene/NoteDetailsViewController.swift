//
//  NoteDetailsViewController.swift
//  QuickNote
//
//  Created by Gwendal on 16/01/2021.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    @IBOutlet weak var noteTitleTextView: UITextView!
    @IBOutlet weak var noteContentTextView: UITextView!
    
    var userID: String!
    var note: Note! {
        didSet {
            validateEditButton.isEnabled = true
        }
    }
//    var category:String?
    
    let backButton = UIBarButtonItem()
    let validateEditButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(validateEdit))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTitleTextView.delegate = self
        self.noteContentTextView.delegate = self
        
        noteContentTextView.isHidden = false
        
        backButton.title = ACTION_BACK
        
        noteTitleTextView.text = note.title
        noteTitleTextView.textContainer.maximumNumberOfLines = 2
        noteContentTextView.text = note.content
        
        validateEditButton.isEnabled = false
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        let categoriesListButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(setCategory))
        
        navigationItem.rightBarButtonItems = [validateEditButton, categoriesListButton]
    }
    
    class func newInstance(nibName: String?, userID: String, note: Note) -> NoteDetailsViewController {
        let vc = NoteDetailsViewController(nibName: nibName, bundle: nil)
        vc.userID = userID
        vc.note = note
        return vc
    }
    
    @objc private func setCategory() {
        let actionSheet = UIAlertController(title: TITLE_CHOOSE_CATEGORY, message: nil, preferredStyle: .actionSheet)
        Note.Category.allCases.enumerated().forEach {
            if $1.rawValue != "" {
                actionSheet.addAction(UIAlertAction(title: $1.rawValue, style: .default, handler: { (action) in
                    if let categoryStr = action.title {
                        switch categoryStr {
                        case LABEL_WORK:
                            self.note.category = .work
                        case LABEL_PERSONAL:
                            self.note.category = .personal
                        case LABEL_OTHER:
                            self.note.category = .other
                        default:
                            break
                        }
                    }
                }))
            }
        }
        actionSheet.addAction(UIAlertAction(title: ACTION_CANCEL, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func validateEdit() {
        print("ok")
        QuickNoteClient.editNote(forUser: userID, withID: note.id, title: note.title, andContent: note.content, andCategory: note.category.rawValue) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: LABEL_ERROR,
                                              message: MESSAGE_ERROR_UPDATE,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ACTION_OK, style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == noteTitleTextView {
            note.title = textView.text
        } else {
            note.content = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == self.noteTitleTextView {
                self.noteContentTextView.becomeFirstResponder()
            } else if textView == self.noteContentTextView {
                textView.resignFirstResponder()
            }
            return false
        }
        return true
    }
}
