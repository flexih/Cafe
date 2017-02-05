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

    fileprivate struct Keys {
        static var showADKey = "ad"
        static var shopURIKey = "shopURI"
    }

    var screenURLString: String {
        return "https://raw.githubusercontent.com/flexih/flexih.github.io/master/coffee/screen.json"
    }

    var showAD: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.showADKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Keys.showADKey)
        }
    }

    var shopURI: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.shopURIKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Keys.shopURIKey)
        }
    }

    func fetchScreenData() {
        SessionManager.default.request(screenURLString, method: .get, headers: ["Accept" : "text/plain"]).responseJSON { [weak self] response in

            if let JSON = response.result.value as? [String : AnyObject], let strongSelf = self {
                strongSelf.showAD = (JSON["ad"] as? Bool) ?? false
                strongSelf.shopURI = JSON["shop"] as? String
            }
        }
    }

}
