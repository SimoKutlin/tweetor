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
    
    
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    private func updateUI() {
        print("got \(tweetData)")
        fullnameLabel.text = tweetData?.user?.name
        usernameLabel.text = tweetData?.user?.username
        tweetLabel.text = tweetData?.text
        userThumbnail.image = UIImage(named: (tweetData?.user?.imageURL)!)
    }

}
