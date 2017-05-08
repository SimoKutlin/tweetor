//
//  TweetTableViewController.swift
//  tweetor
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {
    
    var tweets: [Tweet] = [] {
        didSet {
            tableView.reloadData()
            print("got \(tweets)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: "TweetResultCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            print("pushing \(tweets[indexPath.row])")
            cell.tweetData = tweets[indexPath.row]
        }

        return cell
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
