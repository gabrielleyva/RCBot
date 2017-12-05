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

import UIKit
import WebKit
import MaterialComponents
import Foundation
import CoreMotion
import CircularSlider
import ObjectMapper

 var ip = "http://10.8.70.55:50002"

class ViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sensorButton: MDCRaisedButton!
    
    

    var motionCalculator:MotionCalculator?
    var timer = Timer()
    var viewModel: ViewModel?
    var dataModel: DataModel?
    var servoModel: ServoModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCameraView()
        self.prepareMotionCalculator()
        self.scheduledTimerWithTimeInterval()
        viewModel = ViewModel()
        servoModel = ServoModel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scheduledTimerWithTimeInterval(){
     timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateMotion), userInfo: nil, repeats: true)
    }
    
    @objc func updateMotion(){
        let data = motionCalculator?.getJSON()
        viewModel?.updateMotion(parameters: data!)
        
    }
    
    func prepareMotionCalculator() {
        motionCalculator = MotionCalculator()
        motionCalculator?.didInit()
    }
    
    func loadCameraView() {
        webView.navigationDelegate = self
        let url = URL(string: ip)!
        webView.load(URLRequest(url: url))
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.motionCalculator?.motionManager.stopDeviceMotionUpdates()
    }
    
    @IBAction func sliderValueDidChange(_ sender: Any) {
        self.servoModel?.angle = self.slider.value
        let data = self.getJSON()
        viewModel?.updateMotion(parameters: data)
        
    }
    
    @IBAction func sensorButtonPressed(_ sender: Any) {
        self.viewModel?.getData(id: "10") { responseObject, error in
            self.dataModel = DataModel(JSON: responseObject!)
            self.humidityLabel.text = "Humidity: " + (self.dataModel?.humidity)!
            self.tempLabel.text = "Temperature: " + (self.dataModel?.temprature)!
            self.brightnessLabel.text = "Brightness: " + (self.dataModel?.light)!
        }
    
    }
    
    func getJSON() -> [String: Any] {
        let JSONString  = Mapper().toJSONString(self.servoModel!, prettyPrint: true)
        
        let JSON = convertToDictionary(text: JSONString!)
        
        return JSON!
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

