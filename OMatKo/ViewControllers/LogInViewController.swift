//
//  LogInViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 12.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class LogInViewController: OMKViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    static let emailTextFieldTag: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.tag = LogInViewController.emailTextFieldTag
        emailTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert() {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Email and password don't match.", comment: "")
        let ok = NSLocalizedString("OK", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validateEntries() -> Bool {
        var result = true
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty {
            emailTextField.errorMessage = NSLocalizedString("Invalid email", comment: "")
            result = false
        }
        
        if password.isEmpty {
            passwordTextField.errorMessage = NSLocalizedString("Invalid password", comment: "")
            result = false
        }
        
        
        return result
    }
    
    @IBAction func logIn(_ sender: Any) {
        guard let email = emailTextField.text,
               let password = passwordTextField.text,
               validateEntries()
        else {
            return
        }
            
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            guard err == nil, let user = user else {
                log.error("Error while sign in: \(err!.localizedDescription)")
                self.displayAlert()
                
                return
            }
            
            log.info("Logged in as: \(user.uid)")
            let storyboard = UIStoryboard(name: "Votes", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "votesVC")
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }

}

extension LogInViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if textField.tag == LogInViewController.emailTextFieldTag {
                if let emailTextField = textField as? SkyFloatingLabelTextField {
                    if text.count < 3 || !text.contains("@") {
                        emailTextField.errorMessage = NSLocalizedString("Invalid email", comment: "")
                    } else {
                        emailTextField.errorMessage = ""
                    }
                }
            }
        }
        
        return true
    }
}
