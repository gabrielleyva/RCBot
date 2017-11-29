//
//  ViewController.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 11/20/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

/*
 SSH password to raspberry pi is 12345
 To find raspberry ip is $ hostname
 Access camera:
    1. $ sudo raspi-config
    2. interfaces -> Enable Camera -> Finish
 */
let ip = "http://192.168.0.15:5000/"
import UIKit
import WebKit
import MaterialComponents
import Foundation
import CoreMotion

class ViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var leftButton: MDCFloatingButton!
    @IBOutlet weak var rightButton: MDCFloatingButton!
    @IBOutlet weak var webView: WKWebView!
    
    // Mark class variables:
    enum Direction {
        case forward
        case reverse
        case left
        case right
        case stopped
    }
    let motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    var sensitivity = 0.3
    
    var motionDirection = Direction.stopped {
        didSet{
            // MARK: - Directional Updates
            switch motionDirection {
            case .forward:
                // MARK: insert forward call here
                
                break
            case.reverse:
                // MARK: insert reverse call here
                
                
                break
            case.left:
                // MARK: Insert left call here
                
                
                break
            case.right:
                // MARK: Insert right call here
                
                
                break
            default:
                // MARK: -
                // Do nothing
                print("Stopped")
            }
        }
    }
    
    
    
    //-----------testing-------
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var direction: UILabel!
    //--------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCameraView()
        self.prepareRightButton()
        self.prepareLeftButton()
        self.motionManager.accelerometerUpdateInterval = 3.0 / 60.0
        self.motionManager.startAccelerometerUpdates(to: motionQueue, withHandler: handleMotion)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareRightButton() {
        rightButton.backgroundColor = .newGreen
        rightButton.setTitleColor(.white, for: .normal)
    }
    
    func prepareLeftButton() {
        leftButton.backgroundColor = .newRed
        leftButton.setTitleColor(.white, for: .normal)
    }
    
    func loadCameraView() {
        webView.navigationDelegate = self
        let url = URL(string: ip+"/video_feed")!
        webView.load(URLRequest(url: url))
    }

    @IBAction func leftButtonPressed(_ sender: Any) {
        self.makeServerCall(route: "move_left_motors")
    }
    
    
    @IBAction func rightButtonPressed(_ sender: Any) {
    }
    
    func makeServerCall(route:String) {
        
        let newRoute = ip + route
        
        let url = URL(string: newRoute)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func handleMotion(motion:CMAccelerometerData?, error:Error?) {
        if (error != nil) {
            print(error!.localizedDescription)
        }
        if (motion != nil){
            let data = motion!.acceleration
            let x = "X:" + String.localizedStringWithFormat("%.2f", data.x)
            let y = " Y:" + String.localizedStringWithFormat("%.2f", data.y)
            let z = " Z:" + String.localizedStringWithFormat("%.2f", data.z)
            let xz = acos( data.x / ( pow(data.x,2) + pow(data.z,2) ).squareRoot()  ) * 180 / Double.pi
            let xy = acos( data.x / ( pow(data.x,2) + pow(data.y,2) ).squareRoot() ) * 180 / Double.pi
            var dir = Direction.stopped
            if  ((xy < 20) || (xy > 160))  {
                if data.x > 0 {
                    if xz > 50 {
                        dir = Direction.forward
                    }else if xz < 20{
                        dir = Direction.reverse
                    }
                }else {
                    if xz < 130 {
                        dir = Direction.forward
                    }else if xz > 160{
                        dir = Direction.reverse
                    }
                }
            }else{
                if data.x > 0 {
                    if data.y < 0 {
                        dir = Direction.left
                    }else{
                        dir = Direction.right
                    }
                }else {
                    if data.y > 0 {
                        dir = Direction.left
                    }else{
                        dir = Direction.right
                    }
                }
            }
            OperationQueue.main.addOperation {
                self.temp.text = "Data- "+x+y+z
                self.temp2.text = "X-Z: " + String.localizedStringWithFormat("%.2f", xz) + " X-Y: " + String.localizedStringWithFormat("%.2f", xy)
                self.direction.text = String(describing: dir)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.motionManager.stopDeviceMotionUpdates()
    }
    
}

