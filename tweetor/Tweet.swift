//
//  Tweet.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import Foundation
import SwiftyJSON

final class Tweet: NSObject, ResponseCollectionConvertible, ResponseConvertible {
    
    var identifier: String = ""
    var text: String = ""
    var timestamp: String = ""
    
    var mediaURL: String = ""
    var mediaType: String = ""
    
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
        
        let dateString = responseData["created_at"].string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc LLL dd HH:mm:ss Z yyyy"
        let date = dateFormatter.date(from: dateString!)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        timestamp = dateFormatter.string(from: date!)
        
        text = responseData["text"].string ?? ""
        
        if responseData["extended_entities", "media", 0] != JSON.null {
            switch responseData["extended_entities", "media", 0, "type"].string! {
                case "photo":
                    mediaType = "photo"
                    mediaURL = responseData["extended_entities", "media", 0, "media_url_https"].string!
                case "video":
                    mediaType = "video"
                    mediaURL = responseData["extended_entities", "media", 0, "video_info", "variants", 0, "url"].string!
                default:
                    mediaType = "none"
            }
        }
        
        user = User(userData: responseData["user"])
        
        if responseData["geo", "coordinates"] != JSON.null {
            latitude = responseData["geo", "coordinates", 0].double!
            longitude = responseData["geo", "coordinates", 1].double!
        }
    }
    
}
