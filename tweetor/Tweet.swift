//
//  Tweet.swift
//  tweetor
//
//  Created by admin on 04.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Foundation

final class Tweet: NSObject {
    
    var identifier: String = ""
    var text: String = ""
    var user: User? = nil
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Tweet] {
        print("locating \(responseData)")
        var tweets = Array<Tweet>()
        for tweetData in responseData {
            tweets += [Tweet(responseData: tweetData)]
        }
        return tweets
    }
    
    init(responseData: Dictionary<String, Any>) {
        identifier = responseData["id_str"] as? String ?? ""
        text = responseData["text"] as? String ?? ""
        
        if let userData = responseData["user"] as? Dictionary<String, Any> {
            user = User(userData: userData)
        }
        
        if let geoData = responseData["geo"] as? Dictionary<String, Any>,
            let coordinates = geoData["coordinates"] as? Dictionary<Int, Double> {
            latitude = Double(coordinates[0]!)
            longitude = Double(coordinates[1]!)
        }
        
    }
}
