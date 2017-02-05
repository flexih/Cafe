//
//  ViewController+Location.swift
//  coffee
//
//  Created by flexih on 1/21/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import CoreLocation

extension ViewController {
    
    func locateUser() {

        guard let location = mapView.userLocation.location else {
            return
        }

        let AppleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages")

        UserDefaults.standard.set(["zh_Hans"], forKey: "AppleLanguages")

        CLGeocoder.sharedGeocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemarks = placemarks, !placemarks.isEmpty {
                let placemark = placemarks.first!

                if let cityName = placemark.locality, let strongSelf = self {
                    strongSelf.locateCityName(cityName)
                    strongSelf.userCityName = cityName
                }
            }
            
            UserDefaults.standard.set(AppleLanguages, forKey: "AppleLanguages")
        }
    }

    func locateCityName(_ cityName: String) {
        if let name = cityList.takenCity(cityName) {
            if name != cityList.selectedCity {
                cityList.selectedCity = name
                loadCafesData()
            }
        }
    }

    func requestWhenInUseAuthorization() {
        if CLLocationManager.authorizationStatus() == .denied {
            // let alertController = UIAlertController(title: "", message: "未开授权", preferredStyle: .Alert)
            // alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            // alertController.addAction(UIAlertAction(title: "确定", style: .Default) { action in
            //     UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            // })
            // presentViewController(alertController, animated: true, completion: nil)
        } else {
            CLLocationManager.sharedLocationManager.requestWhenInUseAuthorization()
        }
    }

}
