//
//  VotingViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 13.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
    
    var lectureCodes: [String] = ["Code1", "Code2", "Code3"]
    
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
        
        pickerTextField.inputView = pickerView
        pickerTextField.delegate = self
        voteButton.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                                     style: .done,
                                                                     target: self,
                                                                     action: #selector(logOut(sender:)))
    }
    
    @objc
    func logOut(sender: Any?) {
        log.info("Attempt to log out")
    }
    
    @IBAction func vote(_ sender: Any) {
        let rating = rateSegmentedControl.selectedSegmentIndex
        let code = pickerTextField.text ?? ""
        
        log.info("Attempt to vote: \(code) mark: \(rating)")
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
            log.info("Disabled")
        } else {
            self.voteButton.isEnabled = true
            log.info("Enabled")
        }
    }
    
}
