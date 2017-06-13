//
//  SearchViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import CoreLocation
import FontAwesome_swift
import UIKit

// used to set search location from other views
protocol SearchLocationDelegate: class {
    func search(withLocation location: CLLocationCoordinate2D, locationType type: String)
    func returnGEOParameters() -> (location: CLLocationCoordinate2D, radius: Double)
}

class SearchViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, SearchLocationDelegate {
    
    // MARK: - UI elements
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var savedPlacesButton: UIButton!
    @IBOutlet weak var customPlaceButton: UIButton!
    
    
    var tweets = [Tweet]()
    
    let locationManager = CLLocationManager()
    
    var searchLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    
    // MARK: - Protocol functions
    
    func search(withLocation location: CLLocationCoordinate2D, locationType type: String) {
        self.searchLocation = location
        
        switch type {
        case "saved":
            savedPlacesButton.titleLabel?.textColor = UIColor.orange
            customPlaceButton.titleLabel?.textColor = UIColor.lightGray
            userLocationButton.titleLabel?.textColor = UIColor.lightGray
        case "custom":
            savedPlacesButton.titleLabel?.textColor = UIColor.lightGray
            customPlaceButton.titleLabel?.textColor = UIColor.orange
            userLocationButton.titleLabel?.textColor = UIColor.lightGray
        default:
            savedPlacesButton.titleLabel?.textColor = UIColor.lightGray
            customPlaceButton.titleLabel?.textColor = UIColor.lightGray
            userLocationButton.titleLabel?.textColor = UIColor.orange
        }
    }
    
    func returnGEOParameters() -> (location: CLLocationCoordinate2D, radius: Double) {
        return (self.searchLocation, Double(distanceSlider.value))
    }
    
    
    // MARK: - UI Preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // additional button setup
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 25)] as [String: Any]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem?.title = String.fontAwesomeIcon(name: .cog)
        
        userLocationButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        userLocationButton.titleLabel?.textColor = UIColor.orange
        userLocationButton.setTitle(String.fontAwesomeIcon(name: .locationArrow), for: .normal)
        
        savedPlacesButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        savedPlacesButton.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        
        customPlaceButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        customPlaceButton.setTitle(String.fontAwesomeIcon(name: .mapMarker), for: .normal)
        
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Initialize distance label
        sliderValueChanged(distanceSlider)
    }
    
    
    // MARK: UI functionality
    
    @IBAction func fetchUserLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceLabel?.text = String(format: "%.2f", distanceSlider.value) + " km"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // empty current tweets
        self.tweets.removeAll()
        
        if let searchTerm: String = searchBar.text {
            
            var parameters = [String: String]()
            
            parameters["q"] = "#" + searchTerm
            parameters["geocode"] = String(searchLocation.latitude) + "," + String(searchLocation.longitude) + "," + String(format: "%.2f", distanceSlider.value) + "km"
            
            TwitterManager().requestTweets(withParams: parameters) { (response, error) in
                if let tweets = response?.objects {
                    if tweets.count == 0 {
                        self.showAlert(title: "Info", message: "No tweets found")
                    } else {
                        for tweet in tweets {
                            self.tweets += [tweet]
                        }
                        
                        self.performSegue(withIdentifier: "TweetResultSegue", sender: self)
                    }
                } else {
                    self.showAlert(title: "Ooops", message: "Something went wrong trying to search tweets")
                }
            }
            
        }
    }
    
    
    // MARK: Location functionality
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.search(withLocation: location.coordinate, locationType: "self")
            // no need for further updating here, also saves battery life #lifehack
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showAlert(title: "Ooops", message: "Could not fetch user location. \(error)")
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SettingsSegue":
                _ = segue.destination as? SettingsViewController
                
            case "CustomPlaceSegue":
                let seguedMVC = segue.destination as? CustomPlaceViewController
                seguedMVC?.delegate = self
                self.userLocationButton.isHighlighted = false
                
            case "SavedPlacesSegue":
                let seguedMVC = segue.destination as? SavedPlacesViewController
                seguedMVC?.delegate = self
                self.userLocationButton.isHighlighted = false
                
            case "TweetResultSegue":
                let seguedMVC = segue.destination as? TweetTableViewController
                seguedMVC?.delegate = self
                seguedMVC?.tweets = self.tweets
                	
            default: break
            }
        }
    }
    
    // MARK: - Auxiliary functions
    
    private func showAlert(title ttl: String, message msg: String) {
        let alert = UIAlertController(title: ttl, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
