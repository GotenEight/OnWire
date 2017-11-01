//
//  MessengeTableViewController.swift
//  OnWire
//
//  Created by Insinema on 20.09.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

class MessengeTableViewController: UITableViewController {
    
    var numberOfRow: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHeader()
    }

    func tableViewHeader() {
        let rect = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 100)
        self.tableView.tableHeaderView = UIView(frame: rect)
        self.tableView.tableHeaderView?.backgroundColor = UIColor.clear
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 90))
        view.backgroundColor = UIColor(displayP3Red: 20.0/255.0, green: 139.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        self.tableView.tableHeaderView?.addSubview(view)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRow
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIndentifier = "MessengeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? MessengerTableViewCell else {
            fatalError("The dequeued cell is not an instance of MessengeTableViewCell.")
        }
        
        
        cell.expImageView.layer.borderWidth = 3
        cell.expImageView.backgroundColor = UIColor.white
        cell.expImageView.layer.cornerRadius = 10
        
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
