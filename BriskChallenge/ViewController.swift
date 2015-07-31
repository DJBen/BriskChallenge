//
//  ViewController.swift
//  BriskChallenge
//
//  Created by Ben Lu on 7/30/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import BriskChallengeKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let gameID = World.sharedWorld.joinGame()
        World.sharedWorld.fetchMap { (error) -> Void in
            println(World.sharedWorld.territories)
            println(World.sharedWorld.continents)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

