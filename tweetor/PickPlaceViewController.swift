//
//  PickPlaceViewController.swift
//  tweetor
//
//  Created by admin on 10.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import FontAwesome_swift
import MapKit
import UIKit

class PickPlaceViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var toggleFavsButton: UIButton!
    @IBOutlet weak var goSearchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        streetLabel.text = ""
        zipLabel.text = ""
        cityLabel.text = ""
        
        toggleFavsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        toggleFavsButton.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        
        goSearchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        goSearchButton.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)

        mapView.delegate = self
        
        let handler = #selector(PickPlaceViewController.handleTap(gestureRecognizer:))
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: handler)
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let cllocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let annotation = MKPointAnnotation()
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Failed reverse geolocation", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.nameLabel.text = placemark.name
                self.streetLabel.text = placemark.thoroughfare
                self.zipLabel.text = placemark.postalCode
                self.cityLabel.text = placemark.locality
            } else {
                let alert = UIAlertController(title: "Error", message: "Problem with geodata", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
