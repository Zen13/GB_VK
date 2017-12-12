//
//  LocationManager.swift
//  GB_VK
//
//  Created by Zen on 16.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationMangerDelegate: class {
    func locationManger(_ locationManger: LocationManger, coordination: CLLocationCoordinate2D )
}

class LocationManger: NSObject {
    
    static let instance = LocationManger()
    let geoCoder = CLGeocoder()
    private override init(){}
    
    weak var delegete: LocationMangerDelegate?
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    func startUpdateLocation() {
        
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManger: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0].coordinate)
        delegete?.locationManger(self, coordination: locations[0].coordinate)
        guard let location = locations.last else { return }
        
        geoCoder.reverseGeocodeLocation(location) { mark, error in
            print(mark?.last?.addressDictionary)
        }
    }
    
}
