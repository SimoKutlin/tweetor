//
//  TwitterDeserializer.swift
//  tweetor
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Foundation
import SwiftyJSON

open class TwitterDeserializer {
    
    var error: String = ""
    var objects: [Tweet] = []
    
    open func deserialize(_ responseData: Any?) -> TwitterDeserializer {
        let response = TwitterDeserializer()
        guard let data = responseData else {
            response.error = "No Data returned - Response data is nil."
            
            return response
        }
        
        let JSONdata = JSON(data)
        if let tweets = JSONdata["statuses"] as? JSON {
            let results: [Tweet] = Tweet.collection(tweets)
            
            response.objects = results
        }
        
        return response
    }
}
