//
//  User.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import Foundation
import SwiftyJSON

final class User: NSObject {
    
    var name: String = ""
    var username: String = ""
    
    var profileURL: String = ""
    var imageURL: String = ""
    
    init(userData: JSON) {
        name = userData["name"].string!
        username = userData["screen_name"].string!
        
        if userData["url"] != JSON.null {
            profileURL = userData["url"].string!
            profileURL = profileURL.replacingOccurrences(of: "\\/", with: "/")
        } else {
            profileURL = "http://www.twitter.com/" + username
        }
        
        imageURL = userData["profile_image_url_https"].string!
        imageURL = imageURL.replacingOccurrences(of: "\\/", with: "/")
    }
    
}
