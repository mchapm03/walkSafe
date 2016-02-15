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
    var stats: KidStatistics
    var routes = [Route]()
    
    init?(name: String, phone: Int?){
        self.name = name
        self.phone = phone
        self.isConfirmed = false
        self.stats = KidStatistics()
        if name.isEmpty{
            return nil
        }
    }
    init?(name: String){
        self.name = name
        self.isConfirmed = false
        self.stats = KidStatistics()
        if name.isEmpty{
            return nil
        }
    }

    
    // TODO: Update this function so that it checks that the user connection code is valid
    func confirmKid (code: Int?) {
        self.isConfirmed = true
    }
}