//
//  PlaningTableViewController.swift
//  OnWire
//
//  Created by Insinema on 31.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit

class PlaningTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

   /* @objc func addButtonPressed() {
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
*/
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "planingCell", for: indexPath) as! PlaningTableViewCell

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
