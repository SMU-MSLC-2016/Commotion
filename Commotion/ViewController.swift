//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    // MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    //MARK: UI Elements
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.stepsLabel.text = "No Steps Data"
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main)
            {(activity:CMMotionActivity?)->Void in
                // unwrap the activity and disp
                if let unwrappedActivity = activity {
                    DispatchQueue.main.async{
                        self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)"
                    }
                }
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date(), withHandler: self.handlePedometer )
        }
    }
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?){
        if pedData != nil {
            let steps = pedData?.numberOfSteps
            DispatchQueue.main.async{
                self.stepsSlider.setValue((steps?.floatValue)!, animated: true)
                self.stepsLabel.text = "Steps: \(steps!)"
            }
        }
    }


}

