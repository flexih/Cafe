//
//  CafeSubtitleCell.swift
//  coffee
//
//  Created by flexih on 1/8/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import Static
import AlamofireImage

class CafeSubtitleCell: UITableViewCell, CellType {
    
    static let imageFilter = ScaledToSizeWithRoundedCornersFilter(size: CGSize(width: 56, height: 56), radius: 28)
    static var placeholderImage = UIImage(named: "oval")

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)

        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textLabel?.textColor = UIColor(hex: 0xFB8472)
        detailTextLabel?.textColor = UIColor(hex: 0x968F8B)
        backgroundColor = .clearColor()
        contentView.backgroundColor = .clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if var center = detailTextLabel?.center {
            center.y = CGRectGetMaxY(textLabel!.frame) + CGRectGetHeight(detailTextLabel!.bounds) / 2 + 5
            center.x = detailTextLabel!.center.x
            detailTextLabel!.center = center
        }
        
    }
    
    func configure(row row: Row) {
        textLabel?.text = row.text
        detailTextLabel?.text = row.detailText
        accessoryType = row.accessory.type
        accessoryView = row.accessory.view
        
        imageView?.af_cancelImageRequest()
        
        if let cafe = row.context?["cafe"] as? Cafe {
            imageView?.af_setImageWithURL(cafe.posterURL, placeholderImage: self.dynamicType.placeholderImage, filter: self.dynamicType.imageFilter, imageTransition: .CrossDissolve(0.25), runImageTransitionIfCached: true)
        }
    }
}
