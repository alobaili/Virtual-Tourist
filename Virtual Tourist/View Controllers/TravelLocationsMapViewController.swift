//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 16/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    
    var annotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Retrieve the map region.
        let center = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "Latitude"), longitude: UserDefaults.standard.double(forKey: "Longitude"))
        let span = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.double(forKey: "DeltaLatitude"), longitudeDelta: UserDefaults.standard.double(forKey: "DeltaLongitude"))
        mapView.region = MKCoordinateRegion(center: center, span: span)
        
        // Fetch pins from the data controller.
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            populateAnnotationsArray(from: result)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func populateAnnotationsArray(from pins: [Pin]) {
        // Takes an array of type Pin and creates an annotations and appends them to the
        // annotations array.
        annotations.removeAll()
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            annotations.append(annotation)
        }
    }
    
    func convertToAnnotation(pin: Pin) -> MKPointAnnotation {
        // Takes a single Pin object and returnes an MKPointAnnotation using the latitude and
        // longitude of that pin.
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        return annotation
    }
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let pin = Pin(context: dataController.viewContext)
        let pressLocation = sender.location(in: mapView)
        let coordinate = mapView.convert(pressLocation, toCoordinateFrom: mapView)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        try? dataController.viewContext.save()
        let annotation = convertToAnnotation(pin: pin)
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
}

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    // Every Time the map visibal region changes, persist it.
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "Latitude")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "Longitude")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "DeltaLatitude")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "DeltaLongitude")
    }
    
    
}
