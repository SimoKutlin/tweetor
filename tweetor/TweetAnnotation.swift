//
//  TweetAnnotation.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import MapKit
import UIKit

class TweetAnnotation: NSObject, MKAnnotation  {
    
    var title: String?
    var subtitle: String?
    
    var tweet: Tweet
    
    internal var coordinate: CLLocationCoordinate2D
    
    var coordinates: CLLocationCoordinate2D {
        return self.coordinate
    }
    
    init(_ coordinates: CLLocationCoordinate2D, _ tweetData: Tweet) {
        self.coordinate = coordinates
        self.tweet = tweetData
    }

}
