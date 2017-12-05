//
//  DataModel.swift
//  RCBot
//
//  Created by Mandar Phadate on 12/4/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import UIKit
import ObjectMapper

class DataModel: Mappable {
    
    var temprature: String?
    var humidity: String?
    var light: String?

    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        temprature <- map["temprature"]
        light <- map["light"]
        humidity <- map["humidity"]
    }
}
