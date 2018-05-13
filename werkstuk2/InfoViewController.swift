//
//  InfoViewController.swift
//  werkstuk2
//
//  Created by Pieter on 13/05/18.
//  Copyright © 2018 Pieter. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {
    @IBOutlet weak var lblCoreUpdate: UILabel!
    @IBOutlet weak var lblDataTime: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblTaal: UILabel!
    @IBOutlet weak var lblTaalAfkorting: UILabel!
    
    @IBAction func updatePressed(_ sender: Any) {
        DataManager.webserviceData(mapview: DataManager.mapView!, showMap: true)
        lastTimeUpdateToCoreData(epoch: NSDate().timeIntervalSince1970)
       
        
    }
    var DataManager = DataManagerSingleton.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Info", comment: "")
        lblCoreUpdate.text = NSLocalizedString("core data update", comment: "")
        btnUpdate.setTitle(NSLocalizedString("Update Core Data", comment: ""), for: UIControlState.normal)
        lblTaal.text = NSLocalizedString("Huidige Taal", comment: "")
        lblTaalAfkorting.text = NSLocalizedString("Taal", comment: "")
        lastTimeUpdateToCoreData(epoch: DataManager.lastUpdate)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        lastTimeUpdateToCoreData(epoch: DataManager.lastUpdate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lastTimeUpdateToCoreData(epoch: Double) -> Void {
        let date = NSDate(timeIntervalSince1970: epoch)
        //https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Europe/Brussels")
        let myString = formatter.string(from: date as Date)
        let yourDate = formatter.date(from: myString)
        let time = formatter.string(from: yourDate!)
        
        lblDataTime.text = time
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
