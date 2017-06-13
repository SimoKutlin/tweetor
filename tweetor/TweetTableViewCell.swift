//
//  TweetTableViewCell.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - UI elements
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    
    // MARK: UI preparation
    
    private func updateUI() {
        if let data = tweetData, let user = data.user {
            fullnameLabel.text = user.name
            usernameLabel.text = "@" + user.username
            
            timestampLabel.text = data.timestamp
            tweetLabel.text = data.text
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: user.imageURL)!)
                
                DispatchQueue.main.async {
                    self.userThumbnail.image = UIImage(data: data!)
                }
            }
        }
    }

}
