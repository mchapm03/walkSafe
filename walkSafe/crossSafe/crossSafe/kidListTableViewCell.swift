//
//  kidListTableViewCell.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class kidListTableViewCell: UITableViewCell {
    @IBOutlet weak var childLabel: UILabel!

    @IBOutlet weak var childLabel2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
