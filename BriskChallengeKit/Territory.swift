//
//  Territory.swift
//  BriskChallenge
//
//  Created by Ben Lu on 7/30/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit

public class Territory: NSObject {
    public let identifier: Int
    public let name: String
    let adjacentTerritoryIdentifiers: [Int]
    
    public var adjacentTerritories: [Territory] {
        get {
            if let territories = World.sharedWorld.territories {
                return territories.filter { territory -> Bool in
                    return find(self.adjacentTerritoryIdentifiers, territory.identifier) != nil
                }
            } else {
                println("Warning: territories not initialized")
                return []
            }
        }
    }
    
    public init?(dictionary: [String: AnyObject]) {
        if let identifier = dictionary["territory"] as? Int,
        name = dictionary["territory_name"] as? String,
        adjTerritories = dictionary["adjacent_territories"] as? [Int] {
            self.identifier = identifier
            self.name = name
            self.adjacentTerritoryIdentifiers = adjTerritories
            super.init()
        } else {
            self.identifier = -1
            self.name = ""
            self.adjacentTerritoryIdentifiers = []
            super.init()
            return nil
        }
    }
    
}
