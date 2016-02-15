//
//  routeTableViewCell.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//
import UIKit

class routeTableViewCell: UITableViewCell {
    
    //TODO: Add red, yellow and green circle images to display next to routes
    @IBOutlet weak var routeColor: UIImageView!
    
    @IBOutlet weak var routeTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
