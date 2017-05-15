//
//  TweetDetailViewController.swift
//  tweetor
//
//  Created by admin on 08.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    // UI Elements
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    private func updateUI() {
        if let data = tweetData, let user = data.user {
            print("showing \(tweetData!)")
            fullnameLabel?.text = user.name
            usernameLabel?.text = "@" + user.username
            
            tweetTextLabel?.text = data.text
            userImage?.image = UIImage(named: user.imageURL)
            
        }
    }
    

    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
