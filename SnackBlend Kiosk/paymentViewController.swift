//
//  paymentViewController.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit
import CoreBluetooth

let baudRate: Int32 = 9600      // baud rate
let screenSize: CGRect = UIScreen.main.bounds
let arduinoFunctions = ArduinoFunctions()
let paymentFunctions = PaymentFunctions()
let displayItems = DisplayItems()
let paymentViewController = PaymentViewController()
let displaySetup = DisplaySetup()

// For Unit Testing Only
var killProcessing_forceSuccessful_timer: Timer?
var killProcessing_forceSuccessful_timeInterval = 1.0

class PaymentViewController: UIViewController { //, RscMgrDelegate { // Removed to allow for functions to execute commands without reference to this VC
    
//    // RscMgr
//    var rscMgr:  RscMgr!     // RscMgr handles the serial communication
    
    // Regular Functionality
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    var arduinoRx_message = String()
    
    
    // Keypad
    var keypadVersion = "phoneNumber"
    
    let disabledColor = UIColor(
        red: 240/255.0,
        green: 240/255.0,
        blue: 240/255.0,
        alpha: 1.0)
    let enabledColor = UIColor.black
    
    var initialLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displaySetup.setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
        
//        // rscMgr
//        rscMgr = RscMgr()
//        rscMgr.setDelegate(self)
//        rscMgr.enableExternalLogging(true)
        
        // Software revision
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        print("Software version:  " + (nsObject as! String))
        
        defaults.set("3.0.0", forKey: "version")
        
        // Company name is device name <- Ease of setup of multiple devices
        defaults.set(UIDevice.current.name, forKey: "location")
        
        displayItems.configPinPad()
        
