//
//  TweetMapViewController.swift
//  tweetor
//
//  Created by admin on 09.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import MapKit
import UIKit

class TweetMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var resultMap: MKMapView!
    
    var tweets: [Tweet] = []
    
    var geoParams: (CLLocationCoordinate2D, Double)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton : UIBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(self.backSegue))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        resultMap.delegate = self
        
        updateGUI()
    }
    
    private func updateGUI() {
        var pins: [TweetAnnotation] = []
        
        for tweet in self.tweets {
            if let userData = tweet.user {
                
                let coordinates = CLLocationCoordinate2DMake(tweet.latitude, tweet.longitude)
                let annotation = TweetAnnotation(coordinates, tweet)
                
                annotation.title = "@" + userData.username
                annotation.subtitle = tweet.text
                
                pins += [annotation]
            }
            
        }
        self.resultMap.addAnnotations(pins)
        
        self.resultMap.showsUserLocation = true
        
        // Zoom to search location
        if let coordinate = self.geoParams?.0, let radius = self.geoParams?.1 {
            let zoomRadius = MKCoordinateSpanMake(radius / 400, radius / 400)
            let zoomRegion = MKCoordinateRegion(center: coordinate, span: zoomRadius)
            self.resultMap.setRegion(zoomRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let detailButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = detailButton
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12.0)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        annotationView?.leftCalloutAccessoryView = subtitleView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "TweetDetailSegue", sender: view.annotation)
    }
    
    // segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "TweetDetailSegue":
                if let seguedToMVC = segue.destination as? TweetDetailViewController,
                    let annotation = sender as? TweetAnnotation {
                    seguedToMVC.tweetData = annotation.tweet
                }
                
            default: break
            }
        }
    }
    
    @objc private func backSegue() {
        self.navigationController!.performSegue(withIdentifier: "BackToResultListSegue", sender: self)
    }
    
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
