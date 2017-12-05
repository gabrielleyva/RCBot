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
import ObjectMapper
import CircularSlider

 var ip = "http://10.8.70.55:5000"

class ViewController: UIViewController, WKNavigationDelegate, CircularSliderDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var sensorButton: MDCRaisedButton!
    
    

    var motionCalculator:MotionCalculator?
    var timer = Timer()
    var viewModel: ViewModel?
    var dataModel: DataModel?
    var servoModel: ServoModel?
    var circleSlider: CircularSlider?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCameraView()
        self.prepareMotionCalculator()
        self.scheduledTimerWithTimeInterval()
        
        self.prepareSlider()
        self.prepareSensorButton()
        self.prepareTransView()
        self.prepareLabels()
        
        viewModel = ViewModel()
        servoModel = ServoModel()
  
    }
    
    func prepareLabels() {
        tempLabel.textColor = .newRed
        humidityLabel.textColor = .newRed
    }
    
    func prepareTransView() {
        transView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        transView.layer.cornerRadius = 5
    }
    
    func prepareSensorButton() {
        sensorButton.backgroundColor = .newGreen
        sensorButton.setTitleColor(.white, for: .normal)
    }
    
    func prepareSlider() {
        let frame = CGRect(x:  self.view.frame.width - 225, y: self.view.frame.height - 225, width: 200, height: 200)
        circleSlider = CircularSlider(frame: frame)
        circleSlider?.setValue(90, animated: true)
        circleSlider?.maximumValue = 165
        circleSlider?.minimumValue = 15
        circleSlider?.backgroundColor = .clear
        circleSlider?.delegate = self
        circleSlider?.title = "Degrees"
        circleSlider?.bgColor = .lightGray
        circleSlider?.pgNormalColor = .newBlue
        circleSlider?.pgHighlightedColor = .newBlue
        circleSlider?.tintColor = .newBlue
        circleSlider?.knobRadius = 50
        
        self.view.addSubview(circleSlider!)
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
        webView.isUserInteractionEnabled = false
        webView.scrollView.isScrollEnabled = false
        let url = URL(string: ip)!
        webView.load(URLRequest(url: url))
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.motionCalculator?.motionManager.stopDeviceMotionUpdates()
    }
    
    @IBAction func sensorButtonPressed(_ sender: Any) {
        self.viewModel?.getData(id: "10") { responseObject, error in
            self.dataModel = DataModel(JSON: responseObject!)
            self.humidityLabel.text = " Humidity: " + (self.dataModel?.humidity)! + "%"
            self.tempLabel.text = " Temperature: " + (self.dataModel?.temperature)! + "°"
        }
    
    }
    
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {
        self.servoModel?.angle = Int(value)
        let data = self.getJSON()
        print(data)
        viewModel?.rotateServo(parameters: data)
        return floorf(value)
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

