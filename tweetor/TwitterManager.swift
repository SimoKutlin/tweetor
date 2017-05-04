//
//  NetworkManager.swift
//  tweetor
//
//  Created by admin on 04.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import TwitterAPI

let oauthClient: OAuthClient = OAuthClient(
    consumerKey: "nOphb044a8KhCVPom6LUxXqol",
    consumerSecret: "9KtFaEz1owRok0OYFVIqaYqulAg5hXix3lnNcsOBsNrfwGr8pb",
    accessToken: "860199252080906240-0a3gGXBx4Os7qSgBVzT6Z691pWXgtrq",
    accessTokenSecret: "DJwmPdB6Rq6VAd6Y8O0gUUODaogHbaBXzAlefR8lkUPhm"
)

let baseURL: String = "https://api.twitter.com/1.1/search/tweets.json"

public protocol ResponseConvertible {
    init(responseData: JSON)
}

public protocol ResponseCollectionConvertible {
    static func collection(_ responseData: JSON) -> [Self]
}

class TwitterManager {
    
    typealias TweetRequestCompletion = (_ response: TwitterDeserializer?, _ error: String?) -> Void
    
    func requestTweets(withParams params: [String : String], completion: @escaping TweetRequestCompletion) {
        Alamofire
            .request(oauthClient.makeRequest(.GET, url: baseURL, parameters: params))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { responseData in
                let response = TwitterDeserializer().deserialize(responseData.result.value)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(response, response.error)
                })
        }
    }
}
