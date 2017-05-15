//
//  TweetTableViewCell.swift
//  tweetor
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // UI Elements
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        if let data = tweetData, let user = data.user {
            fullnameLabel?.text = user.name
            usernameLabel?.text = "@" + user.username
            
            tweetLabel?.text = data.text
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: user.imageURL)!)
                
                DispatchQueue.main.async {
                    self.imageView?.image = UIImage(data: data!)
                }
            }
        }
    }

}
