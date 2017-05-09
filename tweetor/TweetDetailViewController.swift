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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateGUI() {
        if let data = tweetData {
            tweetTextLabel?.text = data.text
        }
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
