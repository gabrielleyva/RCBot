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

 var ip = "http://10.8.69.209:5000/"

class ViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var leftButton: MDCFloatingButton!
    @IBOutlet weak var rightButton: MDCFloatingButton!
    @IBOutlet weak var webView: WKWebView!
    
    var motionCalculator:MotionCalculator?
    var timer = Timer()
    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCameraView()
        self.prepareRightButton()
        self.prepareLeftButton()
        self.prepareMotionCalculator()
        self.scheduledTimerWithTimeInterval()
        viewModel = ViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scheduledTimerWithTimeInterval(){
     timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateMotion), userInfo: nil, repeats: true)
    }
    
    @objc func updateMotion(){
        let data = motionCalculator?.getJSON()
        viewModel?.updateMotion(parameters: data!)
        
    }
    
    func prepareMotionCalculator() {
        motionCalculator = MotionCalculator()
        motionCalculator?.didInit()
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
        print("Called")
        webView.navigationDelegate = self
        let url = URL(string: "http://10.8.69.209:5000")!
        webView.load(URLRequest(url: url))
    }

    @IBAction func leftButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func rightButtonPressed(_ sender: Any) {
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.motionCalculator?.motionManager.stopDeviceMotionUpdates()
    }
    
}

