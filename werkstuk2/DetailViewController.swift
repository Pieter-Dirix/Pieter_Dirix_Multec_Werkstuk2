//
//  DetailViewController.swift
//  werkstuk2
//
//  Created by Pieter on 13/05/18.
//  Copyright © 2018 Pieter. All rights reserved.
//

import UIKit
import CoreData
import MapKit



class DetailViewController: UIViewController {
    @IBOutlet weak var lblNaam: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblFietsenrekken: UILabel!
    @IBOutlet weak var lblBeschikbareFietsenrekken: UILabel!
    @IBOutlet weak var lblBeschikbareFietsen: UILabel!
    @IBOutlet weak var lblUpdate: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblAdres: UITextView!
    
    
    var station:Station?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Detail", comment: "")
        lblStatus.text = NSLocalizedString("Status", comment: "")
        lblFietsenrekken.text = NSLocalizedString("Fietsenrekken", comment: "")
        lblBeschikbareFietsenrekken.text = NSLocalizedString("Waarvan Beschikbaar", comment: "")
        lblBeschikbareFietsen.text = NSLocalizedString("Beschikbare Fietsen", comment: "")
        
        lblAdres.isEditable = false
        lblAdres.isSelectable = true
        setStationDataToLabels()
        showAnnotation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStationDataToLabels() ->Void {
        lblNaam.text = station?.name
        lblAdres.text = station?.address
        lblStatus.text = station?.status
        
        let rek16:Int16 = (station?.bike_stands)!
        let rekInt:Int = Int(rek16)
        lblFietsenrekken.text = String(rekInt)
        
        let beschik16:Int16 = (station?.available_bike_stands)!
        let beschikInt:Int = Int(beschik16)
        lblBeschikbareFietsenrekken.text = String(beschikInt)
        
        let fiets16:Int16 = (station?.available_bikes)!
        let fietsInt:Int = Int(fiets16)
        lblBeschikbareFietsen.text = String(fietsInt)
        
        let time64:Int64 = (station?.last_update)!
        let timeDouble:Double = Double(time64)/1000
        let date = NSDate(timeIntervalSince1970: timeDouble)
        //https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Europe/Brussels")
        let myString = formatter.string(from: date as Date)
        let yourDate = formatter.date(from: myString)
        let myStringafd = formatter.string(from: yourDate!)
        
        lblUpdate.text = "Laatst geupdate: " + myStringafd
    }
    
    func showAnnotation() ->Void {
        let coordinate = CLLocationCoordinate2D(latitude: (station?.lat)!, longitude: (station?.long)!)
        let title = station!.name!
        let annotation:Annotation = Annotation(coordinate: coordinate, title: title)
        
        mapView.addAnnotation(annotation)
        
        let center = CLLocationCoordinate2D(latitude: (station?.lat)!, longitude: (station?.long)! )
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
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
