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

    }
    
    func rotateServo(parameters: [String: Any]) {
        let url = ip + "/rotateServo"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
    }
    
    func getData(id: String, completionHandler: @escaping ([String : Any]?, Error?) -> ()){
        makeDataCall(completionHandler: completionHandler)
    }
    
    func makeDataCall(completionHandler: @escaping ([String : Any]?, Error?) -> ()){
        let url = ip + "/getData"
        
        Alamofire.request(url).responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value as? [String : Any], nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    

}
