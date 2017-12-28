//
//  BranchesViewController.swift
//  OnWire
//
//  Created by Insinema on 03.12.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

@objc protocol BranchViewControllerDelegate: class{
    func createBranch(branch: EMExperience)
}

class BranchesViewController: UITableViewController {
    var numberOfSection = 0
    var exp: [EMExperience] = []
    var delegate: BranchViewControllerDelegate?
    var infoBranch: [String:Any]?
    var branchArray: [[String:Any]] = []
    var branchesDict: [String:EMExperience]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationViewController()
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseListner.shared.addListner(listner: self, notificationType: FirebaseListnerNotification.branch, selector: #selector(branchAdded))
        branchAdded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setNavigationViewController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
    
    @objc func branchAdded(){
        self.branchesDict = FirebaseListner.shared.branchDict(includeDeleted: false)
    }
    
    @objc func addButtonPressed() {
        let level = 0
        let experiencePoints = 0
        let isDeleted: NSNumber = false
        
        let alert = UIAlertController(title: "Branch",
                                      message: "Add branch",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let textField = alert.textFields![0]
                                        var dict = ["branchName": textField.text!,
                                                    "level": level,
                                                    "experiencePoints": experiencePoints,
                                                    "isDeleted": isDeleted ] as [String:Any]
                                        FirebaseManager.shared.createBranch(dict, completion: { branchId,info in
                                            dict[EMExperienceConst.id.rawValue] = branchId
                                            self.branchArray.append(info)
                                            if let branch = EMExperience(info: dict){
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                                    self.delegate?.createBranch(branch: branch)                                               })
                                            }
                                        })
                                        self.tableView.reloadData()
                }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return branchArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "branchesCell", for: indexPath) as! BranchesTableViewCell
    
        return cell
    }
}
