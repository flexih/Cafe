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
            if let value = value(forKey: "edgeInsets") as? NSValue {
                return value.uiEdgeInsetsValue
            }

            return UIEdgeInsets.zero
        }

        set {
            setValue(NSValue(uiEdgeInsets: newValue), forKey: "edgeInsets")
        }
    }
}
