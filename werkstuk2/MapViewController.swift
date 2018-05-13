//
//  MapViewController.swift
//  werkstuk2
//
//  Created by Pieter on 11/05/18.
//  Copyright © 2018 Pieter. All rights reserved.
//  https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapVIew: MKMapView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    var annotations:[Annotation] = []
    var selectedStation:Station?
  
    var DataManager = DataManagerSingleton.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = NSLocalizedString("Villo", comment: "")
        infoButton.title = NSLocalizedString("Info", comment: "")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        DataManager.managedContext = appDelegate.persistentContainer.viewContext
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        DataManager.webserviceData(mapview: mapVIew, showMap: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation { //credit voor deze lijn gaat naar https://stackoverflow.com/questions/37320485/swift-how-to-get-information-from-a-custom-annotation-on-clicked
            for stat in DataManager.stations {
                if stat.name == annotation.title {
                    selectedStation = stat
                }
            }
            self.performSegue(withIdentifier: "AnnotationSelected", sender: self)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnnotationSelected" {
            if let nextVC = segue.destination as? DetailViewController {
                nextVC.station = self.selectedStation
            }
        }
    }
   

}
