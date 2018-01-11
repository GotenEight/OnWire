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
    var valueArray: [EMExperience] = []
    var keysArray: [String] = []
    var selectBranch: EMExperience?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationViewController()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFirebase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.tableView.reloadData()
    }
    
    @objc func setFirebase() {
        branchesDict = FirebaseListner.shared.branchDict(includeDeleted: false)
        if branchesDict != nil {
            self.valueArray = []
            for (key,value) in branchesDict! {
                valueArray.append(value)
                keysArray.append(key)
            }
        }
        self.tableView.reloadData()
    }
    
    func setNavigationViewController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
    
    @objc func addButtonPressed() {
        let experiencePoints = 0
        let level = 1
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
                                        FirebaseManager.shared.createBranch(dict, completion: { branchId in
                                            dict[EMExperienceConst.id.rawValue] = branchId
                                            if let branch = EMExperience(info: dict){
                                                self.valueArray.append(branch)
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                                    self.delegate?.createBranch(branch: branch)                                               })
                                            }
                                            self.tableView.reloadData()
                                        })
                }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "branchesCell", for: indexPath) as! BranchesTableViewCell
        let branch = valueArray[indexPath.row]
        cell.branchName.text = branch.branchName
        cell.branchProccentage.text = String(branch.experiencePoints * 5) + "%"
        cell.progressView.points = branch.experiencePoints
        cell.branchLvl.text = String(branch.level) + " level"
        cell.experiencePoints = branch.experiencePoints
        cell.branchLvlString = String(branch.level)
        cell.branchId = branch.objectId
        cell.lvlInt = branch.level
        cell.branchArray = branch
        cell.progressView.setNeedsDisplay()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? BranchesTableViewCell{
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController {
                vc.experiencePoints = cell.experiencePoints
                vc.level = cell.branchLvlString
                vc.branchId = cell.branchId
                vc.lvlInt = cell.lvlInt
                vc.array = cell.branchArray
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectBranch = valueArray[indexPath.row]
            valueArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        FirebaseManager.shared.deleteBranch((selectBranch?.objectId)!)
    }
}
