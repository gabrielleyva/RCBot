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
    
    var temperature: String?
    var humidity: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        temperature <- map["temperature"]
        humidity <- map["humidity"]
    }
}
