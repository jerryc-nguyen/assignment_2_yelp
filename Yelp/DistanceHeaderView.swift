//
//  DistanceHeaderView.swift
//  Yelp
//
//  Created by Welcome on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol DistanceHeaderViewDeletage {
    func distanceHeaderViewDeletage(headerView: DistanceHeaderView, didSelectSection value: Int)
}

class DistanceHeaderView: UIView {
    var delegate: DistanceHeaderViewDeletage?
    
    var sectionIndex: Int = -1
    
    @IBOutlet weak var headerTitle: UILabel!

    // MARK: Init
    class func initFromNib() -> DistanceHeaderView! {
        return UINib(nibName:"DistanceHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! DistanceHeaderView
    }
    
    @IBAction func didSelectHeader(sender: AnyObject) {
        self.delegate?.distanceHeaderViewDeletage(self, didSelectSection: self.sectionIndex)
    }
}
