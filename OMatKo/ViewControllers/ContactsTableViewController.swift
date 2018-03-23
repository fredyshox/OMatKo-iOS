//
//  ContactsTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import RxSwift

class ContactsTableViewController: OMKTableViewController {
    
    static let contactCellHeight: CGFloat = 320.0
    
    var contacts: [Contact] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()

        localDataService
            .fetchContacts()
            .subscribe({ (event) in
                switch event {
                case .next(let contact):
                    self.contacts.append(contact)
                case .error(let error):
                    log.error("Error: \(error.localizedDescription)")
                case .completed:
                    log.info("Completed.")
                }
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTableView() {
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "contactCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell

        cell.contactImageView.backgroundColor = UIColor.omatkoSecondary
        
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.emailLabel.text = contact.email
        cell.phoneLabel.text = contact.phoneNumber
        cell.positionLabel.text = contact.position
        cell.descriptionLabel.text = contact.description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactsTableViewController.contactCellHeight
    }
    
}
