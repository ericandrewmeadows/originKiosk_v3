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

class paymentViewController: UIViewController, RscMgrDelegate {
    
    // Unit Testing
    var unitTesting = false
    
    // RscMgr
    var rscMgr:  RscMgr!     // RscMgr handles the serial communication
    
    // Regular Functionality
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var arduinoRx_message = String()
    
    
    // Keypad
    var keypadVersion = "phoneNumber";
    
    // Phone Number Information
    var phoneNumString: [Character] = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
    var phoneNumString_exact: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    var phoneNumStringCount = 0
    
    // Master Unlock
    let masterUnlockString = "CC062616"
    var input_last8 = [" ", " ", " ", " ", " ", " ", " ", " "]
    
    let disabledColor = UIColor(
        red: 240/255.0,
        green: 240/255.0,
        blue: 240/255.0,
        alpha: 1.0)
    let enabledColor = UIColor.black
    
    let screenSize: CGRect = UIScreen.main.bounds
    var initialLoad = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
        
        // rscMgr
        rscMgr = RscMgr()
        rscMgr.setDelegate(self)
        rscMgr.enableExternalLogging(true)
        
        // Software revision
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        print(nsObject as! String)
        
        defaults.set("3.0.0", forKey: "version")
        
        // Company name is device name <- Ease of setup of multiple devices
        defaults.set(UIDevice.current.name, forKey: "location")
        
        configPinPad(screenSize: self.screenSize)
        
