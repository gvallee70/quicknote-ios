//
//  AddNoteViewController.swift
//  QuickNote
//
//  Created by Gwendal on 14/01/2021.
//

import UIKit

class AddNoteViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var addCategoryLabel: UILabel!
    
    @IBOutlet weak var segmentedCategories: UISegmentedControl!
    
    var category: String!
    @IBOutlet weak var switchCategories: UISwitch!

    @IBAction func segmentedCategoriesPressed(_ sender: UISegmentedControl) {
        switch segmentedCategories.selectedSegmentIndex {
        case 0: category = Note.Category.work.rawValue
        case 1: category = Note.Category.personal.rawValue
        case 2: category = Note.Category.other.rawValue
        default:break;
        }
    }

    @IBAction func switchPressed(_ sender: UISwitch) {
        if switchCategories.isOn {
            segmentedCategories.isHidden = false
        } else {
            segmentedCategories.isHidden = true
        }
    }
    
    var userID: String!
    
    var bottomBorder = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        cancelButton.setTitle(ACTION_CANCEL, for: .normal)
        titleLabel.text = TITLE_WHATS_NEW
        addCategoryLabel.text = LABEL_ADD_CATEGORY
        titleTextField.placeholder = PLACEHOLDER_TITLE
        contentTextView.text = PLACEHOLDER_CONTENT
        contentTextView.font = .systemFont(ofSize: 18.0)
        
        
        //Set textField UI (with bottom border only)
        setBottomBorder(textField: titleTextField)
        
        //Set valide image size
        validateButton.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        validateButton.isEnabled = false
        validateButton.tintColor = .gray
        
        switchCategories.isOn = false
        segmentedCategories.isHidden = true
        
        setupCategoriesSegmentedControl()
    

    }
    
    func setupCategoriesSegmentedControl() {
        segmentedCategories.removeAllSegments()
        
        Note.Category.allCases.enumerated().forEach {
            if $1.rawValue != "" {
                segmentedCategories.insertSegment(withTitle: $1.rawValue, at: $0, animated: true)
            }
        }
    }
    
//    class func newInstance(nibName: String?, userID: String) -> NoteDetailsViewController {
//        let vc = NoteDetailsViewController(nibName: nibName, bundle: nil)
//        vc.userID = userID
//        return vc
//    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validateButtonAction(_ sender: UIButton) {
        if let title = titleTextField.text {
            var content = ""
            if contentTextView.text != PLACEHOLDER_CONTENT {
                content = contentTextView.text
            }
            if !switchCategories.isOn {
                category = ""
            }
            
            QuickNoteClient.createNote(forUser: userID, withTitle: title, andContent: content, andCategory: category) { (success, note) in
                if success,
                   let note = note {
                    if let navigationController = self.presentingViewController as? UINavigationController,
                       let presenter = navigationController.topViewController as? NoteListViewController {
                        presenter.notes.insert(note, at: 0)
                    }
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: LABEL_ERROR,
                                                  message: MESSAGE_ERROR_CREATE,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: ACTION_OK, style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func setBottomBorder(textField: UITextField) {
        textField.borderStyle = .none
        textField.layoutIfNeeded()
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
}


extension AddNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.contentTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // While titleTextField is empty, validate button is disabled
        if textField == self.titleTextField {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let maxCharacters = 40
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if text.isEmpty {
                validateButton.tintColor = .gray
                validateButton.isEnabled = false
            } else {
                validateButton.isEnabled = true
                validateButton.tintColor = .systemBlue
            }
            
            return newString.length <= maxCharacters
            
        }
        return true
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == PLACEHOLDER_CONTENT {
            textView.textColor = UIColor(named: "TextColor")
            textView.text = ""
        }
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PLACEHOLDER_CONTENT
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PLACEHOLDER_CONTENT
            textView.textColor = UIColor.lightGray
        }
    }
}
