//
//  AppDelegate+Splash.swift
//  coffee
//
//  Created by flexih on 1/25/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Alamofire
import Async

extension AppDelegate {

    private struct Keys {
        static var showADKey = "ad"
        static var shopURIKey = "shopURI"
    }

    var screenURLString: String {
        return "https://raw.githubusercontent.com/flexih/flexih.github.io/master/coffee/screen.json"
    }

    var showAD: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Keys.showADKey)
        }

        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.showADKey)
        }
    }

    var shopURI: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Keys.shopURIKey)
        }

        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Keys.shopURIKey)
        }
    }

    func fetchScreenData() {
        Alamofire.request(.GET, screenURLString, headers: ["Accept" : "application/json"]).responseJSON { [weak self] response in

            if let JSON = response.result.value as? [String : AnyObject], strongSelf = self {
                strongSelf.showAD = (JSON["ad"] as? Bool) ?? false
                strongSelf.shopURI = JSON["shop"] as? String
            }
        }
    }

}
