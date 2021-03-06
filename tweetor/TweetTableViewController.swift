//
//  TweetTableViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {
    
    var tweets: [Tweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // needed to pass search location to further view controller
    weak var delegate: SearchLocationDelegate? = nil
    
    
    // MARK: - UI preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 25)] as [String: Any]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem?.title = String.fontAwesomeIcon(name: .globe)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetResultCell", for: indexPath)

        if let cell = cell as? TweetTableViewCell {
            cell.tweetData = tweets[indexPath.row]
        }

        return cell
    }
 
    
    // MARK: - Navigation
    
    @IBAction func unwindToResultList(segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "TweetMapSegue":
                if let seguedToMVC = segue.destination as? TweetMapViewController {
                    seguedToMVC.tweets = self.tweets
                    seguedToMVC.geoParams = self.delegate?.returnGEOParameters()
                }
                
            case "TweetDetailSegue":
                if let cell = sender as? TweetTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToMVC = segue.destination as? TweetDetailViewController {
                    seguedToMVC.tweetData = tweets[indexPath.row]
                }
                
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
