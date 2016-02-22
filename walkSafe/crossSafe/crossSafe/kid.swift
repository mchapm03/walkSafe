//
//  kid.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class Kid: NSObject, NSCoding {
    struct PropertyKey {
        static let nameKey = "name"
        static let isConfirmedKey = "isConfirmed"
    }
    // MARK: Properties
    var name: String
    var phone: Int?
    var isConfirmed: Bool
    var stats: KidStatistics
    var routes = [Route]()
    var routeIDs = [Double]()
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("kids")

    
    init?(name: String, phone: Int?){
        self.name = name
        self.phone = phone
        self.isConfirmed = false
        self.stats = KidStatistics()
        super.init()
        
        if name.isEmpty{
            return nil
        }
    }
    init?(name: String){
        self.name = name
        self.isConfirmed = false
        self.stats = KidStatistics()
        super.init()
        
        if name.isEmpty{
            return nil
        }
    }

    
    // TODO: Update this function so that it checks that the user connection code is valid
    func confirmKid (code: Int?) {
        self.isConfirmed = true
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeBool(isConfirmed, forKey: PropertyKey.isConfirmedKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let isConfirmed = aDecoder.decodeBoolForKey(PropertyKey.isConfirmedKey)
        
        self.init(name: name)
        self.isConfirmed = isConfirmed

    }
}