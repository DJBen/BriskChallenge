//
//  World.swift
//  BriskChallenge
//
//  Created by Ben Lu on 7/30/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import Alamofire

public let WorldErrorDomain = "GameManagerErrorDomain"

public class World: NSObject {
    
    public enum ErrorCode: Int {
        case ErrorParsingReponse
    }
    
    public static let sharedWorld = World()
    
    let token = "37a69fbd7b3bcee108df0af9f0481e0eaeb4bb75"
    let host = "http://www.briskchallenge.com"
    
    var game: String?
    
    public internal(set) var continents: [Continent]?
    public internal(set) var territories: [Territory]?
    
    public func joinGame(completion: (gameID: String?, error: NSError?) -> Void) {
        let path = "/v1/brisk/game"
        request(.POST, host + path, parameters: ["join": true, "team_name": "iOS_rocks"], encoding: ParameterEncoding.JSON).responseJSON { (request, response, JSON, error) -> Void in
            if error != nil {
                println(error)
                completion(gameID: nil, error: error)
                return
            }
            if let gameID = JSON?["game"] as? String, token = JSON?["token"] as? String {
                completion(gameID: gameID, error: nil)
            } else {
                var userInfo: [String: AnyObject]?
                if JSON != nil {
                    userInfo = ["error_payload": JSON!]
                }
                let error = NSError(domain: WorldErrorDomain, code: ErrorCode.ErrorParsingReponse.rawValue, userInfo: userInfo)
                completion(gameID: nil, error: error)
            }
        }
    }
    
    public func joinGame() -> String? {
        let semaphore = dispatch_semaphore_create(0)
        var theGameID: String?
        joinGame { (gameID, error) -> Void in
            theGameID = gameID
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return theGameID
    }
    
    public func parseMapJSON(JSON: [String: AnyObject]) -> (territories: [Territory], continents: [Continent]) {
        if let rawTerritories = JSON["territories"] as? [[String: AnyObject]],
            rawContinents = JSON["continents"] as? [[String: AnyObject]] {
                let territories = rawTerritories.flatMap { rawTerritory -> [Territory] in
                    if let territory = Territory(dictionary: rawTerritory) {
                        return [territory]
                    } else {
                        println("Error: territory cannot be parsed: \(rawTerritory)")
                        return []
                    }
                }
                let continents = rawContinents.flatMap { rawContinent -> [Continent] in
                    if let continent = Continent(dictionary: rawContinent) {
                        return [continent]
                    } else {
                        println("Error: continent cannot be parsed: \(rawContinent)")
                        return []
                    }
                }
                return (territories, continents)
        } else {
            return ([], [])
        }
    }
    
    public func fetchMap(completion: (error: NSError?) -> Void) {
        if game == nil {
            println("Game is nil!")
            return
        }
        let path = "/v1/brisk/game/\(game!)"
        request(.GET, host + path, parameters: ["map": true], encoding: .JSON).responseJSON { (request, response, JSON, error) -> Void in
            if error != nil {
                println(error)
                completion(error: error)
                return
            }
            if  JSON!["error_msg"] != nil {
                let userInfo = ["error_payload": JSON!]
                let error = NSError(domain: WorldErrorDomain, code: ErrorCode.ErrorParsingReponse.rawValue, userInfo: userInfo)
                completion(error: error)
                return
            }
            let data = self.parseMapJSON(JSON! as! [String: AnyObject])
            self.continents = data.continents
            self.territories = data.territories
        }
    }
}

