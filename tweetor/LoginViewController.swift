//
//  LoginViewController.swift
//  tweetor
//
//  Created by admin on 03.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    
    @IBAction func loginClicked(_ sender: UIButton) {
        print("logged in, fo' real!")
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://twitter.com/signup")!, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "LoginSeqgue":
                _ = segue.destination as? SearchViewController
                
            default: break
            }
        }
    }
}
