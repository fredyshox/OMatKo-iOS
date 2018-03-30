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
    
    var lectureCodes: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var voteButton: RoundButton!
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Voting"
        
        pickerTextField.inputView = pickerView
        pickerTextField.delegate = self
        voteButton.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                                     style: .done,
                                                                     target: self,
                                                                     action: #selector(logOut(sender:)))
        
        loadLectureCodes()
    }
    
    func loadLectureCodes() {
        AppDelegate.dataService.events
            .asObservable()
            .subscribe(onNext: { (events) in
                self.pickerTextField.text?.removeAll()
                self.lectureCodes = events.map({ (event) -> String in
                    return event.id
                })
            })
            .disposed(by: disposeBag)
    }
    
    func errorAlert() -> UIAlertController {
        let errorAlert = UIAlertController(title: "Error", message: "Unable to send vote.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        return errorAlert
    }
    
    @objc
    func logOut(sender: Any?) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            log.error("Unable to sing out. \(err.localizedDescription)")
        }
    }
    
    @IBAction func vote(_ sender: Any) {
        let rating = rateSegmentedControl.selectedSegmentIndex + 1
        let code = pickerTextField.text ?? ""
        
        let voteAlert = UIAlertController(title: "Confirmation",
                                            message: "Are you sure you want to rate lecture \(code) for \(rating)?",
                                            preferredStyle: .alert)
        voteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            log.info("Attempt to vote: \(code) mark: \(rating)")
            
            do {
                try AppDelegate.dataService.vote(forEventWithId: code, mark: rating)
            } catch let err {
                log.error("Error: \(err.localizedDescription)")
                self.present(self.errorAlert(), animated: true, completion: nil)
            }
        }))
        voteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(voteAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension VoteViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lectureCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lectureCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerTextField.text = lectureCodes[row]
    }
    
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
