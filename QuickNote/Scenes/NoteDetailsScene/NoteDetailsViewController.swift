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
    var note: Note!
    
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
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = validateEditButton
        
        validateEditButton.isEnabled = false
        
    }
    
    class func newInstance(nibName: String?, userID: String, note: Note) -> NoteDetailsViewController {
        let vc = NoteDetailsViewController(nibName: nibName, bundle: nil)
        vc.userID = userID
        vc.note = note
        return vc
    }
    
    @objc private func validateEdit() {
        if let title = noteTitleTextView.text,
           let content = noteContentTextView.text {
            QuickNoteClient.editNote(forUser: userID, withID: note.id, title: title, andContent: content) { (success) in
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
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateEditButton.isEnabled = true
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
