//
//  CafeAnnotation.swift
//  coffee
//
//  Created by flexih on 1/9/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import MapKit

class CafeAnnotation: NSObject, MKAnnotation {
    
    let cafe: Cafe
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: cafe.lat, longitude: cafe.lng)
    }
    
    var title: String? {
        return cafe.name
    }
    
    var subtitle: String? {
        return cafe.addr
    }
    
    init(cafe: Cafe) {
        self.cafe = cafe
    }
}
