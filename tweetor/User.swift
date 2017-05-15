//
//  User.swift
//  tweetor
//
//  Created by admin on 04.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class User: NSObject {
    
    var name: String = ""
    var username: String = ""
    
    //TODO suspended for now, maybe find a workaround
    var profileURL: String = ""
    var imageURL: String = ""
    
    init(userData: JSON) {
        name = userData["name"].string!
        username = userData["screen_name"].string!
        
        if userData["url"] != JSON.null {
            profileURL = userData["url"].string!
            profileURL = profileURL.replacingOccurrences(of: "\\/", with: "/")
        }        
        
        imageURL = userData["profile_image_url_https"].string!
        imageURL = imageURL.replacingOccurrences(of: "\\/", with: "/")
    }
}
