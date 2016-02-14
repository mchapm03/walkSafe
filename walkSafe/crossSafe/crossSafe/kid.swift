//
//  kid.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class Kid {
    
    var name: String
    var phone: Int?
    var isConfirmed: Bool
    var routes = [Route]()
    
    init?(name: String, phone: Int?){
        self.name = name
        self.phone = phone
        self.isConfirmed = false
        if name.isEmpty{
            return nil
        }
    }
    init?(name: String){
        self.name = name
        self.isConfirmed = false
        if name.isEmpty{
            return nil
        }
    }

}