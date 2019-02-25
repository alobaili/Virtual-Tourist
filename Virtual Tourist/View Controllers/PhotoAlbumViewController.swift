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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var dataController: DataController!
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var imageURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        setupFetchedResultsController()
        prepareFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        print("lat: \(pin.latitude) lon: \(pin.longitude)")
        prepareMapView()
        FlickrAPI.shared.getNewPhotoCollection(pin: pin) { (imageURLStrings) in
            guard imageURLStrings != nil else {
                return
            }
            
            for imageURLString in imageURLStrings! {
                self.imageURLs.append(URL(string: imageURLString)!)
            }
        }
        downloadImages()
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        guard let fetchedResults = self.fetchedResultsController.fetchedObjects else {
            return
        }
        imageURLs.removeAll()
        for photo in fetchedResults {
            dataController.viewContext.delete(photo)
            try? dataController.viewContext.save()
        }
        FlickrAPI.shared.getNewPhotoCollection(pin: pin) { (imageURLStrings) in
            guard imageURLStrings != nil else {
                return
            }
            for imageURLString in imageURLStrings! {
                self.imageURLs.append(URL(string: imageURLString)!)
            }
        }
        downloadImages()
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
    
    func downloadImages() {
        if (fetchedResultsController.fetchedObjects?.isEmpty)! {
            // There are photos
            for url in imageURLs {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if error == nil {
                        if let data = data {
                            self.addPhotoToViewContext(data: data)
                        }
                    } else {
                        print(error!)
                    }
                }.resume()
            }
        }
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            fatalError("The fetch couldn't be performed: \(error.localizedDescription)")
        }
    }
    
    func addPhotoToViewContext(data: Data) {
        let photo = Photo(context: dataController.viewContext)
        
        photo.imageData = data
        photo.creationDate = Date()
        photo.pin = pin
        
        do {
            try dataController.viewContext.save()
        }
        catch {
            print(error)
        }
    }
    
    func deletePhoto(_ photo: Photo) {
        dataController.viewContext.delete(photo)
    }
    
    func prepareFlowLayout() {
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let dimention = (view.frame.size.width / 3)
        flowLayout.itemSize = CGSize(width: dimention, height: dimention)
    }
    
    func updateUI(cell: CollectionViewCell, status: Bool) {
        if status == false {
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            
        } else {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        self.updateUI(cell: cell, status: false)
        let dataArray = self.fetchedResultsController.fetchedObjects!
        cell.imageView.image = UIImage(data: dataArray[indexPath.row].imageData!)
        self.updateUI(cell: cell, status: true)
        newCollectionButton.isEnabled = true
        return cell
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete: Photo = fetchedResultsController.object(at: indexPath)
        let indexArray : [IndexPath] = [indexPath]
        self.collectionView.deleteItems(at: indexArray)
        deletePhoto(photoToDelete)
    }
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
}
