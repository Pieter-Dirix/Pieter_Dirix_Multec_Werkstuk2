//
//  DataManagerSingleton.swift
//  werkstuk2
//
//  Created by Pieter on 13/05/18.
//  Copyright © 2018 Pieter. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class DataManagerSingleton {
    private init() {}
    
    static let shared = DataManagerSingleton()
    
    let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
    var stations:[Station] = []
    var annotations:[Annotation] = []
    var managedContext:NSManagedObjectContext? = nil
    let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
    var urlRequest:URLRequest?
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var mapView:MKMapView?
    var inMapView:Bool = true
    var lastUpdate:Double = 0.0
    
    
    //Empty Core Data
    func clearSavedStations() ->Void {
        let request = NSBatchDeleteRequest(fetchRequest: stationFetch)
        stations = []
        do {
            try managedContext?.execute(request)
            print("succeded")
        } catch {
            fatalError("Failed to delete Staions \(error)")
        }
        
    }
    
    //Fill Core Data
    func webserviceData(mapview: MKMapView, showMap: Bool)-> Void {
        inMapView = showMap
        mapView = mapview
        clearSavedStations()
        urlRequest = URLRequest(url: url!)
        
        let task = session.dataTask(with: urlRequest!) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not recieve data")
                return
            }
            
            guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                print("failed JSONSerialization")
                return
            }
            
            self.handleData(data: villoData!)
            
        }
        
        task.resume()
    }
    
    func handleData(data: [AnyObject]) {
        for station in data {
            let tempStation = NSEntityDescription.insertNewObject(forEntityName: "Station", into: self.managedContext!) as! Station
            
            tempStation.number = station["number"] as! Int16
            tempStation.name = station["name"] as? String
            tempStation.address = station["address"] as? String
            for (type, degrees) in station["position"] as! [String: Any] {
                if type == "lat" {
                    tempStation.lat = degrees as! Double
                }
                
                if type == "lng" {
                    tempStation.long = degrees as! Double
                }
            }
            tempStation.banking = station["banking"] as! Bool
            tempStation.bonus = station["bonus"] as! Bool
            tempStation.status = station["status"] as? String
            tempStation.contract_name = station["contract_name"] as? String
            tempStation.bike_stands = station["bike_stands"] as! Int16
            tempStation.available_bike_stands = station["available_bike_stands"] as! Int16
            tempStation.available_bikes = station["available_bikes"] as! Int16
            tempStation.last_update = station["last_update"] as! Int64
            
        }
        
        do{
            try self.managedContext!.save()
            lastUpdate = NSDate().timeIntervalSince1970
        } catch {
            fatalError("Failed To Save Context \(error)")
        }
        
        getDataFromCore()
    }
    
    func getDataFromCore() -> Void {
        let returnedStations:[Station]
        
        do {
            returnedStations = try managedContext!.fetch(stationFetch) as! [Station]
            stations = []
            for stat in returnedStations {
                stations.append(stat)
            }
            
        } catch {
            fatalError("Fetch Failed \(error)")
        }
        if inMapView {
            DispatchQueue.main.async {
                self.showStations(stations: self.stations, mapVIew: self.mapView!)
            }
        }
        
        
    }
    
    func showStations(stations: [Station], mapVIew: MKMapView) -> Void {
        let allAnnotations = mapVIew.annotations
        mapVIew.removeAnnotations(allAnnotations)
        print("here")
        for station in stations {
            let coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.long)
            let title = station.name!
            let annotation:Annotation = Annotation(coordinate: coordinate, title: title)
            annotations.append(annotation)
        }
        
        mapVIew.addAnnotations(annotations)
        mapVIew.showAnnotations(annotations, animated: true)
        
        let center = CLLocationCoordinate2D(latitude: 50.849432, longitude: 4.354485)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125))
        
        mapVIew.setRegion(region, animated: true)
        
    }
    
}
