//
//  MKMapView+EdgeInsets.swift
//  coffee
//
//  Created by flexih on 1/8/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import MapKit

extension MKMapView {

    var cafe_edgeInsets: UIEdgeInsets {
        get {
            if let value = valueForKey("edgeInsets") as? NSValue {
                return value.UIEdgeInsetsValue()
            }

            return UIEdgeInsetsZero
        }

        set {
            setValue(NSValue(UIEdgeInsets: newValue), forKey: "edgeInsets")
        }
    }
}
