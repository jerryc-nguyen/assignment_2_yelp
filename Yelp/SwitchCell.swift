//
//  SwitchCell.swift
//  Yelp
//
//  Created by Welcome on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol SwitchCellDelegate {
    optional func switchCell(switchedCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!

    @IBOutlet weak var switcher: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSwitch(sender: UISwitch) {
        print("Switch value changed!", sender.on)
        
        delegate!.switchCell?(self, didChangeValue: switcher.on)
    }
    
    
}
