//
//  ViewController.swift
//  RCBot
//
//  Created by Gabriel I Leyva Merino on 11/20/17.
//  Copyright © 2017 Leyva Merino & Phadate. All rights reserved.
//

import UIKit
import WebKit
import MaterialComponents
import Foundation

class ViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var leftButton: MDCFloatingButton!
    @IBOutlet weak var rightButton: MDCFloatingButton!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCameraView()
        self.prepareRightButton()
        self.prepareLeftButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareRightButton() {
        rightButton.backgroundColor = .newBlue
        rightButton.setTitleColor(.white, for: .normal)
    }
    
    func prepareLeftButton() {
        leftButton.backgroundColor = .newGreen
        leftButton.setTitleColor(.white, for: .normal)
    }
    
    func loadCameraView() {
        webView.navigationDelegate = self
        let url = URL(string: "http://192.168.1.90:5000/")!
        webView.load(URLRequest(url: url))
    }

    @IBAction func leftButtonPressed(_ sender: Any) {
        self.makeServerCall(route: "move_left_motors")
    }
    
    
    @IBAction func rightButtonPressed(_ sender: Any) {
    }
    
    func makeServerCall(route:String) {
        
        let newRoute = "http://192.168.1.90:5000/" + route
        
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
}

