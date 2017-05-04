//
//  User.swift
//  tweetor
//
//  Created by admin on 04.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Foundation

final class User: NSObject {
    
    var name: String = ""
    var username: String = ""
    
    var profileURL: String = ""
    var imageURL: String = ""
    
    init(userData: Dictionary<String, Any>) {
        name = userData["name"] as? String ?? ""
        username = userData["screen_name"] as? String ?? ""
        profileURL = userData["url"] as? String ?? ""
        profileURL = profileURL.replacingOccurrences(of: "\\/", with: "/")
        
        imageURL = userData["profile_image_url_https"] as? String ?? ""
        imageURL = imageURL.replacingOccurrences(of: "\\/", with: "/")
    }
}
