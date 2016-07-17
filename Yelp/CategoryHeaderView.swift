//
//  CategoryHeaderView.swift
//  Yelp
//
//  Created by Welcome on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CategoryHeaderView: UIView {
    
    @IBOutlet weak var headerTitle: UILabel!
    
    var sectionIndex: Int = -1
    
    // MARK: Init
    class func initFromNib() -> CategoryHeaderView! {
        return UINib(nibName:"CategoryHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CategoryHeaderView
    }

}
