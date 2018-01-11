//
//  MoreViewController.swift
//  OnWire
//
//  Created by Insinema on 07.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit
import FirebaseAuth

class MoreViewController: UITableViewController {
    
    var dataSource = [("Rate Us","more_rate_us"),
                      ("Settings","more_settings"),
                      ("About","more_about"),
                      ("Log Out","more_logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
       // createVersionFooter()
    }
    
  /*  func createVersionFooter(){
        guard let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {return}
        var buildNumber = ""
        if _isDebugAssertConfiguration(), let _buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String{
            self.dataSource.append(("Debug Settings","more_debugSettings"))
            buildNumber = " (\(_buildNumber))"
        }
      //  self.versionLabel.text = "Attendance Manager v.\(versionNumber)\(buildNumber)\n© Smart Logic Inc. 2017"
    }
    */
    
    func rateUs(){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id896023706"){
            UIApplication.shared.openURL(url)
        }
    }
    
    func debugSettings() {
        performSegue(withIdentifier: "debug_settings", sender: nil)
    }
    
    func settings(){
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    func about(){
        performSegue(withIdentifier: "about", sender: nil)
    }
    
    func logOut(){
        FirebaseManager.shared.signOut()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreViewControllerCell
        
        let item = dataSource[indexPath.row]
        print(dataSource[indexPath.row].0)
        cell.nameLabel.text = item.0
        cell.iconImage.image = UIImage(named: "LastNameIcon")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            rateUs()
            break
        case 1:
            settings()
            break
        case 2:
            about()
            break
        case 3:
            logOut()
            break
        default:
            break
        }
    }
}