        // Subscription setup
        subscribeButton.addTarget(self, action: #selector(processSubscription), for: .touchUpInside)
        
        view.layer.addSublayer(shapeLayer)
        
        for uiElement in [phoneNumberDisplay, paymentSuccessfulLabel, checkMark, subscribeDetails, subscribeLabel, priceLabel, subscribeLabel,
                          instructionsText, enterYourPhoneNumber,
                          instructionsLabel1,instructionsLabel2,instructionsLabel3,instructionsLabel4] {
            view.addSubview(uiElement)
        }
        
        for uiElement in [swipeImage_view, logoImage_view] {
            view.addSubview(uiElement)
        }
        
        for button in [button1,button2,button3,button4,button5,button6,button7,button8,button9,button0,pinpad_lowerLeft,pinpad_lowerRight,
                       clearPhoneButton,
                       instructionsButton1,instructionsButton2,instructionsButton3,instructionsButton4] {
            button.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
            view.addSubview(button)
        }
        
        for layer in [priceLineLayer, abovePhoneLayer, belowPhoneLayer, leftRightDividerLineLayer] {
            self.view.layer.addSublayer(layer)
        }
        
        clearPhoneButton.addTarget(self, action: #selector(clearPhoneNumber), for: .touchUpInside)
        self.view.addSubview(clearPhoneButton)
        
        set_priceLabels()
        
        if (lockState) {
            sendLockMessage(rscMgr: rscMgr)
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
    
    func clearPhoneNumber () {
        // Reset arrays, call function to reset phone display
    }
    
    func serverComms_siteSpecificUnlockTimes_local () {
        serverComms_siteSpecificUnlockTimes()
    }
    func unlock_timeSpecific_local () {
        unlock_timeSpecific()
    }
    func serverComms_freezerSettings_local () {
        serverComms_freezerSettings(rscMgr: rscMgr)
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
    
    func successfulPayment () {
    }
    
    func unsuccessfulPayment () {
    }
    
    func hide_greenCircle_andCheck () {
    }
    
    func numpadPressed(sender: UIButton) {
    }
    
    func unlock_timeSpecific() {
        var intermediateLockState = true
        let hours = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let overallMinutes = hours * 60 + minutes
        
        //  --  Site-Specific Unlock Times:  Server-Specified --  //
        for siteSpecificUnlockTime in siteSpecificUnlockTimes {
            let startM = siteSpecificUnlockTime[0]
            let endM = siteSpecificUnlockTime[1]
            
            // Loops through all time bookends, and only engages one un/lock command
            if ((( overallMinutes >= startM ) && ( overallMinutes <= endM ))) {
                intermediateLockState = intermediateLockState && false
            }
            if ((( overallMinutes < startM ) || ( overallMinutes > endM ))) {
                intermediateLockState = intermediateLockState && true
            }
        }
        // Prevent interrupts due to payment or master unlocking
        if (paymentOr_masterUnlock == false) {
            // Verify if a lock or unlock command is needed
            if (intermediateLockState != lockState) {
                if (intermediateLockState == true) { // Locking is needed
                    NSLog("<+> timeSpecific Lock")
                    timeSpecificUnlocked = false
                    sendLockMessage(rscMgr: rscMgr)
                    set_priceLabels()
                    swipeImage_view.isHidden = false
                    instructionsText.isHidden = false
                    hidePinPad_false()
                    set_priceLabels()
                    paymentReset()
                }
                else { // Unlocking is needed
                    NSLog("< > timeSpecific Unlock")
                    timeSpecificUnlocked = true
                    sendUnlockMessage(rscMgr: rscMgr)
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
    
    // MARK: Begin RscMgr functions
    
    // serial cable connection detected
    func cableConnected(_ protocolString: String!) {
        rscMgr.open()
        rscMgr.setBaud(baudRate)
    }
    
    // serial cable disconnection detected
    func cableDisconnected() {
        // Could display something that relays it's in error
    }
    
    // a change has been made to the port configuration; needed to conform to RscMgrDelegate protocol
    func portStatusChanged() {
        
    }
    
    func extractAfterStart ( arduinoRx_message: String, startString: String ) -> String {
        var arduinoRx_message = arduinoRx_message
        if (arduinoRx_message.range(of:startString) == nil) {
            return "error"
        }
        
        if ((arduinoRx_message.components(separatedBy: startString).count) == 1) {
            arduinoRx_message = ""
        }
        else {
            arduinoRx_message = arduinoRx_message.components(separatedBy: startString)[1]
        }
        return arduinoRx_message
    }
    
    // data is ready to read
    func readBytesAvailable(_ length: UInt32) {
        
        let data: Data = rscMgr.getDataFromBytesAvailable()   // note: may also process text using rscMgr.getStringFromBytesAvailable()
        let message = String(data: data, encoding: String.Encoding.utf8)!
        
        // This causes large log files
        // print(message)
        
        arduinoRx_message += message
        arduinoRx_message = (arduinoRx_message as NSString).replacingOccurrences(of: "?", with: "")
        NSLog(arduinoRx_message)
        
        let _ = processIncomingMessage()
        
    }
    
    // MARK: End of RscMgr functions
    
    func processIncomingMessage() -> String {
        var tempString = ""
        var start_startPos = 0
        var finish_startPos = 0
        
        if ((arduinoRx_message.range(of:"</CCINFO>") != nil) && (arduinoRx_message.range(of: "<CCINFO>") != nil)) {
            if let range = arduinoRx_message.range(of: "<CCINFO>") {
                start_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                            to: range.lowerBound)
            }
            if let range = arduinoRx_message.range(of: "</CCINFO>") {
                finish_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                             to: range.lowerBound)
            }
            
            if (start_startPos < finish_startPos) {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "<CCINFO>")[1]
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</CCINFO>")[0]
                
                arduinoRx_message = arduinoRx_message.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // url-encoded string
                methodToExecute = "ccInfo"
                ccInfo_chargeUser = 1;
                
                tempString = arduinoRx_message
                
                if (!unitTesting) {
                    let processStatus = processPayment(method: methodToExecute, arduinoRx_message: arduinoRx_message, ccInfo_chargeUser: 1, subscription: 0)
                    if (processStatus == "Successful") {
                        paymentOr_masterUnlock = true
                        self.successfulPayment()
                    }
                    else if (processStatus == "Swipe Again") {
                    }
                    else if (processStatus == "Failed") {
                        paymentOr_masterUnlock = false
                        self.unsuccessfulPayment()
                    }
                }
                
                arduinoRx_message = ""
            }
            else {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</CCINFO>")[1]
                tempString = arduinoRx_message
            }
        }
        else if ((arduinoRx_message.range(of:"</LOCK>") != nil) && (arduinoRx_message.range(of: "<LOCK>") != nil)) {
            if let range = arduinoRx_message.range(of: "<LOCK>") {
                start_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                            to: range.lowerBound)
            }
            if let range = arduinoRx_message.range(of: "</LOCK>") {
                finish_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                             to: range.lowerBound)
            }
            
            if (start_startPos < finish_startPos) {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "<LOCK>")[1]
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</LOCK>")[0]
                
                tempString = arduinoRx_message
                if (!unitTesting) {
                    serverComms_lockCommunication(lockString: arduinoRx_message)
                }
                
                arduinoRx_message = ""
            }
            else {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</LOCK>")[1]
                tempString = arduinoRx_message
            }
        }
        else if ((arduinoRx_message.range(of:"</FREEZER>") != nil) && (arduinoRx_message.range(of: "<FREEZER>") != nil)) {
            if let range = arduinoRx_message.range(of: "<FREEZER>") {
                start_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                            to: range.lowerBound)
            }
            if let range = arduinoRx_message.range(of: "</FREEZER>") {
                finish_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                             to: range.lowerBound)
            }
            
            if (start_startPos < finish_startPos) {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "<FREEZER>")[1]
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</FREEZER>")[0]
                
                tempString = arduinoRx_message
                if (!unitTesting) {
                    serverComms_freezerCommunication(freezerString: arduinoRx_message)
                }
                
                arduinoRx_message = ""
            }
            else {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</FREEZER>")[1]
                tempString = arduinoRx_message
            }
        }
        else if ((arduinoRx_message.range(of:"</KEEPALIVE>") != nil) && (arduinoRx_message.range(of: "<KEEPALIVE>") != nil)) {
            if let range = arduinoRx_message.range(of: "<KEEPALIVE>") {
                start_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                            to: range.lowerBound)
            }
            if let range = arduinoRx_message.range(of: "</KEEPALIVE>") {
                finish_startPos = arduinoRx_message.distance(from: arduinoRx_message.startIndex,
                                                             to: range.lowerBound)
            }
            
