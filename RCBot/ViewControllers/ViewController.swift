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

 var ip = "http://192.168.43.187:5000"

class ViewController: UIViewController, WKNavigationDelegate, CircularSliderDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var sensorButton: MDCRaisedButton!
    @IBOutlet weak var startButton: MDCRaisedButton!
    
    
    

    var motionCalculator:MotionCalculator?
    var timer = Timer()
    var viewModel: ViewModel?
    var dataModel: DataModel?
    var servoModel: ServoModel?
    var circleSlider: CircularSlider?
    var hidden: Bool!
    var start: Bool!
    var angleLabel: UILabel?
    var dir:MotionCalculator.Direction = MotionCalculator.Direction.stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hidden = false
        start = true
        
        viewModel = ViewModel()
        servoModel = ServoModel()
        
        self.prepareMotionCalculator()
        
        self.prepareSlider()
        self.prepareSensorButton()
        self.prepareTransView()
        self.prepareLabels()
        self.prepareStartButton(bgColor: .newGreen, textColor: .white, title: "Start")
        self.prepareDoubleTap()
        self.prepareAngleLabel()
    
    }
    
    func prepareDoubleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        if hidden == false  {
            self.tempLabel.isHidden = false
            self.circleSlider?.isHidden = false
            self.humidityLabel.isHidden = false
            self.transView.isHidden = false
            self.sensorButton.isHidden = false
            self.startButton.isHidden = false
            hidden = true
            
        } else {
            self.tempLabel.isHidden = true
            self.circleSlider?.isHidden = true
            self.humidityLabel.isHidden = true
            self.transView.isHidden = true
            self.sensorButton.isHidden = true
            self.startButton.isHidden = true
            hidden = false
        }
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
    
    func prepareStartButton(bgColor: UIColor, textColor: UIColor, title: String ) {
        startButton.backgroundColor = bgColor
        startButton.setTitleColor(textColor, for: .normal)
        startButton.setTitle(title, for: .normal)
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
        circleSlider?.hideLabels = true
        
        self.view.addSubview(circleSlider!)
    }
    
    func prepareAngleLabel() {
        let frame = CGRect(x: 0, y:  ((self.circleSlider?.frame.size.height)!  - 50) / 2, width: 200, height: 50)
        angleLabel = UILabel(frame: frame)
        angleLabel?.text = String(describing: (servoModel?.angle)!) + "°"
        angleLabel?.font = UIFont.systemFont(ofSize: 50)
        angleLabel?.textColor = .darkGray
        angleLabel?.textAlignment = .center
        
        self.circleSlider!.addSubview(angleLabel!)
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
        let dir = motionCalculator?.getDriection()
        if (dir != self.dir){
            viewModel?.updateMotion(parameters: data!)
            self.dir = dir!
        }
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
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if start == true {
            self.scheduledTimerWithTimeInterval()
            self.motionCalculator?.didInit()
            self.prepareStartButton(bgColor: .newRed, textColor: .white, title: "Stop")
             self.loadCameraView()
            start = false
        } else {
            timer.invalidate()
            self.prepareStartButton(bgColor: .newGreen, textColor: .white, title: "Start")
            start = true
            self.motionCalculator?.motionManager.stopDeviceMotionUpdates()
            self.motionCalculator?.motionModel?.updateValues(f: false, re: false, l: false, r: false, s: true)
            let data = motionCalculator?.getJSON()
            viewModel?.updateMotion(parameters: data!)
            
        }
    }
    
    
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {
        self.servoModel?.angle = Int(value)
        let data = self.getJSON()
        print(data)
        viewModel?.rotateServo(parameters: data)
        self.angleLabel?.text = String(describing: (servoModel?.angle)!) + "°"
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

