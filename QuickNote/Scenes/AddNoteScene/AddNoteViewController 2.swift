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
    
    var bottomBorder = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        cancelButton.setTitle("\(NSLocalizedString("controller.navigation.cancel", comment: ""))", for: .normal)
        titleLabel.text = NSLocalizedString("controller.add_note.main_title", comment: "")
        titleTextField.placeholder = NSLocalizedString("controller.add_note.title_placeholder", comment: "")
        
        //Set textField UI (with bottom border only)
        setBottomBorder(textField: titleTextField)
        setBottomBorder(textView: contentTextView)
        
        //Set valide image size
        validateButton.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        validateButton.isEnabled = false
        validateButton.tintColor = .gray
        contentTextView.text = NSLocalizedString("controller.add_note.content_placeholder", comment: "")
        contentTextView.font = .systemFont(ofSize: 18.0)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validateButtonAction(_ sender: UIButton) {
        if let title = titleTextField.text {
            let content = contentTextView.text ?? ""
            QuickNoteClient.postNote(forUser: "user", withTitle: title, andContent: content) { (success, note) in
                if success,
                   let note = note {
                    if let navigationController = self.presentingViewController as? UINavigationController,
                       let presenter = navigationController.topViewController as? NoteListViewController {
                        presenter.notes.append(note)
                    }
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("controller.table.post_error_alert.title", comment: ""),
                                                  message: NSLocalizedString("controller.table.post_error_alert.message", comment: ""),
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
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
    
    func setBottomBorder(textView: UITextView) {
        textView.layoutIfNeeded()
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = .red
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        textView.superview!.addSubview(bottomBorder)
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
        if textView.text == NSLocalizedString("controller.add_note.content_placeholder", comment: "") {
            textView.textColor = UIColor.black
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
            textView.text = NSLocalizedString("controller.add_note.content_placeholder", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("controller.add_note.content_placeholder", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
}