            if (start_startPos < finish_startPos) {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "<KEEPALIVE>")[1]
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</KEEPALIVE>")[0]
                
                tempString = arduinoRx_message
                if (!unitTesting) {
                    serverComms_keepAliveCommunication()
                }
                arduinoRx_message = ""
            }
            else {
                arduinoRx_message = arduinoRx_message.components(separatedBy: "</KEEPALIVE>")[1]
                tempString = arduinoRx_message
            }
        }
        return tempString
    }
    
    func paymentReset () {
    }
    
    func subscription_priceLabel() {
    }
    
    func noSubscription_priceLabel() {
        let string = "$" + String(format: "%.2f", payment_price1)
        let attributedString = NSMutableAttributedString(string: string as String)
        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!] as [String : Any]
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
}

extension String {
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return self[startIndex...endIndex]
        }
    }
}

extension UILabel {
    /**
     Set Text With animation
     
     - parameter text:     String?
     - parameter duration: NSTimeInterval?
     */
    public func setTextAnimation(text: String? = nil, color: UIColor? = nil, duration: TimeInterval?, completion:(()->())? = nil) {
        UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = text ?? self.text
            self.textColor = color ?? self.textColor
        }) { (finish) in
            if finish { completion?() }
        }
    }
}

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension String {
    func substring(from: Int) -> String? {
        guard from < self.characters.count else { return nil }
        let fromIndex = index(self.startIndex, offsetBy: from)
        return substring(from: fromIndex)
    }
}

extension Array {
    
    func shiftRight( amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount: amount)
    }
}
