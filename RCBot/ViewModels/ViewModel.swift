//
//  ViewModel.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 11/29/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class ViewModel: NSObject {
    
    override init() {
 
    }

    func updateMotion(parameters: [String: Any]) {
        let url = ip + "/updateMotion"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }

    }
    

}
