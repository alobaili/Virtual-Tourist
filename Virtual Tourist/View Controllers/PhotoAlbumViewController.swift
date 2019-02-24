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
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewCell: UICollectionViewCell!
    
    
    var dataController: DataController!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    
}
