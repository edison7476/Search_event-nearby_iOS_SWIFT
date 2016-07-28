//
//  Capital.swift
//  project19_mapKit
//
//  Created by Jia Wang on 7/24/16.
//  Copyright © 2016 Jia Wang. All rights reserved.
//
import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var info: [String]
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, info: [String]) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.info = info
    }
}

