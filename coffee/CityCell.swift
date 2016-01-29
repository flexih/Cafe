//
//  CityCell.swift
//  coffee
//
//  Created by flexih on 1/24/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Static

class CityCell: UITableViewCell, CellType {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
//        textLabel?.font = UIFont.systemFontOfSize(12)
        textLabel?.textColor = UIColor(hex: 0xFB8472)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
