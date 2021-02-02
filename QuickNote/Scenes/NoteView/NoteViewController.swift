//
//  NoteViewController.swift
//  QuickNote
//
//  Created by Gwendal on 16/01/2021.
//

import UIKit

class NoteViewController: UIViewController {

    var noteTitle: String?
    var noteContent: String!
        
    
    @IBOutlet weak var noteTitleTextView: UITextView!
    
    @IBOutlet weak var noteContentTextView: UITextView!
    
    let backButton = UIBarButtonItem()
    let validateEditButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(validateEdit))
    
   
    class func newInstance(nibName: String?, title: String, content: String) -> NoteViewController {
        let vc = NoteViewController(nibName: nibName, bundle: nil)
        vc.noteTitle = title
        vc.noteContent = content
        return vc
    }
    
    @objc private func validateEdit() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTitleTextView.delegate = self
        self.noteContentTextView.delegate = self
        
        noteContentTextView.isHidden = false
        
        backButton.title = NSLocalizedString("controller.navigation.notes", comment: "")

        noteTitleTextView.text = noteTitle
        noteTitleTextView.textContainer.maximumNumberOfLines = 2
        noteContentTextView.text = noteContent

        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = validateEditButton
        
        validateEditButton.isEnabled = false
        
    }
    
}


extension NoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        validateEditButton.isEnabled = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
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

