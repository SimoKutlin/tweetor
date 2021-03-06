//
//  TweetDetailViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - UI elements
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    var tweetData: Tweet? { didSet { updateUI() } }
    
    
    // MARK: UI - preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullnameLabel.text = ""
        usernameLabel.text = ""
        timestampLabel.text = ""
        tweetTextLabel.text = ""
        
        let handler = #selector(TweetDetailViewController.handleTap(gestureRecognizer:))
        let gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: handler)
        gestureRecognizer.delegate = self
        usernameLabel.addGestureRecognizer(gestureRecognizer)
        
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
                            mediaView.tag = 8008
                            self.view.addSubview(mediaView)
                        }
                        
                        if tweet.mediaType == "video" {
                            let mediaView = UIWebView()
                            mediaView.loadRequest(URLRequest(url: URL(string: tweet.mediaURL)!))
                            mediaView.frame = viewFrame
                            mediaView.contentMode = .scaleAspectFit
                            mediaView.tag = 8008
                            self.view.addSubview(mediaView)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - UI functionality
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        if let profileURL = tweetData?.user?.profileURL {
            UIApplication.shared.open(URL(string: profileURL)!, options: [:], completionHandler: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            self.view.viewWithTag(8008)?.isHidden = true
        } else {
            self.view.viewWithTag(8008)?.isHidden = false
        }
    }
    

    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
