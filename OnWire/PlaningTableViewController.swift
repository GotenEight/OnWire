//
//  PlaningTableViewController.swift
//  OnWire
//
//  Created by Insinema on 31.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit

@objc protocol planOnDayViewControllerDelegate: class{
    func createPlanOnDay(planOnDay: EMPlaning)
}

class PlaningTableViewController: UITableViewController {
    
    @IBOutlet weak var firstTimePicker: UIDatePicker!
    @IBOutlet weak var secondTimePicker: UIDatePicker!
    @IBOutlet weak var planTextField: UITextField!
    var delegate: planOnDayViewControllerDelegate?
    var valueArray: [EMPlaning] = []
    var planOnDayDict: [String:EMPlaning]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationViewController()
        setFirebase()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseListner.shared.addListner(listner: self, notificationType: .planOnDay, selector: #selector(reloadTableView))
        setFirebase()
    }
    
    @objc func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func setFirebase() {
        planOnDayDict = FirebaseListner.shared.planOnDayDict(includeDeleted: false)
        if planOnDayDict != nil {
            self.valueArray = []
            for (_,value) in planOnDayDict! {
                valueArray.append(value)
            }
        }
        self.tableView.reloadData()
    }
    
    func setNavigationViewController() {
        navigationController?.navigationBar.backgroundColor = UIColor.init(red: 122.0/255.0, green: 232.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return valueArray.count
    }
    
    func date(timeInterval:Double)->String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(from: date)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var dict = ["firstTime": firstTimePicker.date.timeIntervalSince1970,
                    "secondTime": secondTimePicker.date.timeIntervalSince1970,
                    "planText": planTextField.text,
                    "isDeleted": false ] as [String:Any]
        
        FirebaseManager.shared.planOnDayCreate(dict, completion: { planOnDayId in
            dict[EMPlaningConst.id.rawValue] = planOnDayId
            if let planOnDay = EMPlaning(info: dict){
                self.valueArray.append(planOnDay)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self.delegate?.createPlanOnDay(planOnDay: planOnDay)
                })
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "planingCell", for: indexPath) as! PlaningTableViewCell
        let planOnDay = valueArray[indexPath.row]
        let fTime =  date(timeInterval: planOnDay.firstTime)
        let sTime = date(timeInterval: planOnDay.secondTime)
        cell.planLabel.text = planOnDay.planText
        cell.timeLabel.text = "\(fTime)-\(sTime)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
