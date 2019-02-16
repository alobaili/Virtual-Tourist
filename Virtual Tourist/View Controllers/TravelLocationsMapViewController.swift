//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 16/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Retrieve the map center and zoom level
        let center = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "Latitude"), longitude: UserDefaults.standard.double(forKey: "Longitude"))
        let span = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.double(forKey: "DeltaLatitude"), longitudeDelta: UserDefaults.standard.double(forKey: "DeltaLongitude"))
        mapView.region = MKCoordinateRegion(center: center, span: span)
    }


}

extension TravelLocationsMapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "Latitude")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "Longitude")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "DeltaLatitude")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "DeltaLongitude")
    }
}

