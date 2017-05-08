//
//  SearchViewController.swift
//  tweetor
//
//  Created by admin on 03.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        sliderValueChanged(distanceSlider)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceLabel?.text = String(format: "%.2f", distanceSlider.value) + " km"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
                        var index: Int = 0
                        for tweet in tweets {
                            self.tweets.insert(tweet, at: index)
                            index += 1
                        }
                        print("got \(self.tweets.count) tweets")
                        
                        let searchResultController: TweetTableViewController = TweetTableViewController()
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
    
    
    // Segueing stuff goes here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SettingsSegue":
                _ = segue.destination as? SettingsViewController
                
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