        // Subscription setup
        subscribeButton.addTarget(self, action: #selector(processSubscription), for: .touchUpInside)
        
        
        // Add layers to View Controller View
        view.addSubview(backArrow_button)
        backArrow_button.addTarget(paymentFunctions.self, action: #selector(paymentFunctions.smsReceipt_goToMain), for: .touchUpInside)
        
        for layer in [successfulPayment_circle,processingPayment_circle] {
            view.layer.addSublayer(layer)
        }
        
        for uiElement in [phoneNumberDisplay, subscribeDetails, subscribeLabel, priceLabel, subscribeLabel,
                          instructionsText, enterYourPhoneNumber,
                          instructionsLabel1,instructionsLabel2,instructionsLabel3,instructionsLabel4,
                          processingPayment_label,processingPayment_processingIcon,
                          successfulPayment_label,successfulPayment_checkMark,
                          smsReceiptLabel,instructionsLabel,receiptSentLabel] {
            view.addSubview(uiElement)
        }
        
        for uiElement in [swipeImage_view, logoImage_view, receiptImage_view, instructionsImage_view,
                          receiptSent_receiptImage_view, receiptSent_sentArrowImage_view, receiptSent_phoneImage_view] {
            view.addSubview(uiElement)
        }
        for button in [button1,button2,button3,button4,button5,button6,button7,button8,button9,button0,pinpad_lowerLeft,
                       clearPhoneButton] {
            button.addTarget(paymentFunctions.self, action: #selector(paymentFunctions.numpadPressed), for: .touchUpInside)
            view.addSubview(button)
        }
        
        pinpad_lowerRight.addTarget(paymentFunctions.self, action: #selector(paymentFunctions.phoneNumber_submit), for: .touchUpInside)
        view.addSubview(pinpad_lowerRight)
        
        for button in [receiptYes, receiptNo] {
            button.addTarget(paymentFunctions.self, action: #selector(paymentFunctions.receiptYesNo), for: .touchUpInside)
            view.addSubview(button)
        }
        
        for layer in [priceLineLayer, abovePhoneLayer, belowPhoneLayer, leftRightDividerLineLayer] {
            self.view.layer.addSublayer(layer)
        }
        
        for subView in [circularMeter] {
            self.view.addSubview(subView)
        }
        
        for button in [instructionsButton1,instructionsButton2,instructionsButton3,instructionsButton4,
                       logoButton] {
            view.addSubview(button)
        }
        
        logoButton.addTarget(self, action: #selector(menuItemsTouched), for: .touchUpInside)
        var tagNum = 0
        logoButton.tag = tagNum
        for button in [instructionsButton1,instructionsButton2,instructionsButton3,instructionsButton4] {
            button.addTarget(self, action: #selector(menuItemsTouched), for: .touchUpInside)
            tagNum += 1
            button.tag = tagNum
        }
        
        clearPhoneButton.addTarget(paymentFunctions.self, action: #selector(paymentFunctions.clearPhoneNumber), for: .touchUpInside)
        self.view.addSubview(clearPhoneButton)
        
        set_priceLabels()
        
        if (lockState_transmitted) {
            arduinoFunctions.arduinoLock_lock()
        }
        
        view.setNeedsDisplay()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initialLoad = true
        
        serverComms_priceSettings_local()
//         DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
//             // Landscape Orientation - Required
//             displaySetup.setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
//             timer_setOrientation_landscapeLeft = Timer.scheduledTimer(timeInterval: timer_setOrientation_interval, target: displaySetup.self, selector: #selector(displaySetup.setOrientation_landscapeLeft_andBrightnessFull_andNoLock_local), userInfo: nil, repeats: true)

//             //timer_acquireUnlockTimes
//             self.serverComms_siteSpecificUnlockTimes_local()
//             timer_acquireUnlockTimes = Timer.scheduledTimer(timeInterval: timeSpecificUnlockStatus_interval, target: self, selector: #selector(self.serverComms_siteSpecificUnlockTimes_local), userInfo: nil, repeats: true)

//             // Time-specific Locking
//             self.unlock_timeSpecific()
//             timer_hourSpecific = Timer.scheduledTimer(timeInterval: unlock_TimeSpecific_interval, target: self, selector: #selector(self.unlock_timeSpecific), userInfo: nil, repeats: true)

//             // Freezer Settings
//             self.serverComms_freezerSettings_local()
//             acquireFreezerSettings_timer = Timer.scheduledTimer(timeInterval: TimeInterval(acquireFreezerSettings_timeInterval), target: self, selector: #selector(self.serverComms_freezerSettings_local), userInfo: nil, repeats: true)

//             // Price Settings
//             self.serverComms_priceSettings_local()
//             acquirePriceSettings_timer = Timer.scheduledTimer(timeInterval: TimeInterval(acquirePriceSettings_timeInterval), target: self, selector: #selector(self.serverComms_priceSettings_local), userInfo: nil, repeats: true)
//         })
        
    }
    
    func killProcessing_forceSuccessful () {
        displayItems.transition_paymentProcessing_to_paymentSuccessful()
    }
    
    func menuItemsTouched (sender: UIButton) {
        print("Logo Touched - " + String(sender.tag))
        var inputVal = " "
        if (sender.tag == 0) {
            inputVal = "C"
            if (unitTesting) {
                displayItems.hideScreen_paymentSwipe()
                displayItems.showScreen_paymentProcessing()
                processingPayment_timer = Timer.scheduledTimer(timeInterval: processingPayment_timeInterval,
                                                               target: displayItems.self,
                                                               selector: #selector(displayItems.processingPayment_displayUpdate),
                                                               userInfo: nil, repeats: true)
                killProcessing_forceSuccessful_timer = Timer.scheduledTimer(timeInterval: TimeInterval(killProcessing_forceSuccessful_timeInterval),
                                                                            target: self,
                                                                            selector: #selector(killProcessing_forceSuccessful),
                                                                            userInfo: nil, repeats: false)
                
                // Check (paymentSwipe) = OK
                //            displayItems.showScreen_paymentSwipe()
                // Check (paymentProcessing) = OK
                //            displayItems.showScreen_paymentProcessing()
                //            processingPayment_timer = Timer.scheduledTimer(timeInterval: processingPayment_timeInterval,
                //                                                           target: displayItems.self,
                //                                                           selector: #selector(displayItems.processingPayment_displayUpdate),
                //                                                           userInfo: nil, repeats: true)
                // Check (paymentSuccessful) = OK
                //            displayItems.showScreen_paymentSuccessful()
                // Check SMS Receipt
                //            displayItems.showScreen_smsReceipt()
                // Check Phone Pin Pad
                //            displayItems.showScreen_phonePinPad()
                // Check (unlockingConfirmed)
                //            lockState_verification_unlocked = true
                //            arduinoFunctions.arduinoLock_unlock()
            }
        }
        else {
            inputVal = String(sender.tag)
        }
        input_last6[0] = inputVal
        input_last6 = input_last6.shiftRight()
        let printString = input_last6.joined(separator: "")
        print(printString + " == " + masterUnlockString + " = " + String(printString == masterUnlockString))
        
        // Beckinsale
        // Need to hook together the Master Unlock
        // When true, issue unlock & transition UI screens
    }
    
    // Beckinsale
//    if the user is taking too long to enter their phone number (they are haven't touched a phone number within 5 seconds), it will automatically skip the receipt [adding this tomorrow]
    
    // Beckinsale
    // Convert the timers using these functions to eliminate these functions
    func serverComms_siteSpecificUnlockTimes_local () {
        arduinoFunctions.serverComms_siteSpecificUnlockTimes()
    }
    func unlock_timeSpecific_local () {
        unlock_timeSpecific()
    }
    func serverComms_freezerSettings_local () {
        arduinoFunctions.serverComms_freezerSettings()
    }
    func serverComms_priceSettings_local () {
        let subscriptionNeedsSet = arduinoFunctions.serverComms_priceSettings()
        if (subscriptionNeedsSet) {
            self.view.addSubview(subscribeButton)
        }
        self.set_priceLabels()
    }
    
    func resetPhoneNumber() {
    }
    
    func unlock_timeSpecific() {
        var intermediatelockState_transmitted = true
        let hours = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let overallMinutes = hours * 60 + minutes
        
        //  --  Site-Specific Unlock Times:  Server-Specified --  //
        for siteSpecificUnlockTime in siteSpecificUnlockTimes {
            let startM = siteSpecificUnlockTime[0]
            let endM = siteSpecificUnlockTime[1]
            
            // Loops through all time bookends, and only engages one un/lock command
            if ((( overallMinutes >= startM ) && ( overallMinutes <= endM ))) {
                intermediatelockState_transmitted = intermediatelockState_transmitted && false
            }
            if ((( overallMinutes < startM ) || ( overallMinutes > endM ))) {
                intermediatelockState_transmitted = intermediatelockState_transmitted && true
            }
        }
        // Prevent interrupts due to payment or master unlocking
        if (paymentOr_masterUnlock == false) {
            // Verify if a lock or unlock command is needed
            if (intermediatelockState_transmitted != lockState_transmitted) {
                if (intermediatelockState_transmitted == true) { // Locking is needed
                    NSLog("<LOCK_TIMESPECIFIC> = LOCK")
                    timeSpecificUnlocked = false
                    arduinoFunctions.arduinoLock_lock()
                    set_priceLabels()
                    swipeImage_view.isHidden = false
                    instructionsText.isHidden = false
                    set_priceLabels()
                    paymentReset()
                }
                else { // Unlocking is needed
                    NSLog("<LOCK_TIMESPECIFIC> = UNLOCK")
                    timeSpecificUnlocked = true
                    arduinoFunctions.arduinoLock_unlock()
                    unlocked_priceLabel()
                }
            }
        }
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paymentReset () {
    }
    
    func subscription_priceLabel() {
    }
    
    func noSubscription_priceLabel() {
        let string = "$" + String(format: "%.2f", payment_price1)
        let attributedString = NSMutableAttributedString(string: string as String)
        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: screenSize.height*(12/170))!] as [String : Any]
        attributedString.addAttributes(secondAttributes, range: NSMakeRange(0, string.characters.count))
        priceLabel.attributedText = attributedString
        self.view.setNeedsDisplay()
    }
    
    func unlocked_priceLabel() {
    }
    
    func subscriptionPriceLabel() {
    }
    
    func processSubscription() {
    }
    
    func set_priceLabels() {
        if (timeSpecificUnlocked == true) {
            self.unlocked_priceLabel()
        }
        else if (subscription_priceSet) {
            self.subscription_priceLabel()
            self.view.addSubview(subscribeButton)
        }
        else {
            self.noSubscription_priceLabel()
            self.removeSubview(tag: subscribeButton.tag)
        }
    }
    
    func removeSubview(tag: Int){
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func phoneExists() {
    }
    
    func phoneExists_return(responseString: String) {
    }
    
    func resetinstructionsText() {
    }
    
    func registerUser() -> String {
        return ""
    }
    
//    // MARK: Begin RscMgr functions
//    
//    // serial cable connection detected
//    func cableConnected(_ protocolString: String!) {
//        rscMgr.open()
//        rscMgr.setBaud(baudRate)
//    }
//    
//    // serial cable disconnection detected
//    func cableDisconnected() {
//        // Could display something that relays it's in error
//    }
//    
//    // a change has been made to the port configuration; needed to conform to RscMgrDelegate protocol
//    func portStatusChanged() {
//        
//    }
//    
//    //    func extractAfterStart ( arduinoRx_message: String, startString: String ) -> String {
//    //        var arduinoRx_message = arduinoRx_message
//    //        if (arduinoRx_message.range(of:startString) == nil) {
//    //            return "error"
//    //        }
//    //
//    //        if ((arduinoRx_message.components(separatedBy: startString).count) == 1) {
//    //            arduinoRx_message = ""
//    //        }
//    //        else {
//    //            arduinoRx_message = arduinoRx_message.components(separatedBy: startString)[1]
//    //        }
//    //        return arduinoRx_message
//    //    }
//    
//    // data is ready to read
//    func readBytesAvailable(_ length: UInt32) {
//        
//        let data: Data = rscMgr.getDataFromBytesAvailable()   // note: may also process text using rscMgr.getStringFromBytesAvailable()
//        let message = String(data: data, encoding: String.Encoding.utf8)!
//        
//        // This causes large log files
//        // print(message)
//        
//        arduinoRx_message += message
//        arduinoRx_message = (arduinoRx_message as NSString).replacingOccurrences(of: "?", with: "")
//        NSLog("<ARDUINO_IN> = " + arduinoRx_message)
//        
//        let _ = processIncomingMessage()
//        
//    }
//    
//    // MARK: End of RscMgr functions
}
