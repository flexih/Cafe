//
//  CLLocationManager+Singleton.swift
//  coffee
//
//  Created by flexih on 12/31/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    
    fileprivate struct AssociatedKeys {
        static var sharedKey = "cafe_sharedKey"
    }

    class var sharedLocationManager: CLLocationManager {
        get {
            if let manager = objc_getAssociatedObject(self, AssociatedKeys.sharedKey) as? CLLocationManager {
                return manager
            }

            let manager = CLLocationManager()
            objc_setAssociatedObject(self, AssociatedKeys.sharedKey, manager, .OBJC_ASSOCIATION_RETAIN)
            return manager
        }
    }
}
