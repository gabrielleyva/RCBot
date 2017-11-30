//
//  MotionModel.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 11/29/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import Foundation
import ObjectMapper

class MotionModel: Mappable {
    
    var forward: Bool?
    var reverse: Bool?
    var left: Bool?
    var right: Bool?
    var stop: Bool?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        forward = false
        reverse = false
        left = false
        right = false
        stop = true
    }
    
    // Mappable
    func mapping(map: Map) {
        forward <- map["forward"]
        reverse <- map["reverse"]
        left <- map["left"]
        right <- map["right"]
        stop <- map["stop"]
    }
    
    func updateValues(f: Bool, re: Bool, l: Bool, r: Bool, s: Bool) {
        forward = f
        reverse = re
        left = l
        right = r
        stop = s
    }
}
