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
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        self.descriptionTextField.delegate = self
        
        self.cancelOutlet.setTitle("\(NSLocalizedString("controller.navigation.cancel", comment: ""))", for: .normal)
        self.titleLabel.text = NSLocalizedString("controller.add_note.main_title", comment: "")
        self.titleTextField.placeholder = NSLocalizedString("controller.add_note.title_placeholder", comment: "")
        self.descriptionTextField.placeholder = NSLocalizedString("controller.add_note.description_placeholder", comment: "")
    
    
        //Set textField UI (with bottom border only)
        setBottomBorder(textField: titleTextField)
        setBottomBorder(textField: descriptionTextField)

        //Set valide image size
        validateOutlet.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        
        validateOutlet.isEnabled = false
        validateOutlet.tintColor = .gray

    }
    
}


extension AddNoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.descriptionTextField.becomeFirstResponder()
        } else if textField == self.descriptionTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //While titleTextField is empty, validate button is disabled
        if textField == self.titleTextField {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if text.isEmpty{
                validateOutlet.tintColor = .gray
                validateOutlet.isEnabled = false
            } else {
                validateOutlet.isEnabled = true
                validateOutlet.tintColor = .systemBlue
           }
        }
        return true
      }
    
}

