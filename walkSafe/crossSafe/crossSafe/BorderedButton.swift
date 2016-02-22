//
//  BorderedButton.swift
//  crossSafe
//
//  Created by Courtney Won on 2/17/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2
        layer.borderColor = tintColor.CGColor
        layer.cornerRadius = 6
        
        contentEdgeInsets = UIEdgeInsets(top: 30, left: 80, bottom: 30, right: 80)
    }

}
