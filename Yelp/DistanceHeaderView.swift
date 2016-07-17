//
//  DistanceHeaderView.swift
//  Yelp
//
//  Created by Welcome on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol DistanceHeaderViewDelegate {
    func distanceHeaderViewDelegate(headerView: DistanceHeaderView, didSelectSection value: Int)
}

class DistanceHeaderView: UIView {
    var delegate: DistanceHeaderViewDelegate?
    
    var sectionIndex: Int = -1
    
    @IBOutlet weak var selectedItemBtn: UIButton!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedItemBtn.layer.cornerRadius = 3
        selectedItemBtn.clipsToBounds = true
        selectedItemBtn.layer.borderWidth = 1
        selectedItemBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    // MARK: Init
    class func initFromNib() -> DistanceHeaderView! {
        return UINib(nibName:"DistanceHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! DistanceHeaderView
    }
    
    @IBAction func didSelectHeader(sender: AnyObject) {
        self.delegate?.distanceHeaderViewDelegate(self, didSelectSection: self.sectionIndex)
    }
}
