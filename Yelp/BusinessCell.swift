//
//  BusinessCell.swift
//  Yelp
//
//  Created by Welcome on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewCountLabel.text = String(business.reviewCount)
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            thumbImageView.setImageWithURL(business.imageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
