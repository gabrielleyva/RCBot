//
//  ServoModel.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 12/4/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import ObjectMapper

class ServoModel: Mappable {
    
    var angle: Int?

    required init?(map: Map) {
        
    }
    
    required init?() {
        angle = 90
    }
    
    // Mappable
    func mapping(map: Map) {
        angle <- map["angle"]
    }
}
