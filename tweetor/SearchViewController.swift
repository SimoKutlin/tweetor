//
//  SearchViewController.swift
//  tweetor
//
//  Created by admin on 03.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var parameters = [String: String]()
        parameters["q"] = "#muc"
        parameters["geocode"] = "48.1374300,11.5754900,1km"
        
        TwitterManager().requestTweets(withParams: parameters) { (response, error) in
            if let tweets = response?.objects {
                var index: Int = 0
                for tweet in tweets {
                    self.tweets.insert(tweet, at: index)
                    index += 1
                }
            }
        }
        
    }
    @IBAction func searchTriggered(_ sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SettingsSegue":
                _ = segue.destination as? SettingsViewController
                
            default: break
            }
        }
    }

}
