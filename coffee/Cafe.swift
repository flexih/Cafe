//
//  Cafe.swift
//  coffee
//
//  Created by flexih on 1/8/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import Foundation
import CoreLocation

struct Cafe {
    let name: String
    let addr: String
    let posterURL: NSURL
    let oneword: String?
    let phones: [String]?
    let openingTime: String?
    let remarks: String?
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
    
    init(dict: [String: AnyObject]) {
        name = dict["name"] as? String ?? ""
        addr = dict["addr"] as? String ?? ""
        posterURL = (dict["poster"] as? String).map{NSURL(string: $0)!} ?? NSURL()
        oneword = dict["oneword"] as? String
        phones = dict["phones"] as? [String]
        openingTime = dict["opening"] as? String
        remarks = dict["remarks"] as? String
        lat = (dict["lat"] as? String).map{CLLocationDegrees($0)!} ?? 0
        lng = (dict["lng"] as? String).map{CLLocationDegrees($0)!} ?? 0
    }
}
