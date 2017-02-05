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

    func cafeWithName(_ name: String) -> Cafe? {
        return cafes.filter{$0.name == name}.first
    }
}

struct CityList {
    
    fileprivate struct Keys {
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
            UserDefaults.standard.set(selectedCity, forKey: Keys.selectedCityKey)
        }
    }
    
    func takenCity(_ name: String) -> String? {
        let city = citys.filter{name.hasPrefix($0.name)}.first
        return city?.name
    }

    func sameCity(_ name: String, other: String) -> Bool {
        if let name = takenCity(name), let other = takenCity(other) {
            return name == other
        }

        return false
    }

    func cityWithName(_ name: String) -> City? {
        return (citys.filter{$0.name == name}).first
    }
    
    static func readData(_ jsonData: Data) -> [City] {
        var citys = [City]()
        
        if let jsonWrapper = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
            if let json = jsonWrapper as? [[String: AnyObject]] {
                for cityJson in json {
                    let city = City(dict: cityJson)
                    citys.append(city)
                }
            }
        }
        
        return citys
    }

    static func storeData(_ jsonData: Data?) {
        try? jsonData?.write(to: cachedDataURL, options: [.atomic])
    }

    static var cachedDataURL: URL = {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return URL(string: "cafes.json", relativeTo: documentURL)!
    } ()

    init(jsonData: Data) {
        citys = CityList.readData(jsonData)
        selectedCity = UserDefaults.standard.object(forKey: Keys.selectedCityKey).map{$0 as! String} ?? citys.first!.name
    }
    
    init?(URL: Foundation.URL) {

        guard let jsonData = try? Data(contentsOf: URL) else {
            return nil
        }

        self.init(jsonData: jsonData)
    }

    fileprivate init() {
        citys = []
    }

    static func defaultList() -> CityList {
        if let cityList = CityList(URL: cachedDataURL), !cityList.citys.isEmpty {
            return cityList
        }

        return CityList(URL: Bundle.main.url(forResource: "cafes", withExtension: "json")!)!
    }
}
