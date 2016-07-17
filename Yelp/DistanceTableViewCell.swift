//
//  DistanceTableViewCell.swift
//  Yelp
//
//  Created by Welcome on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {
    static let ClassName = "DistanceTableViewCell"
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        checkImageView.layer.cornerRadius = checkImageView.frame.size.width / 2
        checkImageView.clipsToBounds = true
    }
    
    var checked: Bool! {
        didSet {
            if (checked != nil && checked)  {
                checkImageView.image =  UIImage(named:"checked")
                checkImageView.layer.backgroundColor = UIColor.whiteColor().CGColor
            } else {
                checkImageView.image =  nil
                checkImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            }
        }
    }
    
}
