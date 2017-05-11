//
//  SearchViewController.swift
//  tweetor
//
//  Created by admin on 03.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import CoreLocation
import FontAwesome_swift
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // UI Elements
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var userLocationButton: UIButton!
    
    var tweets = [Tweet]()
    
    let locationManager = CLLocationManager()
    
    var searchLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) { didSet { print("set to \(searchLocation)") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Initialize distance label
        sliderValueChanged(distanceSlider)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceLabel?.text = String(format: "%.2f", distanceSlider.value) + " km"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // empty current tweets
        self.tweets.removeAll()
        
        if let searchTerm: String = searchBar.text {
            print("searching for \(searchTerm)")
            
            var parameters = [String: String]()
            parameters["q"] = searchTerm
            parameters["geocode"] = "48.1374300,11.5754900,1km"
            
            TwitterManager().requestTweets(withParams: parameters) { (response, error) in
                if let tweets = response?.objects {
                    if tweets.count == 0 {
                        let alert = UIAlertController(title: "Info", message: "No tweets found", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for tweet in tweets {
                            self.tweets += [tweet]
                        }
                        print("got \(self.tweets.count) tweets")
                        
                        let searchResultController: TweetTableViewController = TweetTableViewController()
                        //let searchResultController: TweetMapViewController = TweetMapViewController()
                        searchResultController.tweets = self.tweets
                        self.navigationController?.pushViewController(searchResultController, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Ooops", message: "Something went wrong when trying to search tweets", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    // location stuff
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.searchLocation = location.coordinate
            self.userLocationButton.isHighlighted = true
            // no need for further updating here, also saves battery life #lifehack
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Ooops", message: "Could not fetch user location. \(error)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // segueing stuff goes here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SettingsSegue":
                _ = segue.destination as? SettingsViewController
                
            case "CustomPlaceSegue":
                _ = segue.destination as? CustomPlaceViewController
                
            case "SavedPlacesSegue":
                _ = segue.destination as? SavedPlacesViewController
    
            default: break
            }
        }
    }
    
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
