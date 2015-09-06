//
//  API.swift
//  nostalgic-pluto-ios
//
//  Created by Jinyue Xia on 1/3/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import Foundation

class API {
    var root : String
    
    init() {
        self.root = "http://pennapps2015.cloudapp.net/v1/"
    }
    
    // get account api link
    func newImageAPI() -> String {
        return root + "image/"
    }
    
    // get a list of properties 
    func getLocationsAPI() -> String {
        return root + "locations/"
    }
    
}