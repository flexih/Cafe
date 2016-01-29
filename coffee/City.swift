//
//  City.swift
//  coffee
//
//  Created by flexih on 1/9/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import Foundation

struct City {
    let name: String
    let cafes: [Cafe]
    
    init(dict: [String: AnyObject]) {
        name = dict["city"] as? String ?? ""
        
        var cafesArray = [Cafe]()
        
        if let cafeDicts = dict["cafes"] as? [[String: AnyObject]] {
            for cafeDict in cafeDicts {
                let cafe = Cafe(dict: cafeDict)
                cafesArray.append(cafe)
            }
        }
        
        cafes = cafesArray
    }

    func cafeWithName(name: String) -> Cafe? {
        return cafes.filter{$0.name == name}.first
    }
}

struct CityList {
    
    private struct Keys {
        static let selectedCityKey = "selectedCity"
    }
    
    let citys: [City]
    
    var cafes:[Cafe] {
        get {
            let possible = citys.filter{$0.name == selectedCity}
            if let city = possible.first {
                return city.cafes
            }
            
            return citys.first!.cafes
        }
    }
    
    var selectedCity: String! {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(selectedCity, forKey: Keys.selectedCityKey)
        }
    }
    
    func takenCity(name: String) -> String? {
        let city = citys.filter{name.hasPrefix($0.name)}.first
        return city?.name
    }

    func sameCity(name: String) -> Bool {
        let city = citys.filter{name.hasPrefix($0.name)}.first
        if let cityName = city?.name {
            return cityName == selectedCity
        }

        return false
    }

    func cityWithName(name: String) -> City? {
        return (citys.filter{$0.name == name}).first
    }

    init(citys: [City]) {
        self.citys = citys
        selectedCity = NSUserDefaults.standardUserDefaults().objectForKey(Keys.selectedCityKey).map{$0 as! String} ?? citys.first!.name
    }
    
    static func readData(jsonData: NSData) -> [City] {
        var citys = [City]()
        
        if let jsonWrapper = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) {
            if let json = jsonWrapper as? [[String: AnyObject]] {
                for cityJson in json {
                    let city = City(dict: cityJson)
                    citys.append(city)
                }
            }
        }
        
        return citys
    }

    static func storeData(jsonData: NSData?) {
        
    }
    
    init() {
        let jsonData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("Cafes", withExtension: "json")!)!
        citys = CityList.readData(jsonData)
        selectedCity = NSUserDefaults.standardUserDefaults().objectForKey(Keys.selectedCityKey).map{$0 as! String} ?? citys.first!.name
    }
}