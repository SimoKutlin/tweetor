//
//  TwitterDeserializer.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
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
        let tweets = JSONdata["statuses"]
        
        let results: [Tweet] = Tweet.collection(tweets)
            
        response.objects = results
                
        return response
    }
    
}
