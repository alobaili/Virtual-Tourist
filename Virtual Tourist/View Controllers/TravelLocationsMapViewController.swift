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

class TravelLocationsMapViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tapToDeleteView: UIView!
    
    var dataController: DataController!
    
    var editModeEnabled: Bool = false
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapToDeleteView.isHidden = true
        
        // Retrieve the map region.
        let center = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "Latitude"), longitude: UserDefaults.standard.double(forKey: "Longitude"))
        let span = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.double(forKey: "DeltaLatitude"), longitudeDelta: UserDefaults.standard.double(forKey: "DeltaLongitude"))
        mapView.region = MKCoordinateRegion(center: center, span: span)
        
        // Fetch pins from the data controller.
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDiscreptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDiscreptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        if let result = fetchedResultsController.fetchedObjects {
            populateAnnotations(from: result)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func populateAnnotations(from pins: [Pin]) {
        // Takes an array of type Pin and creates an annotations and appends them to the
        // annotations array.
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            self.mapView.addAnnotation(annotation)
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
        
        // only handle the very begining of the long press gesture
        if (sender.state == UIGestureRecognizer.State.began) {
            
            // initialize a new pin instance with the data controler's view context.
            let pin = Pin(context: dataController.viewContext)
            
            // get the long press location from the map view.
            let pressLocation = sender.location(in: mapView)
            
            // convert the location to coordinate
            let coordinate = mapView.convert(pressLocation, toCoordinateFrom: mapView)
            
            // assign the coordinate lon & lat to the pin instance.
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude
            
            // save the pin to the view context.
            try? dataController.viewContext.save()
            
            // create a new annotation from the pin and present it in the map view.
            let annotation = convertToAnnotation(pin: pin)
            mapView.addAnnotation(annotation)
            
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        //let tapToDeleteView: UIView = UIView(frame: CGRect()
        
        if sender.title == "Edit" {
            tapToDeleteView.isHidden = false
            sender.title = "Done"
            editModeEnabled = true
        } else if sender.title == "Done" {
            tapToDeleteView.isHidden = true
            sender.title = "Edit"
            editModeEnabled = false
        }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if editModeEnabled {
            var pinToDelete: Pin
            
            // loop through the pins array and look for the pin that is selected, if it is found, delete it from the view context.
            for pin in (fetchedResultsController?.fetchedObjects)! {
                if pin.latitude == view.annotation?.coordinate.latitude && pin.longitude == view.annotation?.coordinate.longitude {
                    pinToDelete = pin
                    dataController.viewContext.delete(pinToDelete)
                    do {
                        try dataController.viewContext.save()
                    } catch {
                        fatalError("couldn't save view context: \(error.localizedDescription)")
                    }
                }
            }
            
            mapView.removeAnnotation(view.annotation!)
        }
    }
}
