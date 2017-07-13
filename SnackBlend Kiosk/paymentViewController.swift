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
        
        setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
        
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
        
        configPinPad()
        
        // Subscription setup
        subscribeButton.addTarget(self, action: #selector(processSubscription), for: .touchUpInside)
        
        for layer in [successfulPayment_circle,processingPayment_circle] {
            view.layer.addSublayer(layer)
        }
        
        for uiElement in [phoneNumberDisplay, subscribeDetails, subscribeLabel, priceLabel, subscribeLabel,
                          instructionsText, enterYourPhoneNumber,
                          instructionsLabel1,instructionsLabel2,instructionsLabel3,instructionsLabel4,
                          processingPayment_label,processingPayment_processingIcon,
                          successfulPayment_label,successfulPayment_checkMark,
                          smsReceiptLabel] {
            view.addSubview(uiElement)
        }
        
        for uiElement in [swipeImage_view, logoImage_view, receiptImage_view, backArrowImage_view] {
            view.addSubview(uiElement)
        }
        for button in [button1,button2,button3,button4,button5,button6,button7,button8,button9,button0,pinpad_lowerLeft,pinpad_lowerRight,
                       clearPhoneButton,
                       receiptYes, receiptNo] {
            button.addTarget(self, action: #selector(numpadPressed_local), for: .touchUpInside)
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
        for button in [receiptYes, receiptNo] {
            button.addTarget(self, action: #selector(receiptYesNo), for: .touchUpInside)
        }
        
        clearPhoneButton.addTarget(self, action: #selector(clearPhoneNumber_local), for: .touchUpInside)
        self.view.addSubview(clearPhoneButton)
        
        set_priceLabels()
        
        if (lockState_transmitted) {
            sendLockMessage()
        }
        
        view.setNeedsDisplay()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initialLoad = true
        
        serverComms_priceSettings_local()
//         DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
//             // Landscape Orientation - Required
//             setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
//             timer_setOrientation_landscapeLeft = Timer.scheduledTimer(timeInterval: timer_setOrientation_interval, target: self, selector: #selector(self.setOrientation_landscapeLeft_andBrightnessFull_andNoLock_local), userInfo: nil, repeats: true)

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
    
    func sendUnlockMessage_local () {
        sendUnlockMessage()
    }
    
    func receiptYesNo (sender: UIButton) {
        // sender.backgroundColor = UIColor.black
    }
    
    func menuItemsTouched (sender: UIButton) {
        print("Logo Touched - " + String(sender.tag))
        var inputVal = " "
        if (sender.tag == 0) {
            inputVal = "C"
            // successfulPayment_local()
            processingPayment_local()
        }
        else {
            inputVal = String(sender.tag)
        }
        input_last6[0] = inputVal
        input_last6 = input_last6.shiftRight()
        let printString = input_last6.joined(separator: "")
        print(printString + " == " + masterUnlockString + " = " + String(printString == masterUnlockString))
        // When true, issue unlock
    }
    
    func clearPhoneNumber_local () {
        // Reset arrays, call function to reset phone display
        clearPhoneNumber()
    }
    
    func serverComms_siteSpecificUnlockTimes_local () {
        serverComms_siteSpecificUnlockTimes()
    }
    func unlock_timeSpecific_local () {
        unlock_timeSpecific()
    }
    func serverComms_freezerSettings_local () {
        serverComms_freezerSettings()
    }
    func serverComms_priceSettings_local () {
        let subscriptionNeedsSet = serverComms_priceSettings()
        if (subscriptionNeedsSet) {
            self.view.addSubview(subscribeButton)
        }
        self.set_priceLabels()
    }
    
    func setOrientation_landscapeLeft_andBrightnessFull_andNoLock_local () {
        setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
    }
    
    func resetPhoneNumber() {
    }
    
    func processingPayment_local () {
        processingPayment_timer = Timer.scheduledTimer(timeInterval: processingPayment_timeInterval, target: self, selector: #selector(processingPayment_displayUpdate_local), userInfo: nil, repeats: true)
    }
    
    func processingPayment_displayUpdate_local () {
        processingPayment_displayUpdate()
    }
    
    func successfulPayment_local () {
        successfulPayment()
    }
    
    func unlockTimer_timeRemaining_local () {
        unlockTimer_timeRemaining()
    }
    
    func unsuccessfulPayment_local () {
    }
    
    func hide_greenCircle_andCheck () {
    }
    
    func numpadPressed_local(sender: UIButton) {
        numpadPressed(sender: sender)
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
                    sendLockMessage()
                    set_priceLabels()
                    swipeImage_view.isHidden = false
                    instructionsText.isHidden = false
                    hidePinPad_false()
                    set_priceLabels()
                    paymentReset()
                }
                else { // Unlocking is needed
                    NSLog("<LOCK_TIMESPECIFIC> = UNLOCK")
                    timeSpecificUnlocked = true
                    sendUnlockMessage()
                    unlocked_priceLabel()
                }
            }
        }
    }
    
    func hidePinPad_true() {
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
        button6.isHidden = true
        button7.isHidden = true
        button8.isHidden = true
        button9.isHidden = true
        button0.isHidden = true
        pinpad_lowerLeft.isHidden = true
        pinpad_lowerRight.isHidden = true
    }
    
    func hidePinPad_false() {
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
        button6.isHidden = false
        button7.isHidden = false
        button8.isHidden = false
        button9.isHidden = false
        button0.isHidden = false
        pinpad_lowerLeft.isHidden = false
        pinpad_lowerRight.isHidden = false
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
