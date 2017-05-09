//
//  TweetTableViewCell.swift
//  tweetor
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    private func updateUI() {
        if let data = tweetData, let user = data.user {
            fullnameLabel?.text = user.name
            usernameLabel?.text = user.username
            tweetLabel?.text = data.text
            userThumbnail?.image = UIImage(named: user.imageURL)
        }
    }

}
