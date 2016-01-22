//
//  HealthViewController.swift
//  mHealthTracker
//
//  Created by Shawn Caeiro on 1/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreMotion
import Parse


class HealthViewController: UIViewController, UITextFieldDelegate {

    var step_threshold = 7500
    var step_current = 0
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    let startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
    
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var sayingLabel: UILabel!
    
    @IBOutlet weak var stepCounter: UILabel!
    @IBOutlet weak var manualStepEntry: UITextField!
    @IBOutlet weak var hwLabel: UILabel!
    var stepVal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualStepEntry.delegate = self;
        writeThreshold()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getPedometerData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPedometerData() {
        pedometer.startPedometerUpdatesFromDate(startOfToday) { data, error in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stepCounter.font = self.stepCounter.font.fontWithSize(24)
                    print("Steps Taken: \(data.numberOfSteps)")
                    self.updateStepCount(Int(data.numberOfSteps))
                    self.updateHello()
                    self.postData(data)
                })
            }
            else {
                self.stepCounter.font = self.stepCounter.font.fontWithSize(12)
                self.stepCounter.text = "Please allow access to 'Motion & Fitness' for mHealthTracker in iPhone settings and then restart app. Otherwise, app is useless."
            }
        }
    }
    
    func writeThreshold(){
        thresholdLabel.text = "Goal: \(step_threshold) steps"
    }
    
    func updateThreshold(){
        let newThreshold = Int(manualStepEntry.text!)
        
        if newThreshold != nil {
            step_threshold = newThreshold!
            writeThreshold()
        }
        manualStepEntry.text = ""
    }
    
    func updateStepCount(step: Int) {
        step_current = step
        stepCounter.text = "\(step) steps today!"
    }
    
    func updateHello(){
        if step_current >= step_threshold{
            hwLabel.text = "WORLD"
            hwLabel.textColor = UIColor.greenColor()
            sayingLabel.text = "Congrats! You made your goal!!!"
        }
        else {
            hwLabel.text = "HELLO"
            hwLabel.textColor = UIColor.redColor()
            sayingLabel.text = "Keep working towards your goal!"
        }
    }
    
    func postData(stepData: CMPedometerData) {
        let stepResults = PFObject(className:"healthTracker")
        stepResults["startDate"] = stepData.startDate
        stepResults["endDate"] = stepData.endDate
        stepResults["steps"] = stepData.numberOfSteps
        stepResults.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    

    
    func textFieldShouldReturn(manualStepEntry: UITextField) -> Bool {
        self.view.endEditing(true)
        updateThreshold()
        updateHello()
        return false
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
