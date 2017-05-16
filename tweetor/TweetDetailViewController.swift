//
//  TweetDetailViewController.swift
//  tweetor
//
//  Created by admin on 08.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // UI Elements
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let handler = #selector(TweetDetailViewController.handleTap(gestureRecognizer:))
        let gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: handler)
        gestureRecognizer.delegate = self
        userImage.addGestureRecognizer(gestureRecognizer)
    }

    
    private func updateUI() {
        if let tweet = tweetData, let user = tweet.user {
            
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: user.imageURL)!)
                
                DispatchQueue.main.async {
                    self.userImage?.image = UIImage(data: data!)
                    print("setting!")
                    self.fullnameLabel?.text = user.name
                    self.usernameLabel?.text = "@" + user.username
                    self.tweetTextLabel?.text = tweet.text
                }
            }
        }
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if let data = tweetData, let user = data.user {
            UIApplication.shared.open(URL(string: user.profileURL)!, options: [:], completionHandler: nil)
        }
    }
    

    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
