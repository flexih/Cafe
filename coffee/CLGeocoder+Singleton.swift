//
//  CLGeocoder+Singleton.swift
//  coffee
//
//  Created by flexih on 1/21/16.
//  Copyright © 2015 flexih. All rights reserved.
//

import Foundation
import CoreLocation

extension CLGeocoder {
    
    fileprivate struct AssociatedKeys {
        static var sharedKey = "cafe_sharedKey"
    }

    class var sharedGeocoder: CLGeocoder {
        get {
            if let geocoder = objc_getAssociatedObject(self, AssociatedKeys.sharedKey) as? CLGeocoder {
                return geocoder
            }

            let geocoder = CLGeocoder()
            objc_setAssociatedObject(self, AssociatedKeys.sharedKey, geocoder, .OBJC_ASSOCIATION_RETAIN)
            return geocoder
        }
    }
}
