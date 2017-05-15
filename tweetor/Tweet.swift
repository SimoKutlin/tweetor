//
//  Tweet.swift
//  tweetor
//
//  Created by admin on 04.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Tweet: NSObject, ResponseCollectionConvertible, ResponseConvertible {
    
    var identifier: String = ""
    var text: String = ""
    var user: User? = nil
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    static func collection(_ responseData: JSON) -> [Tweet] {
        var tweets = Array<Tweet>()
        for (_,tweetData):(String,JSON) in responseData {
            tweets += [Tweet(responseData: tweetData)]
        }
        return tweets
    }
    
    init(responseData: JSON) {
        identifier = responseData["id_str"].string ?? ""
        text = responseData["text"].string ?? ""
        
        user = User(userData: responseData["user"])
        
        if responseData["geo", "coordinates"] != JSON.null {
            latitude = responseData["geo", "coordinates", 0].double!
            longitude = responseData["geo", "coordinates", 1].double!
        }
    }
}
