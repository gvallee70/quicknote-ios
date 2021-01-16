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
    
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
    
    class func newInstance(nibName: String?, title: String, content: String) -> NoteViewController {
        let vc = NoteViewController(nibName: nibName, bundle: nil)
        vc.noteTitle = title
        vc.noteContent = content
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTitleLabel.text = noteTitle
        noteContentLabel.text = noteContent
        
        let backButton = UIBarButtonItem()
        backButton.title = NSLocalizedString("controller.navigation.notes", comment: "")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
