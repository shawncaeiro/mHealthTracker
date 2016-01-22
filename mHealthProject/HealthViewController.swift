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

    // Initial step values
    var step_threshold = 7500
    var step_current = 0
    
    // Classes for retrieve step sensor data
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    // Date Retrival
    let startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
    
    // Label initializers
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var sayingLabel: UILabel!
    @IBOutlet weak var stepCounter: UILabel!
    @IBOutlet weak var hwLabel: UILabel!
    
    // Text Field Initializer
    @IBOutlet weak var manualStepEntry: UITextField!
    
    // Run on App open
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualStepEntry.delegate = self;
        writeThreshold()
    }
    
    // Run when Health View appears
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Begin retrieving sensor data
        getPedometerData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPedometerData() {
        // Attempt to begin to receive continuous sensor data
        // Data will be sent from sensors
        // Every time data is sent, the dispatch_async portion of the code is run
        
        pedometer.startPedometerUpdatesFromDate(startOfToday) { data, error in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stepCounter.font = self.stepCounter.font.fontWithSize(24)
                    // Updates UI step count
                    self.updateStepCount(Int(data.numberOfSteps))
                    // check is Hello or World should be shown
                    self.updateHello()
                    // POST data to databse
                    self.postData(data)
                })
            }
            else {
                // If data is not found, display info on how to allow Step Tracking Access
                self.stepCounter.font = self.stepCounter.font.fontWithSize(12)
                self.stepCounter.text = "Please allow access to 'Motion & Fitness' for mHealthTracker in iPhone settings and then restart app. Otherwise, app is useless."
            }
        }
    }
    
    func postData(stepData: CMPedometerData) {
        // Function to POST data from sensor to database
        
        // Serialize data into a PF object
        let stepResults = PFObject(className:"healthTracker")
        stepResults["startDate"] = stepData.startDate
        stepResults["endDate"] = stepData.endDate
        stepResults["steps"] = stepData.numberOfSteps
        
        // POST PF Object data to backend
        stepResults.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func updateHello(){
        // Conditional logic for whether to display HELLO or WORLD
        // Depending on the step count so far today
        
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
    
    func writeThreshold(){
        // Function to display new Threshold to UI
        
        thresholdLabel.text = "Goal: \(step_threshold) steps"
    }
    
    func updateThreshold(){
        // Function process manual Threshold entry
        
        // Get input from Text Field
        let newThreshold = Int(manualStepEntry.text!)
        
        // Check if the input was an Int.
        // If if is not, newThreshold will be nil and this code won't run
        if newThreshold != nil {
            step_threshold = newThreshold!
            writeThreshold()
        }
        manualStepEntry.text = ""
    }
    
    func textFieldShouldReturn(manualStepEntry: UITextField) -> Bool {
        // Function to update data once manual threshold is entered.
        self.view.endEditing(true)
        updateThreshold()
        updateHello()
        return false
    }
    
    func updateStepCount(step: Int) {
        // Function to display new step count to UI
        
        step_current = step
        stepCounter.text = "\(step) steps today!"
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
