//
//  MotionCalculator.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 11/29/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import CoreMotion
import ObjectMapper

class MotionCalculator: NSObject {
    
    var motionModel: MotionModel?
    
    override init(){
        motionModel = MotionModel()
    }
    
    func didInit() {
        self.motionManager.accelerometerUpdateInterval = 3.0 / 60.0
        self.motionManager.startAccelerometerUpdates(to: motionQueue, withHandler: handleMotion)
    }
    
    // Mark class variables:
    enum Direction {
        case forward
        case reverse
        case left
        case right
        case stopped
    }
    var dir:Direction = Direction.stopped
    
    let motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    
    
    func handleMotion(motion:CMAccelerometerData?, error:Error?) {
        if (error != nil) {
            print(error!.localizedDescription)
        }
        if (motion != nil){
            let data = motion!.acceleration
            
            let xz = acos( data.x / ( pow(data.x,2) + pow(data.z,2) ).squareRoot()  ) * 180 / Double.pi
            let xy = acos( data.x / ( pow(data.x,2) + pow(data.y,2) ).squareRoot() ) * 180 / Double.pi
            self.motionModel?.updateValues(f: false, re: false, l: false, r: false, s: true)
            dir = Direction.stopped
            if  ((xy < 20) || (xy > 160))  {
                if data.x > 0 {
                    if xz > 50 {
                        dir = Direction.forward
                        self.motionModel?.updateValues(f: true, re: false, l: false, r: false, s: false)
                    }else if xz < 20{
                        dir = Direction.reverse
                        self.motionModel?.updateValues(f: false, re: true, l: false, r: false, s: false)
                    }
                }else {
                    if xz < 130 {
                        dir = Direction.forward
                        self.motionModel?.updateValues(f: true, re: false, l: false, r: false, s: false)
                    }else if xz > 160{
                        dir = Direction.reverse
                        self.motionModel?.updateValues(f: false, re: true, l: false, r: false, s: false)
                    }
                }
            }else{
                if data.x > 0 {
                    if data.y < 0 {
                        dir = Direction.left
                        self.motionModel?.updateValues(f: false, re: false, l: true, r: false, s: false)

                    }else{
                        dir = Direction.right
                        self.motionModel?.updateValues(f: false, re: false, l: false, r: true, s: false)

                    }
                }else {
                    if data.y > 0 {
                        dir = Direction.left
                        self.motionModel?.updateValues(f: false, re: false, l: true, r: false, s: false)
                    }else{
                        dir = Direction.right
                        self.motionModel?.updateValues(f: false, re: false, l: false, r: true, s: false)
                    }
                }
            }
//            OperationQueue.main.addOperation {
//                print("Data- ", x, y, z)
//                print ("X-Z: ", String.localizedStringWithFormat("%.2f", xz), " X-Y: ", String.localizedStringWithFormat("%.2f", xy))
//                print(String(describing: dir))
//            }
        }
    }
    
    func getJSON() -> [String: Any] {
        let JSONString  = Mapper().toJSONString(self.motionModel!, prettyPrint: true)
        
        let JSON = convertToDictionary(text: JSONString!)
   
        return JSON!
    }
    
    func getDriection() -> Direction {
        return dir
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
