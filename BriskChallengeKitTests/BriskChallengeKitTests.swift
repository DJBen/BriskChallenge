//
//  BriskChallengeKitTests.swift
//  BriskChallengeKitTests
//
//  Created by Sihao Lu on 7/30/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import XCTest
import BriskChallengeKit

class BriskChallengeKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContinentsAndTerritoriesAreParsedCorrectly() {
        let json = "{\"version\": \"v1\", \"service\": \"brisk\", \"game\": 1234, \"territories\": [{\"territory\": 1, \"territory_name\": \"Territory 1\", \"adjacent_territories\":[2,3]}, {\"territory\": 2, \"territory_name\": \"Territory 2\", \"adjacent_territories\":[1]}, {\"territory\": 3, \"territory_name\": \"Territory 3\", \"adjacent_territories\":[1]}, {\"territory\": 4, \"territory_name\": \"Territory 4\", \"adjacent_territories\":[1]}], \"continents\":[{\"continent\":1, \"continent_name\":\"Continent 1\", \"continent_bonus\":5, \"territories\":[1,2,3,5,6,7,8,10]}, {\"continent\":2, \"continent_name\":\"Continent 2\", \"continent_bonus\":2, \"territories\":[9,13,14,15]}]}"
        let object = NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: nil) as! [String: AnyObject]
        
        let data = World.sharedWorld.parseMapJSON(object)
        let cont1 = data.continents[0]
        XCTAssertEqual(cont1.identifier, 1)
        XCTAssertEqual(cont1.name, "Continent 1")
        XCTAssertEqual(cont1.bonus, 5)
        println(data.continents)
        println(data.territories)
    }
    
}
