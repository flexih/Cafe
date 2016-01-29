//
//  UIColor+Hex.swift
//  coffee
//
//  Created by flexih on 1/8/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: UInt32) {
        self.init(red: CGFloat(hex >> UInt32(16)) / 255.0,
            green: CGFloat((hex >> UInt32(8)) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF)/255.0,
            alpha: 1)
    }
}
