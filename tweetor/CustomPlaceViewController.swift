//
//  PickPlaceViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import CoreData
import FontAwesome_swift
import MapKit
import UIKit

class CustomPlaceViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - UI elements
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var toggleFavsButton: UIButton!
    @IBOutlet weak var goSearchButton: UIButton!
    
    
    // needed to pass back search location to search controller
    weak var delegate: SearchLocationDelegate? = nil
    
    // location to search at
    private var customLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    
    // MARK: UI - preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        streetLabel.text = ""
        zipLabel.text = ""
        cityLabel.text = ""
        
        toggleFavsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        toggleFavsButton.setTitle(String.fontAwesomeIcon(name: .starO), for: .normal)
        toggleFavsButton.isHidden = true
        
        goSearchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        goSearchButton.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        goSearchButton.isHidden = true
        
        mapView.delegate = self
        
        let handler = #selector(CustomPlaceViewController.handleTap(gestureRecognizer:))
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: handler)
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        self.title = "Pick Location"
    }
    
    
    // MARK: - UI functionality
    
    @IBAction func setLocation(_ sender: UIButton) {
        // set search location in search controller
        delegate?.search(withLocation: self.customLocation, locationType: "custom")
        _  = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        // save picked location to core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        
        let location = NSManagedObject(entity: entity, insertInto: managedContext)
        
        location.setValue(nameLabel.text, forKeyPath: "name")
        location.setValue(streetLabel.text, forKeyPath: "street")
        location.setValue(zipLabel.text, forKeyPath: "zip")
        location.setValue(cityLabel.text, forKeyPath: "city")
        location.setValue(customLocation.latitude, forKeyPath: "latitude")
        location.setValue(customLocation.longitude, forKeyPath: "longitude")
        
        do {
            try managedContext.save()
            toggleFavsButton.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
            toggleFavsButton.titleLabel?.textColor = UIColor.orange
        } catch let error as NSError {
            let alert = UIAlertController(title: "Error", message: "Could not save. \(error)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        // fetch tap location and translate to map coordinates for reverse geolocating address
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let cllocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        self.customLocation = coordinate
        
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Failed reverse geolocation", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                // show up location data & buttons
                self.nameLabel.text = placemark.name
                self.streetLabel.text = placemark.thoroughfare
                self.zipLabel.text = placemark.postalCode
                self.cityLabel.text = placemark.locality
                
                self.toggleFavsButton.isHidden = false
                self.goSearchButton.isHidden = false
                self.toggleFavsButton.titleLabel?.textColor = UIColor.orange
                self.goSearchButton.titleLabel?.textColor = UIColor.orange
            } else {
                let alert = UIAlertController(title: "Error", message: "Problem with geodata", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }

    
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
