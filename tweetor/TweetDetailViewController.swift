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
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let handler = #selector(TweetDetailViewController.handleTap(gestureRecognizer:))
        let gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: handler)
        gestureRecognizer.delegate = self
        userImage.addGestureRecognizer(gestureRecognizer)
        
        self.title = "Tweet"
    }

    
    private func updateUI() {
        if let tweet = tweetData, let user = tweet.user {
            
            DispatchQueue.global().async {
                let thumbnailData = try? Data(contentsOf: URL(string: user.imageURL)!)
                var imageData: Data? = Data()
                
                
                if tweet.mediaType == "photo" {
                    imageData = try? Data(contentsOf: URL(string: tweet.mediaURL)!)
                }
                
                DispatchQueue.main.async {
                    self.userImage?.image = UIImage(data: thumbnailData!)
                    print("setting!")
                    self.fullnameLabel?.text = user.name
                    self.usernameLabel?.text = "@" + user.username
                    self.timestampLabel?.text = tweet.timestamp
                    self.tweetTextLabel?.text = tweet.text
                    
                    if tweet.mediaType != "none" {
                        let frameHeight = self.view.frame.size.height
                        let frameWidth = self.view.frame.size.width
                        let horizontalMargins = frameWidth / 20
                        let viewFrame = CGRect(x: horizontalMargins, y: frameHeight / 2.5, width: frameWidth - 2 * horizontalMargins, height: frameHeight / 2)
                        
                        if tweet.mediaType == "photo" && imageData != nil {
                            let mediaView = UIImageView()
                            mediaView.image = UIImage(data: imageData!)
                            mediaView.frame = viewFrame
                            mediaView.contentMode = .scaleAspectFit
                            self.view.addSubview(mediaView)
                        }
                        
                        if tweet.mediaType == "video" {
                            let mediaView = UIWebView()
                            mediaView.loadRequest(URLRequest(url: URL(string: tweet.mediaURL)!))
                            mediaView.frame = viewFrame
                            mediaView.contentMode = .scaleAspectFit
                            self.view.addSubview(mediaView)
                        }
                        
                    
                    }
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
