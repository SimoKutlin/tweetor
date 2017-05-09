//
//  TweetAnnotation.swift
//  tweetor
//
//  Created by admin on 09.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import MapKit
import UIKit

class TweetAnnotation: NSObject, MKAnnotation  {

    internal var coordinate: CLLocationCoordinate2D
    
    var coordinates: CLLocationCoordinate2D {
        return self.coordinate
    }
    
    init(_ coordinates: CLLocationCoordinate2D) {
        self.coordinate = coordinates
    }

}
