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
    
    let contentTextViewPlaceholder = NSLocalizedString("controller.add_note.content_placeholder", comment: "")
    
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }

    
    @IBOutlet weak var validateOutlet: UIButton!
    @IBAction func validateButton(_ sender: UIButton) {
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
    
    
    var bottomBorder = UIView()

    func setBottomBorder(textView: UITextView) {
        textView.layoutIfNeeded()
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
               bottomBorder.backgroundColor = .red
               bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        textView.superview!.addSubview(bottomBorder)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
        
        self.cancelOutlet.setTitle("\(NSLocalizedString("controller.navigation.cancel", comment: ""))", for: .normal)
        self.titleLabel.text = NSLocalizedString("controller.add_note.main_title", comment: "")
        self.titleTextField.placeholder = NSLocalizedString("controller.add_note.title_placeholder", comment: "")
        
        //Set textField UI (with bottom border only)
        setBottomBorder(textField: titleTextField)
        setBottomBorder(textView: contentTextView)

        //Set valide image size
        validateOutlet.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        
        validateOutlet.isEnabled = false
        validateOutlet.tintColor = .gray

        contentTextView.text = contentTextViewPlaceholder
        contentTextView.font = .systemFont(ofSize: 18.0)
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
        
        //While titleTextField is empty, validate button is disabled
        if textField == self.titleTextField {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let maxCharacters = 40
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
            
            if text.isEmpty {
                validateOutlet.tintColor = .gray
                validateOutlet.isEnabled = false
            } else {
                validateOutlet.isEnabled = true
                validateOutlet.tintColor = .systemBlue
           }
            
            return newString.length <= maxCharacters
            
        }
       
        return true
      }
    
}


extension AddNoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == contentTextViewPlaceholder {
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
            textView.text = contentTextViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentTextViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
}

