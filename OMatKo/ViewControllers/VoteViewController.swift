//
//  VotingViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 13.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift

class VoteViewController: OMKViewController {
    
    var lectureCodes: [String] = []
    
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var voteButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerTextField.delegate = self
        pickerTextField.autocorrectionType = .no
        voteButton.isEnabled = false
        voteButton.setBackgroundImage(UIImage.from(color: UIColor.lightGray, size: CGSize(width: 33, height: 33)),
                                         for: .disabled)
        
        self.navigationItem.hidesBackButton = true
        
        loadLectureCodes()
    }
    
    func loadLectureCodes() {
        AppDelegate.dataService.votingOptions
            .asObservable()
            .subscribe(onNext: { (eventKeys) in
                self.pickerTextField.text?.removeAll()
                self.lectureCodes = eventKeys
            })
            .disposed(by: disposeBag)
    }
    
    func errorAlert() -> UIAlertController {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Unable to send vote.", comment: "")
        let ok = NSLocalizedString("OK", comment: "")
        
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: ok, style: .cancel, handler: nil))
        
        return errorAlert
    }
    
    func validationErrorAlert() -> UIAlertController {
        let title = NSLocalizedString("Invalid code", comment: "")
        let message = NSLocalizedString("Provided lecture code is invalid.", comment: "")
        let tryAgain = NSLocalizedString("Try again", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: tryAgain, style: .default, handler: nil))
        
        return alert
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            log.error("Unable to sing out. \(err.localizedDescription)")
        }
    }
    
    func validateLectureCode(code: String) -> Bool {
        return self.lectureCodes.contains(code)
    }
    
    @IBAction func vote(_ sender: Any) {
        let rating = rateSegmentedControl.selectedSegmentIndex + 1
        let code = pickerTextField.text ?? ""
        
        if !validateLectureCode(code: code) {
            present(validationErrorAlert(), animated: true, completion: nil)
        } else {
            let message = String(format: NSLocalizedString("Are you sure you want to rate lecture %@ for %d?", comment: ""), code, rating)
            
            let voteAlert = UIAlertController(title: NSLocalizedString("Confirmation", comment: ""),
                                              message: message,
                                              preferredStyle: .alert)
            voteAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (_) in
                log.info("Attempt to vote: \(code) mark: \(rating)")
                
                do {
                    try AppDelegate.dataService.vote(forEventWithId: code, mark: rating)
                } catch let err {
                    log.error("Error: \(err.localizedDescription)")
                    self.present(self.errorAlert(), animated: true, completion: nil)
                }
            }))
            voteAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            
            self.present(voteAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension VoteViewController:  UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil {
            self.voteButton.isEnabled = false
            log.info("Vote button disabled")
        } else if textField.text!.isEmpty {
            self.voteButton.isEnabled = false
            log.info("Vote button disabled")
        } else {
            self.voteButton.isEnabled = true
            log.info("Vote button enabled")
        }
    }
    
}
