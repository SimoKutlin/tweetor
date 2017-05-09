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
    
    var tweets: [Tweet] = [] { didSet { updateGUI() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultMap?.delegate = self
    }
    
    private func updateGUI() {
        var pins: [MKPointAnnotation] = []
        
        for tweet in self.tweets {
            if let tweetData: Tweet = tweet, let userData: User = tweetData.user {
                let annotation = MKPointAnnotation()
                let coordinates = CLLocationCoordinate2DMake(tweetData.latitude, tweetData.longitude)
                annotation.coordinate = coordinates
                annotation.title = userData.username
                annotation.subtitle = tweetData.text
                
                pins += [annotation]
            }
            
        }
        self.resultMap.addAnnotations(pins)
        
        self.resultMap.showsUserLocation = true
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
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12.0)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        annotationView!.detailCalloutAccessoryView = subtitleView
        
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
