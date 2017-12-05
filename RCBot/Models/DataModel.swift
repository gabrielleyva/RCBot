//
//  DataModel.swift
//  RCBot
//
//  Created by Mandar Phadate on 12/4/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import UIKit
import Alamofire

class DataModel: NSObject {

    var temprature:String
    var humidity:String
    var light:String
    var timer = Timer()
    var i:Float = 0.0

    override init() {
        self.temprature = "Temprature: 0°C"
        self.humidity = "Humidity: 0%"
        self.light = "Brightness: 0%"
    }
    
    func startUpdates(with timeInterval:TimeInterval) {
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: true)
    }
    
    func stopUpdates() {
        self.timer.invalidate()
    }
    
    func updateData(t:Float, h:Float, b:Float) {
        self.temprature = "Temprature: "+String(t)+"°C"
        self.humidity = "Humidity: "+String(h)+"%"
        self.light = "Brightness: "+String(b)+"%"
    }

    @objc func reloadData(){
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
        //______________________________________________
        self.updateData(t: self.i, h: self.i, b: self.i)
        i += 1
        print("Reload")
        //_______________________________________________
        
        
    }


}

