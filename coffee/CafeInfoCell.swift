//
//  CafeInfoCell.swift
//  coffee
//
//  Created by flexih on 1/18/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import Static

class CafeInfoCell: SubtitleCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFontOfSize(12)
        textLabel?.textColor = UIColor(hex: 0xFB8472)
        
        detailTextLabel?.font = UIFont.systemFontOfSize(15)
        detailTextLabel?.textColor = UIColor(hex: 0x968F8B)
        detailTextLabel?.numberOfLines = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
