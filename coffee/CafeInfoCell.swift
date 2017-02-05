//
//  CafeInfoCell.swift
//  coffee
//
//  Created by flexih on 1/18/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import Static

class CafeInfoCell: UITableViewCell, Cell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 12)
        textLabel?.textColor = UIColor(hex: 0xFB8472)
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        detailTextLabel?.textColor = UIColor(hex: 0x968F8B)
        detailTextLabel?.numberOfLines = 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
