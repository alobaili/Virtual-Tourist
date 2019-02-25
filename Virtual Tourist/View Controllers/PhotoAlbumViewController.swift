//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 24/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!    
    
    var dataController: DataController!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareMapView()
    }
    
    func prepareMapView() {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        
        mapView.addAnnotation(annotation)
        
        mapView.centerCoordinate = annotation.coordinate
        
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        mapView.isUserInteractionEnabled = false
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    
}
