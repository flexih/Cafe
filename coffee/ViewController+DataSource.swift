//
//  ViewController+DataSource.swift
//  coffee
//
//  Created by flexih on 1/9/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Static
import Alamofire
import Async

extension ViewController {

    var cafeURLString: String {
        return "https://raw.githubusercontent.com/flexih/flexih.github.io/master/coffee/cafe.json"
    }
    
    func loadCafesData() {
        
        var rows = [Row]()
        for cafe in cityList.cafes {
            var row = Row(text: cafe.name, detailText: cafe.addr, image: nil, accessory: .DisclosureIndicator, cellClass: CafeSubtitleCell.self, context: ["cafe": cafe])
            row.selection = { [weak self] indexPath in
                if let strongSelf = self  {
                    if let c = row.context?["cafe"] as? Cafe {
                        let cafeViewController = CafeViewController(cafe: c)
                        strongSelf.navigationController?.pushViewController(cafeViewController, animated: true)
                    }
                }
            }
            rows.append(row)
        }
        
        dataSource.sections = [Section(rows: rows)]
        dataSource.tableView = tableView
        
        addAnnotations(cityList.cafes)
    }

    func fetchCafeData() {
//        Alamofire.request(.GET, cafeURLString, headers: ["Accept" : "application/json"]).responseJSON { [weak self] response in
//
//            guard response.result.isSuccess else {
//                return
//            }
//
////            if let JSON = response.result.value as? [[String: AnyObject]], strongSelf = self {
////                for cityJson in JSON {
////                    let city = City(dict: cityJson)
////                    var ocity = strongSelf.cityList.cityWithName(city.name)
////
////
////                }
////            }
//
//            Async.utility {
//                CityList.storeData(response.data)
//            }
//        }
    }
    
}
