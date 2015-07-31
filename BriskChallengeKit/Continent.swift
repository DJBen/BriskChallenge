//
//  Continent.swift
//  BriskChallenge
//
//  Created by Ben Lu on 7/30/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit

public class Continent: NSObject {
    public let identifier: Int
    public let name: String
    public let bonus: Double
    let territoryIdentifiers: [Int]
    
    public var territories: [Territory] {
        get {
            if let territories = World.sharedWorld.territories {
                return territories.filter { territory -> Bool in
                    return find(self.territoryIdentifiers, territory.identifier) != nil
                }
            } else {
                println("Warning: continents not initialized")
                return []
            }
        }
    }
    
    
    public init?(dictionary: [String: AnyObject]) {
        if let identifier = dictionary["continent"] as? Int,
        name = dictionary["continent_name"] as? String,
        bonus = dictionary["continent_bonus"] as? Double,
        territoryIDs = dictionary["territories"] as? [Int] {
            self.identifier = identifier
            self.name = name
            self.bonus = bonus
            self.territoryIdentifiers = territoryIDs
            super.init()
        } else {
            self.identifier = -1
            self.name = ""
            self.bonus = -1
            territoryIdentifiers = []
            super.init()
            return nil
        }
    }
}
