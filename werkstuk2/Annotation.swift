//
//  Annotation.swift
//  werkstuk2
//
//  Created by Pieter on 13/05/18.
//  Copyright © 2018 Pieter. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    override init() {
        coordinate = CLLocationCoordinate2D()
        title = ""
        super.init()
    }
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = ""
        super.init()
    }
    
    init(coordinate:CLLocationCoordinate2D, title:String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}
