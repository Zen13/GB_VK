//
//  AddLocationVC.swift
//  GB_VK
//
//  Created by Zen on 16.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var lat = 0.0
    var long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManger.instance.delegete = self
        LocationManger.instance.startUpdateLocation()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddLocationVC: LocationMangerDelegate {
    func locationManger(_ locationManger: LocationManger, coordination: CLLocationCoordinate2D) {
        let currentRadius: CLLocationDistance = 500
        let currentRegion = MKCoordinateRegionMakeWithDistance((coordination), currentRadius * 2.0, currentRadius * 2.0)
        mapView.setRegion(currentRegion, animated: true)
        mapView.showsUserLocation = true
        
        self.lat = currentRegion.center.latitude
        self.long = currentRegion.center.longitude
    }
}

