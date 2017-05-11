//
//  TweetDetailViewController.swift
//  tweetor
//
//  Created by admin on 08.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweetData: Tweet? { didSet { updateGUI() } }

    @IBOutlet weak var tweetTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    private func updateGUI() {
        if let data = tweetData {
            tweetTextLabel?.text = data.text
        }
    }
    

    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
