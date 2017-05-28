//
//  ViewController.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 3/1/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit
import CoreBluetooth

let paymentAddress = "https://io.calmlee.com/userExists.php"
let phoneExistsAddress = "https://io.calmlee.com/phoneExists.php"
let pinExistsAddress = "https://io.calmlee.com/pinExists.php"
let pinCheckAddress = "https://io.calmlee.com/hashCheck.php"
let registerNewUserAddress = "https://io.calmlee.com/paymentPosting_GET.php"
//let paymentAddress = "https://io.calmlee.com/userExists_stripeTestMode.php"

let baudRate: Int32 = 9600      // baud rate

class ViewController: UIViewController, BluetoothSerialDelegate, RscMgrDelegate {
    
    // RscMgr
    var rscMgr:  RscMgr!     // RscMgr handles the serial communication
    
    let defaults = UserDefaults.standard
    
    // Bluetooth Functionality
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var selectedPeripheral: CBPeripheral?
    var connectTimer: Timer?
    var scanTimeoutTimer: Timer?
    var sendUnlockTimer: Timer?
    let timeToRelock = 20.0
    var bluetoothStatus: String?
    
    // Regular Functionality
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var bluetoothRx_array = String()
    
    let successTransition = 5.0
    let registrationTransition = 8.0
    
    // Keypad
    var keypadVersion = "phoneNumber";
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let button5 = UIButton()
    let button6 = UIButton()
    let button7 = UIButton()
    let button8 = UIButton()
    let button9 = UIButton()
    let button0 = UIButton()
    let buttonDel = UIButton()
    let buttonVideo = UIButton()
    
    // Display Elements
    var logoImage_view = UIImageView()
    var swipeImage_view = UIImageView()
    var pinPadImage_view = UIImageView()
    let keurigLabel = UILabel()
    
    
    let payButton = UIButton()
    let subscribeButton = UIButton()
    let priceLabel = UILabel()
    let subscribeLabel = UILabel()
    let subscribeDetails = UILabel()
    
    let phoneNumberDisplay = UILabel()
    var phoneNumString: [Character] = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
    var phoneNumString_exact: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    var phoneNumStringCount = 0
    
    // Master Unlock
    let masterUnlockString = "CC062616"
    var input_last8 = [" ", " ", " ", " ", " ", " ", " ", " "]
    var printString = "      "
    
    // PIN Code Entry
    let pinLength = 4;
    var pinNumStringCount = 0
    let pinMaxTry = 3
    var pinTryCount = 0
    var pinRegistration = false;
    var pinString_display: [Character] = ["-", "-", "-", "-"]
    var pinString: [Character] = ["-", "-", "-", "-"]
    var pinString_validate: [Character] = ["-", "-", "-", "-"]
    var pinString_str = ""
    
    // Subscription Info
    var subscription = 0
    
    // Epona
    // Credit Card Swipe Info
    let version_url = "&version=1.1"
    var cardToken = ""
    var firstName = ""
    var lastName = ""
    var fName_url = ""
    var lName_url = ""
    var waitingForCC = false;
    var methodToExecute = "";
    var ccInfo_chargeUser = 0;
    
    // iPad registration
    var localRegistration = false;
    var swipeImage = UIImage()
    var pinPadImage = UIImage()
    
    let shapeLayer = CAShapeLayer()
    let checkMark = UILabel()
    let paymentSuccessfulLabel = UILabel()
    
    let disabledColor = UIColor(
        red: 240/255.0,
        green: 240/255.0,
        blue: 240/255.0,
        alpha: 1.0)
    let enabledColor = UIColor.black
    
    func resetPhoneNumber() {
        phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
        phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
        phoneNumStringCount = 0
        DispatchQueue.main.async {
            //            self.phoneNumberDisplay.text = "Enter your phone number"
            self.phoneNumberDisplay.text = " "
        }
        self.view.setNeedsDisplay()
    }
    
    func disablePaymentButtons() {
        self.button1.isUserInteractionEnabled = false
        self.button3.isUserInteractionEnabled = false
        self.button4.isUserInteractionEnabled = false
        self.button5.isUserInteractionEnabled = false
        self.button6.isUserInteractionEnabled = false
        self.button7.isUserInteractionEnabled = false
        self.button8.isUserInteractionEnabled = false
        self.button9.isUserInteractionEnabled = false
        self.button0.isUserInteractionEnabled = false
        
        self.button1.setTitleColor(disabledColor, for: .normal)
        self.button2.setTitleColor(disabledColor, for: .normal)
        self.button3.setTitleColor(disabledColor, for: .normal)
        self.button4.setTitleColor(disabledColor, for: .normal)
        self.button5.setTitleColor(disabledColor, for: .normal)
        self.button6.setTitleColor(disabledColor, for: .normal)
        self.button7.setTitleColor(disabledColor, for: .normal)
        self.button8.setTitleColor(disabledColor, for: .normal)
        self.button9.setTitleColor(disabledColor, for: .normal)
        self.button0.setTitleColor(disabledColor, for: .normal)
        
        self.pinPadImage_view.isHidden = true
        self.swipeImage_view.isHidden = true
        self.keurigLabel.isHidden = true
        
//        self.payButton.isHidden = false
        
        self.view.setNeedsDisplay()
//        self.subscribeButton.isHidden = false
//        self.subscribeLabel.isHidden = false
//        self.subscribeDetails.isHidden = false
        //        self.priceLabel.isHidden = false
        
    }
    
    func enablePaymentButtons() {
        self.button1.isUserInteractionEnabled = true
        self.button3.isUserInteractionEnabled = true
        self.button4.isUserInteractionEnabled = true
        self.button5.isUserInteractionEnabled = true
        self.button6.isUserInteractionEnabled = true
        self.button7.isUserInteractionEnabled = true
        self.button8.isUserInteractionEnabled = true
        self.button9.isUserInteractionEnabled = true
        self.button0.isUserInteractionEnabled = true
        
        self.button1.setTitleColor(enabledColor, for: .normal)
        self.button2.setTitleColor(enabledColor, for: .normal)
        self.button3.setTitleColor(enabledColor, for: .normal)
        self.button4.setTitleColor(enabledColor, for: .normal)
        self.button5.setTitleColor(enabledColor, for: .normal)
        self.button6.setTitleColor(enabledColor, for: .normal)
        self.button7.setTitleColor(enabledColor, for: .normal)
        self.button8.setTitleColor(enabledColor, for: .normal)
        self.button9.setTitleColor(enabledColor, for: .normal)
        self.button0.setTitleColor(enabledColor, for: .normal)
        
//        self.pinPadImage_view.isHidden = false
//        self.swipeImage_view.isHidden = false
//        self.keurigLabel.isHidden = false
        
//        self.payButton.isHidden = true
        self.subscribeButton.isHidden = true
        self.subscribeLabel.isHidden = true
        self.subscribeDetails.isHidden = true
        
        //        self.priceLabel.isHidden = true
    }
    
    func successfulPayment () {
        
        if (printString == masterUnlockString) {
            print("Master Unlock")
        }
        else {
            print("Successful Payment")
        }
        
        // Reset PIN, phoneNumber, etc
        
        DispatchQueue.main.async {
//            self.payButton.isHidden = true
            self.pinPadImage_view.isHidden = true
            self.swipeImage_view.isHidden = true
            self.keurigLabel.isHidden = true
//            self.subscribeButton.isHidden = true
            self.priceLabel.isHidden = true
//            self.subscribeLabel.isHidden = true
//            self.subscribeDetails.isHidden = true
            self.buttonVideo.setTitle("Cancel", for: .normal)
//            self.payButton.setTitle("Pay Now", for: .normal)
            self.subscribeButton.isHidden = true
            self.cardToken = ""
            
            UIView.animate(withDuration: self.successTransition,
                           animations: {
                            self.shapeLayer.isHidden = false
                            self.checkMark.isHidden = false
                            self.paymentSuccessfulLabel.isHidden = false
                            
                            let animcolor = CABasicAnimation(keyPath: "fillColor")
                            animcolor.fromValue = UIColor.clear.cgColor
                            animcolor.toValue = UIColor(
                                red: 75/255.0,
                                green: 181/255.0,
                                blue: 67/255.0,
                                alpha: 1.0).cgColor
                            animcolor.duration = self.successTransition
                            animcolor.repeatCount = 0
                            animcolor.autoreverses = false
                            animcolor.isRemovedOnCompletion = false
                            animcolor.fillMode = kCAFillModeForwards
                            self.shapeLayer.add(animcolor, forKey: "fillColor")
                            
            })
            
            self.paymentSuccessfulLabel.textColor = .clear
            self.paymentSuccessfulLabel.setTextAnimation(color: UIColor(
                red: 75/255.0,
                green: 181/255.0,
                blue: 67/255.0,
                alpha: 1.0),
                                                         duration: self.successTransition)
            
            // Arduino
            // Unlock Freezer
            if (self.defaults.bool(forKey: "arduinoInstalled")) {
                self.sendUnlockMessage()
                var lockAgain = Timer.scheduledTimer(timeInterval: self.timeToRelock, target: self, selector:  Selector("sendLockMessage"), userInfo: nil, repeats: false)
            }
            
            var payAndCheck_normalAgain = Timer.scheduledTimer(timeInterval: self.successTransition, target: self, selector:  Selector("hide_greenCircle_andCheck"), userInfo: nil, repeats: false)
            
        }
    }
    
    func registrationRequired () {
        print("Registering")
        
        DispatchQueue.main.async {
            self.checkMark.text = "?"
            self.paymentSuccessfulLabel.text = "Registration SMS Sent"
//            self.payButton.isHidden = true
            self.subscribeButton.isHidden = true
            self.priceLabel.isHidden = true
            self.subscribeLabel.isHidden = true
            self.subscribeDetails.isHidden = true
//            self.payButton.setTitle("Pay Now", for: .normal)
            
            
            UIView.animate(withDuration: self.successTransition,
                           animations: {
                            self.shapeLayer.isHidden = false
                            self.checkMark.isHidden = false
                            self.paymentSuccessfulLabel.isHidden = false
                            
                            let animcolor = CABasicAnimation(keyPath: "fillColor")
                            animcolor.fromValue = UIColor.clear.cgColor
                            animcolor.toValue = UIColor(
                                red: 105/255.0,
                                green: 105/255.0,
                                blue: 105/255.0,
                                alpha: 1.0).cgColor
                            animcolor.duration = self.successTransition
                            animcolor.repeatCount = 0
                            animcolor.autoreverses = false
                            animcolor.isRemovedOnCompletion = false
                            animcolor.fillMode = kCAFillModeForwards
                            self.shapeLayer.add(animcolor, forKey: "fillColor")
                            
            })
            
            self.paymentSuccessfulLabel.textColor = .clear
            self.paymentSuccessfulLabel.setTextAnimation(color: UIColor(
                red: 105/255.0,
                green: 105/255.0,
                blue: 105/255.0,
                alpha: 1.0),
                                                         duration: self.successTransition)
            
            var timer = Timer.scheduledTimer(timeInterval: self.registrationTransition, target: self, selector:  Selector("hide_greenCircle_andCheck"), userInfo: nil, repeats: false)
            
        }
    }
    
    func hide_greenCircle_andCheck () {
        UIView.animateKeyframes(withDuration: 0, delay: 0, options: [], animations: {
            self.shapeLayer.isHidden = true
            self.checkMark.isHidden = true
            self.paymentSuccessfulLabel.isHidden = true
            self.priceLabel.isHidden = false
            self.subscribeButton.isHidden = false
            self.resetPhoneNumber()
            self.enablePaymentButtons()
            self.paymentSuccessfulLabel.text = "Payment Successful"
            self.checkMark.text = "✓"
        }) { (finished) in
            if finished {
                self.paymentReset()
                self.resetKeurigLabel()
            }
        }
    }
    
    func numpadPressed(sender: UIButton) {
        // Epona
        // Need to configure for the PIN
        var inputVal = " "
        if (keypadVersion == "phoneNumber") {
            if (sender.titleLabel?.text == "Cancel") {
                paymentReset()
                inputVal = "C"
                //Arthena
//                sendUnlockMessage()
            }
            else if (sender.titleLabel?.text != "x") {
                inputVal = (sender.titleLabel?.text)!
                if phoneNumStringCount < 10 {
                    phoneNumString_exact[phoneNumStringCount] = Character((sender.titleLabel?.text)!)
                    phoneNumStringCount += 1
                    if phoneNumStringCount <= 3 {
                        phoneNumString[phoneNumStringCount] = Character((sender.titleLabel?.text)!)
                    }
                    else if phoneNumStringCount <= 6 {
                        phoneNumString[phoneNumStringCount+2] = Character((sender.titleLabel?.text)!)
                    }
                    else if phoneNumStringCount <= 10 {
                        phoneNumString[phoneNumStringCount+3] = Character((sender.titleLabel?.text)!)
                    }
                }
                phoneNumberDisplay.text = String(phoneNumString)
            }
            else {
                if phoneNumStringCount > 0 {
                    if phoneNumStringCount <= 3 {
                        phoneNumString[phoneNumStringCount] = " "
                    }
                    else if phoneNumStringCount <= 6 {
                        phoneNumString[phoneNumStringCount+2] = " "
                    }
                    else if phoneNumStringCount <= 10 {
                        phoneNumString[phoneNumStringCount+3] = " "
                    }
                    phoneNumStringCount -= 1
                    phoneNumString_exact[phoneNumStringCount] = " "
                    phoneNumberDisplay.text = String(phoneNumString)
                }
                if phoneNumStringCount == 0 {
                    phoneNumberDisplay.text = ""
                }
            }
            
            // Master Unlock
            input_last8[0] = inputVal
            input_last8 = input_last8.shiftRight()
            printString = input_last8.joined(separator: "")
            if (printString == masterUnlockString) {
                phoneNumberDisplay.text = ""
                successfulPayment()
            }
            
            if phoneNumStringCount == 10 {
                if ((!localRegistration) && (String(pinString) != "----")) {
                    self.disablePaymentButtons()
                    if (String(phoneNumString_exact) == "9377761657") {
                        buttonVideo.setTitle("Setup", for: .normal)
                    }
                }
                else {
                    // Epona
                    // Clear information that phone number is required
                    phoneExists()
                    
                }
            }
            else {
                self.enablePaymentButtons()
                buttonVideo.setTitle("Cancel", for: .normal)
            }
        }
        else if (keypadVersion == "PIN") {
//            pinNumStringCount
//            pinString
//            pinString_validate
            if (sender.titleLabel?.text == "Cancel") {
                paymentReset()
            }
            else if sender.titleLabel?.text != "x" {
                if (pinNumStringCount < pinLength) {
                    pinString[pinNumStringCount] = Character((sender.titleLabel?.text)!)
                    pinString_display[pinNumStringCount] = "•"//Character((sender.titleLabel?.text)!)
                    pinNumStringCount += 1
                }
                phoneNumberDisplay.text = String(pinString_display)
            }
            else {
                if (pinNumStringCount > 0) {
                    pinNumStringCount -= 1
                    pinString[pinNumStringCount] = "-"
                    pinString_display[pinNumStringCount] = "-"
                    phoneNumberDisplay.text = String(pinString_display)
                }
            }
            if pinNumStringCount == pinLength {
                
                if (!pinRegistration) {
                    pinString_validate = pinString;
                    
                    // Set both to each other
                    keypadVersion = "phoneNumber";
                }
                
                var str_pinStringValidate = String(pinString_validate)
                var str_pinString = String(pinString)
                print((str_pinString != str_pinStringValidate) && pinRegistration)
                
                if (String(pinString_validate) == "----") {
                    pinString_validate = pinString;
                    
                    self.logoImage_view.isHidden = true
                    self.priceLabel.isHidden = true
                    
                    
                    let formattedString = NSMutableAttributedString()
                    formattedString.append(NSAttributedString(string: "Re-enter your "))
                    let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                    var text = "PIN "
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    formattedString.append(NSAttributedString(string: "\nto "))
                    text = "Finish" // "Swipe Credit Card "
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    self.keurigLabel.attributedText = formattedString
                    
                    
                    pinString = ["-","-","-","-"];
                    pinString_display =  ["-","-","-","-"];
                    phoneNumberDisplay.text = String(pinString_display);
                    pinNumStringCount = 0;
                }
                else if ((String(pinString_validate) == String(pinString)) && pinRegistration) {
                    // Epona
                    // PIN codes match
                    print("CODES MATCH");
                    pinString_str = String(pinString)
                    phoneNumberDisplay.text = "";
                    keypadVersion == "phoneNumber";
                    // Store in database
                    
                    // User needs to swipe credit card
                    if (cardToken == "") {
                        // Epona 999
                        self.swipeImage_view.isHidden = false
                        self.pinPadImage_view.isHidden = true
                        
                        
                        let formattedString = NSMutableAttributedString()
                        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                        var text = "Swipe "
                        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                        formattedString.append(NSAttributedString(string: "your "))
                        text = "Credit Card "
                        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                        formattedString.append(NSAttributedString(string: "\nto Finish"))
                        self.keurigLabel.attributedText = formattedString

                        
                        
                        waitingForCC = true
                        print("waitingForCC")
//                        phoneNumberDisplay.text = "Swipe Credit Card";
                    }
                    else {
                        registerUser()
                        print("\n-----\nReached somehow\n-----\n")
                    }
                    pinString_display =  ["-","-","-","-"];
                    pinNumStringCount = 0;
                }
                else if ((str_pinString != str_pinStringValidate) && pinRegistration) {
                    print("PINs don't match")
                    pinString = ["-","-","-","-"];
                    pinString_validate = ["-","-","-","-"];
                    pinString_display = ["-","-","-","-"];
                    pinNumStringCount = 0;
                    phoneNumberDisplay.text = String(pinString_display);
                    self.view.setNeedsDisplay()
                    
                    self.logoImage_view.isHidden = true
                    self.priceLabel.isHidden = true
                    
                    let formattedString = NSMutableAttributedString()
                    let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                    formattedString.append(NSAttributedString(string: "Oops...they didn't match!\nPlease "))
                    var text = "re-enter "
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    formattedString.append(NSAttributedString(string: "a "))
                    text = "PIN "
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    formattedString.append(NSAttributedString(string: "to Pay "))
                    self.keurigLabel.attributedText = formattedString
                }
                else if (!pinRegistration) {
//                    hashCheck()
                    processPayment(method: "PIN")
//                    methodToExecute = "PIN"
                    //                    self.payUsing_worldSelector()
//                    pinString = ["-","-","-","-"];
                    pinString_validate = ["-","-","-","-"];
                     pinString_display = ["-","-","-","-"];
                    phoneNumberDisplay.text = String(pinString_display);
                    pinNumStringCount = 0;
                }
                else {
                    // count invalid responses
                    pinTryCount += 1
                    if (pinTryCount == pinMaxTry) {
                        // Text user email link to reset password or reset instructions (manual email)
                    }
                }
//                pinRegistration = false;
            }
        }
    }
    let screenSize: CGRect = UIScreen.main.bounds
    var initialLoad = false
    
    var timeSpecific_locked = true
    var timer_hourSpecific: Timer?
    func unlock_timeSpecific() {
        let hours = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let overallMinutes = hours * 60 + minutes
        //        print(" -- " + String(overallMinutes) + " -- ")
        // Unlock times are from 730A - 930A
        let startM = 450
        let endM = 570
        //        if ((( overallMinutes >= 450 ) && ( overallMinutes <= 570 )) && (timeSpecific_locked)) {
        if ((( overallMinutes >= startM ) && ( overallMinutes <= endM )) && (timeSpecific_locked)) {
            timeSpecific_locked = false
            sendUnlockMessage()
            pinPadImage_view.isHidden = true
            swipeImage_view.isHidden = true
            keurigLabel.isHidden = true
            hidePinPad_true()
            unlockedPriceLabel()
        }
        //        if ((( overallMinutes < 450 ) || ( overallMinutes > 570 )) && (!timeSpecific_locked)) {
        if ((( overallMinutes < startM ) || ( overallMinutes > endM )) && (!timeSpecific_locked)) {
            timeSpecific_locked = true
            sendLockMessage()
            pinPadImage_view.isHidden = false
            swipeImage_view.isHidden = false
            keurigLabel.isHidden = false
            hidePinPad_false()
            originalPriceLabel()
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
        buttonDel.isHidden = true
        buttonVideo.isHidden = true
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
        buttonDel.isHidden = false
        buttonVideo.isHidden = false
    }
    
    func originalPriceLabel() {
        let string = "$4.49"
        var attributedString = NSMutableAttributedString(string: string as String)
        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!] as [String : Any]
        attributedString.addAttributes(secondAttributes, range: NSMakeRange(0, string.characters.count))
        priceLabel.attributedText = attributedString
        self.view.setNeedsDisplay()
        
    }
    
    func unlockedPriceLabel() {
        let string = "Unlocked"
        let greenColour = UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 1)
        var attributedString = NSMutableAttributedString(string: string as String)
        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!, NSForegroundColorAttributeName : greenColour] as [String : Any]
        attributedString.addAttributes(secondAttributes, range: NSMakeRange(0, string.characters.count))
        priceLabel.attributedText = attributedString
        self.view.setNeedsDisplay()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rscMgr
        rscMgr = RscMgr()
        rscMgr.setDelegate(self)
        rscMgr.enableExternalLogging(true)
        rscMgr.enableTxRxExternalLogging(true)
        
        // Software revision
        //        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        print(nsObject as! String)
        
        // Arduino
        // Load based upon setup value
        defaults.set(true, forKey: "arduinoInstalled")
        defaults.set("1.1", forKey: "version")
        
        // This can be remotely set
        defaults.set(UIDevice.current.name, forKey: "company")
        
        // Buttons
        let num_w = self.screenSize.width/8
        let num_h = self.screenSize.height/8
        
        // c#x
        let c1x = self.screenSize.width*(1/2 + 1/16)
        let c2x = self.screenSize.width*(1/2 + 1/16 + 1/8)
        let c3x = self.screenSize.width*(1/2 + 1/16 + 2/8)
        
        // r#y
        let r1y = self.screenSize.height*(1/4 + 1/8)
        let r2y = self.screenSize.height*(1/4 + 2/8)
        let r3y = self.screenSize.height*(1/4 + 3/8)
        let r4y = self.screenSize.height*(1/4 + 4/8)
        //        let r5y = self.screenSize.height*(1/8 + 5/8)
        
        //        let snackblendLogo = UILabel()
        //        snackblendLogo.frame = CGRect(x: 0,
        //                                      y: self.screenSize.height/12,
        //                                      width: self.screenSize.width,
        //                                      height: self.screenSize.width/4)
        //        snackblendLogo.textAlignment = NSTextAlignment.center
        //        snackblendLogo.font = UIFont(name: "Grand Hotel", size: snackblendLogo.frame.height)
        //        snackblendLogo.textColor = UIColor.white
        //        snackblendLogo.text = "SnackBlend"
        //        view.addSubview(snackblendLogo)
        //
        let imageName = "OriginLogo.png"
        //        let imageName = "snackblendLogo.png"
        let logoImage = UIImage(named: imageName)!
        logoImage_view = UIImageView(image: logoImage)
        //        imageView.frame = CGRect(x: 0, y: self.screenSize.height*(1/8),
        //                                 width: self.screenSize.width / 2,
        //                                 height: self.screenSize.height*(1/6))
        logoImage_view.frame = CGRect(x: self.screenSize.width / 16, y: self.screenSize.height*(1/8),
                                      width: self.screenSize.width * 3 / 8,
                                      height: self.screenSize.height*(1/6))
        logoImage_view.contentMode = .scaleAspectFit
        view.addSubview(logoImage_view)
        
        // Swipe and PIN Pad icons
        swipeImage = UIImage(named: "creditCardSwipe.png")!
        //        let swipeImage_view = UIImageView(image: swipeImage)
        swipeImage_view.image = swipeImage
        swipeImage_view.frame = CGRect(x: self.screenSize.width * (1/3 - 1/32),
                                       y: (r2y + r3y) / 2,
                                       width: self.screenSize.width / 16,
                                       height: self.screenSize.width / 16)
        swipeImage_view.contentMode = .scaleAspectFit
        swipeImage_view.isHidden = false;
        view.addSubview(swipeImage_view)
        
        pinPadImage = UIImage(named: "pinPadEntry.png")!
        //        let pinPadImage_view = UIImageView(image: pinPadImage)
        pinPadImage_view.image = pinPadImage
        pinPadImage_view.frame = CGRect(x: self.screenSize.width * (1/6 - 1/32),
                                        y: (r2y + r3y) / 2,
                                        width: self.screenSize.width / 16,
                                        height: self.screenSize.width / 16)
        pinPadImage_view.contentMode = .scaleAspectFit
        pinPadImage_view.isHidden = false
        view.addSubview(pinPadImage_view)
        
        // Keurig for Health Smoothies - Label
        //        let keurigLabel = UILabel()
        //        keurigLabel.frame = CGRect(x: self.screenSize.width / 16,
        //                                   y: imageView.frame.maxY + self.screenSize.height / 48,
        //                                   width: self.screenSize.width * 3 / 8,
        //                                   height: self.screenSize.height*(1/6))
        keurigLabel.frame = CGRect(x: self.screenSize.width / 24,
                                   y: r4y,
                                   width: self.screenSize.width * 5 / 12,
                                   height: self.screenSize.height / 6)
        keurigLabel.textAlignment = NSTextAlignment.center
        keurigLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        keurigLabel.font = UIFont(name: "Arial", size: self.screenSize.height*(7/170))
        keurigLabel.numberOfLines = 0
        keurigLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        //        keurigLabel.text = "Enter phone number or swipe credit card to begin"
        
        let formattedString = NSMutableAttributedString()
        formattedString.append(NSAttributedString(string: "Enter "))
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
        var text = "Phone Number "
        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
        formattedString.append(NSAttributedString(string: "\nor \n"))
        text = "Swipe Credit Card" // "Swipe Credit Card "
        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
        keurigLabel.attributedText = formattedString
        
        view.addSubview(keurigLabel)
        
        
//        priceLabel.frame = CGRect(x: self.screenSize.width / 8,
//                                 y: r3y - self.screenSize.height / 16,
//                                 width: self.screenSize.width / 4,
//                                 height: self.screenSize.height / 8)
        // Subscription setup
//        priceLabel.frame = CGRect(x: self.screenSize.width / 16,
//                                  y: r1y - self.screenSize.height / 10,//(imageView.frame.maxY + (r2y + r3y) / 2) / 2 - self.screenSize.height / 5,
//            width: self.screenSize.width * 3 / 8,
//            height: self.screenSize.height / 5)
//        priceLabel.text = "$2.99"
        
//        let price_formattedString = NSMutableAttributedString()
//        let price_attrs_stk:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(10/170))!]
//        let price_attrs_reg:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(10/170))!]
//        text = "$5.99"
//        price_formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:price_attrs_stk))
        
//        originalPriceLabel()
        
//        priceLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 2)
        
        
        priceLabel.frame = CGRect(x: self.screenSize.width / 8,
                                  y: r1y - self.screenSize.height / 16,//(imageView.frame.maxY + (r2y + r3y) / 2) / 2 - self.screenSize.height / 5,
            width: self.screenSize.width / 4,
            height: self.screenSize.height / 5)
//        priceLabel.text = "$4.49"
//        priceLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 2)
//        priceLabel.textColor = .black
        priceLabel.isHidden = false
        priceLabel.textAlignment = .center
        originalPriceLabel()
        view.addSubview(self.priceLabel)
        
        subscribeLabel.frame = CGRect(x: self.screenSize.width / 8,
                                      y: r3y - self.screenSize.height / 16,
                                      width: self.screenSize.width / 4,
                                      height: self.screenSize.height / 5)
        subscribeLabel.text = "$2.99"
        subscribeLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 2)
        subscribeLabel.textAlignment = .center
        subscribeLabel.textColor = .black
        subscribeLabel.isHidden = true
//        view.addSubview(self.subscribeLabel)
        
        subscribeDetails.frame = CGRect(x: self.screenSize.width / 24,
                                        y: r4y,
                                        width: self.screenSize.width * 5 / 12,
                                        height: self.screenSize.height / 6)
        subscribeDetails.textAlignment = NSTextAlignment.center
        subscribeDetails.baselineAdjustment = UIBaselineAdjustment.alignCenters
        subscribeDetails.font = UIFont(name: "Arial", size: self.screenSize.height*(7/170))
        subscribeDetails.numberOfLines = 0
        subscribeDetails.lineBreakMode = NSLineBreakMode.byWordWrapping
        subscribeDetails.text = "3 Smoothies / Week"
        subscribeDetails.isHidden = true
        view.addSubview(subscribeDetails)
        
        
        payButton.frame = CGRect(x: self.screenSize.width / 8,
                                 y: r2y - self.screenSize.height / 32,// r3y - self.screenSize.height / 16,
            width: self.screenSize.width / 4,
            height: self.screenSize.height / 16)
        payButton.setTitle("Pay Now", for: .normal)
        payButton.setTitleColor(.black, for: .normal)
        payButton.setTitleColor(UIColor(red: 75/255.0,
                                        green: 181/255.0,
                                        blue: 67/255.0,
                                        alpha: 1.0),
                                for: .highlighted)
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: payButton.frame.height / 2)
        payButton.backgroundColor = UIColor.white
        payButton.layer.borderColor = UIColor.black.cgColor
        payButton.layer.borderWidth = 6
        payButton.layer.cornerRadius = payButton.frame.height / 4//0.5 * button1.bounds.size.width
        payButton.clipsToBounds = true
        payButton.isHidden = true //Epona889
        payButton.addTarget(self, action: #selector(payUsing_worldSelector), for: .touchUpInside)
//        view.addSubview(self.payButton)
        
        subscribeButton.frame = CGRect(x: self.screenSize.width / 12 * 3.5,
                                       y: r2y - self.screenSize.height / 32,
                                       width: self.screenSize.width / 3 / 3,
                                       height: payButton.frame.height)
        subscribeButton.setTitle("Join and get it for: $3.99", for: .normal)
        
        // NOW
        let subscribeString = "Join"
        let title = NSMutableAttributedString(string: subscribeString as String)
        
        let sub_zeroAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: self.screenSize.height*(9/170))!] as [String : Any]
        let sub_oneAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(8/170))!] as [String : Any]
        title.addAttributes(sub_oneAttributes, range: NSMakeRange(0,title.length))
        subscribeButton.setAttributedTitle(title, for: .normal)
        // NOW
        
        subscribeButton.setTitleColor(.black, for: .normal)
        subscribeButton.setTitleColor(UIColor(red: 75/255.0,
                                              green: 181/255.0,
                                              blue: 67/255.0,
                                              alpha: 1.0),
                                      for: .highlighted)
        subscribeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: payButton.frame.height / 2)
        subscribeButton.backgroundColor = UIColor.white
        subscribeButton.layer.borderColor = UIColor.black.cgColor
        subscribeButton.layer.borderWidth = 3
        subscribeButton.layer.cornerRadius = payButton.frame.height / 4//0.5 * button1.bounds.size.width
        subscribeButton.clipsToBounds = true
        subscribeButton.isHidden = false
        subscribeButton.addTarget(self, action: #selector(processSubscription), for: .touchUpInside)
//        view.addSubview(self.subscribeButton)
        
        
        // Payment Successful - Label
        let circle_x = self.screenSize.width / 4
        let circle_r = self.screenSize.height / 16
        let circle_y = self.screenSize.height * 2 / 3 - circle_r
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: circle_x,
                               y: circle_y),
            radius: circle_r,
            startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        self.shapeLayer.path = circlePath.cgPath
        
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        //        self.shapeLayer.fillColor = UIColor(
        //                                        red: 75/255.0,
        //                                        green: 181/255.0,
        //                                        blue: 67/255.0,
        //                                        alpha: 1.0).cgColor
        self.shapeLayer.strokeColor = self.shapeLayer.fillColor
        self.shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(self.shapeLayer)
        
        // Check Mark icon
        self.checkMark.frame = CGRect(x: circle_x - circle_r,
                                      y: circle_y - circle_r,
                                      width: circle_r * 2,
                                      height: circle_r * 2)
        self.checkMark.textAlignment = NSTextAlignment.center
        self.checkMark.baselineAdjustment = UIBaselineAdjustment.alignCenters
        self.checkMark.font = UIFont(name: "Arial", size: self.screenSize.height*(1/12))
        self.checkMark.textColor = UIColor.white
        self.checkMark.numberOfLines = 0
        self.checkMark.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.checkMark.text = "✓"
        view.addSubview(self.checkMark)
        
        // Payment Successful - Label
        self.paymentSuccessfulLabel.frame = CGRect(x: self.screenSize.width / 16,
                                                   y: self.screenSize.height*(3/4 - 1/12),
                                                   width: self.screenSize.width * 3 / 8,
                                                   height: self.screenSize.height*(1/6))
        self.paymentSuccessfulLabel.textAlignment = NSTextAlignment.center
        self.paymentSuccessfulLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        self.paymentSuccessfulLabel.font = UIFont(name: "Arial", size: self.screenSize.height*(7/160))
        self.paymentSuccessfulLabel.numberOfLines = 0
        self.paymentSuccessfulLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.paymentSuccessfulLabel.text = "Payment Successful"
        view.addSubview(self.paymentSuccessfulLabel)
        
        // Hide until successful payment
        if (!initialLoad) {
            self.shapeLayer.isHidden = true
            self.checkMark.isHidden = true
            self.paymentSuccessfulLabel.isHidden = true
        }
        
        
        // Phone Number Display
        phoneNumberDisplay.frame = CGRect(x: self.screenSize.width*(1/2 + 1/16),
                                          y: logoImage_view.frame.minY,
                                          width: self.screenSize.width*(3 / 8),
                                          height: self.screenSize.height*(1/4))
        phoneNumberDisplay.textAlignment = NSTextAlignment.center
        phoneNumberDisplay.baselineAdjustment = UIBaselineAdjustment.alignCenters
        phoneNumberDisplay.font = UIFont(name: "Arial", size: self.screenSize.height*(7/160))
        phoneNumberDisplay.numberOfLines = 0
        phoneNumberDisplay.frame.size.width = self.screenSize.width*(3 / 8)
        phoneNumberDisplay.lineBreakMode = NSLineBreakMode.byWordWrapping
        //        phoneNumberDisplay.text = "Enter your phone number to pay"
        phoneNumberDisplay.text = " "
        view.addSubview(phoneNumberDisplay)
        
        // border
        let border_c = UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        //        cbcbcb
        let border_w = CGFloat(3.0)
        
        
        // Button Borders
        // Add a bottom border.
        func addBottomBorder(button: UIButton) {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0,
                                        y: (button.frame.size.height-border_w/2),
                                        width: button.frame.size.width,
                                        height: border_w)
            bottomBorder.backgroundColor = border_c
            button.layer.addSublayer(bottomBorder)
        }
        // Add a top border.
        func addTopBorder(button: UIButton) {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0,
                                        y: -border_w/2,
                                        width: button.frame.size.width,
                                        height: border_w)
            bottomBorder.backgroundColor = border_c
            button.layer.addSublayer(bottomBorder)
        }
        // Add a left border.
        func addLeftBorder(button: UIButton) {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: -border_w/2,
                                        y: 0.0,
                                        width: border_w,
                                        height: button.frame.size.width)
            bottomBorder.backgroundColor = border_c
            button.layer.addSublayer(bottomBorder)
        }
        // Add a right border.
        func addRightBorder(button: UIButton) {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: button.frame.size.width-border_w/2,
                                        y: 0.0,
                                        width: border_w,
                                        height: button.frame.size.width)
            bottomBorder.backgroundColor = border_c
            button.layer.addSublayer(bottomBorder)
        }
        
        // ROW 1
        button1.frame = CGRect(x: c1x,
                               y: r1y,
                               width: num_w,
                               height: num_h)
        button1.setTitle("1", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button1.backgroundColor = UIColor.white
        button1.layer.cornerRadius = 0//0.5 * button1.bounds.size.width
        button1.clipsToBounds = true
        button1.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button1)
        addRightBorder(button: button1)
        view.addSubview(button1)
        
        button2.frame = CGRect(x: c2x,
                               y: r1y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button2.setTitle("2", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button2.backgroundColor = UIColor.white
        button2.layer.cornerRadius = button1.layer.cornerRadius
        button2.clipsToBounds = true
        button2.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button2)
        addRightBorder(button: button2)
        addLeftBorder(button: button2)
        view.addSubview(button2)
        
        button3.frame = CGRect(x: c3x,
                               y: r1y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button3.setTitle("3", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button3.backgroundColor = UIColor.white
        button3.layer.cornerRadius = button1.layer.cornerRadius
        button3.clipsToBounds = true
        button3.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button3)
        addLeftBorder(button: button3)
        view.addSubview(button3)
        
        // ROW 2
        button4.frame = CGRect(x: c1x,
                               y: r2y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button4.setTitle("4", for: .normal)
        button4.setTitleColor(.black, for: .normal)
        button4.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button4.backgroundColor = UIColor.white
        button4.layer.cornerRadius = button1.layer.cornerRadius
        button4.clipsToBounds = true
        button4.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button4)
        addRightBorder(button: button4)
        addTopBorder(button: button4)
        view.addSubview(button4)
        
        button5.frame = CGRect(x: c2x,
                               y: r2y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button5.setTitle("5", for: .normal)
        button5.setTitleColor(.black, for: .normal)
        button5.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button5.backgroundColor = UIColor.white
        button5.layer.cornerRadius = button1.layer.cornerRadius
        button5.clipsToBounds = true
        button5.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button5)
        addRightBorder(button: button5)
        addLeftBorder(button: button5)
        addTopBorder(button: button5)
        view.addSubview(button5)
        
        button6.frame = CGRect(x: c3x,
                               y: r2y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button6.setTitle("6", for: .normal)
        button6.setTitleColor(.black, for: .normal)
        button6.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button6.backgroundColor = UIColor.white
        button6.layer.cornerRadius = button1.layer.cornerRadius
        button6.clipsToBounds = true
        button6.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button6)
        addLeftBorder(button: button6)
        addTopBorder(button: button6)
        view.addSubview(button6)
        
        // ROW3
        button7.frame = CGRect(x: c1x,
                               y: r3y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button7.setTitle("7", for: .normal)
        button7.setTitleColor(.black, for: .normal)
        button7.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button7.backgroundColor = UIColor.white
        button7.layer.cornerRadius = button1.layer.cornerRadius
        button7.clipsToBounds = true
        button7.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button7)
        addRightBorder(button: button7)
        addTopBorder(button: button7)
        view.addSubview(button7)
        
        button8.frame = CGRect(x: c2x,
                               y: r3y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button8.setTitle("8", for: .normal)
        button8.setTitleColor(.black, for: .normal)
        button8.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button8.backgroundColor = UIColor.white
        button8.layer.cornerRadius = button1.layer.cornerRadius
        button8.clipsToBounds = true
        button8.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button8)
        addRightBorder(button: button8)
        addLeftBorder(button: button8)
        addTopBorder(button: button8)
        view.addSubview(button8)
        
        button9.frame = CGRect(x: c3x,
                               y: r3y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button9.setTitle("9", for: .normal)
        button9.setTitleColor(.black, for: .normal)
        button9.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button9.backgroundColor = UIColor.white
        button9.layer.cornerRadius = button1.layer.cornerRadius
        button9.clipsToBounds = true
        button9.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button9)
        addLeftBorder(button: button9)
        addTopBorder(button: button9)
        view.addSubview(button9)
        
        // ROW 4
        buttonVideo.frame = CGRect(x: c1x,
                                   y: r4y,
                                   width: button1.frame.width,
                                   height: button1.frame.height)
        buttonVideo.setTitle("Cancel", for: .normal)
        buttonVideo.setTitleColor(.black, for: .normal)
        buttonVideo.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height/4)
        buttonVideo.backgroundColor = UIColor.white
        buttonVideo.layer.cornerRadius = button1.layer.cornerRadius
        buttonVideo.clipsToBounds = true
        buttonVideo.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addRightBorder(button: buttonVideo)
        addTopBorder(button: buttonVideo)
        view.addSubview(buttonVideo)
        
        button0.frame = CGRect(x: c2x,
                               y: r4y,
                               width: button1.frame.width,
                               height: button1.frame.height)
        button0.setTitle("0", for: .normal)
        button0.setTitleColor(.black, for: .normal)
        button0.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        button0.backgroundColor = UIColor.white
        button0.layer.cornerRadius = button1.layer.cornerRadius
        button0.clipsToBounds = true
        button0.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addRightBorder(button: button0)
        addLeftBorder(button: button0)
        addTopBorder(button: button0)
        view.addSubview(button0)
        
        buttonDel.frame = CGRect(x: c3x,
                                 y: r4y,
                                 width: button1.frame.width,
                                 height: button1.frame.height)
        buttonDel.setTitle("x", for: .normal)
        buttonDel.setTitleColor(.clear, for: .normal)
        buttonDel.layer.cornerRadius = button1.layer.cornerRadius
        buttonDel.setImage(#imageLiteral(resourceName: "delButton_image"), for: .normal)
        buttonDel.clipsToBounds = true
        buttonDel.imageEdgeInsets = UIEdgeInsetsMake(
            button1.frame.width*0,
            button1.frame.width/8,
            button1.frame.width*0,
            button1.frame.width/8)
        buttonDel.contentMode = .scaleAspectFit
        buttonDel.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        buttonDel.backgroundColor = UIColor.white
        buttonDel.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addLeftBorder(button: buttonDel)
        addTopBorder(button: buttonDel)
        view.addSubview(buttonDel)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initialLoad = true
        
        // Bluetooth setup
        serial = BluetoothSerial(delegate: self)
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
        }
        
        // Arduino
        if (defaults.bool(forKey: "arduinoInstalled")) {
            connectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.scanForPeriph), userInfo: nil, repeats: true)
        }
        
        // Time-specific Locking
        timer_hourSpecific = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(ViewController.unlock_timeSpecific), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Begin RscMgr functions
    
    // serial cable connection detected
    func cableConnected(_ protocolString: String!) {
        
        //        connectionLabel.textColor = myGreen
        //        connectionLabel.text = "Cable connected"
        
        rscMgr.open()
//                priceLabel.text = "Yep"
                self.view.setNeedsDisplay()
        rscMgr.setBaud(baudRate)
    }
    
    // serial cable disconnection detected
    func cableDisconnected() {
        
        //        connectionLabel.textColor = myRed
        //        connectionLabel.text = "Cable disconnected"
    }
    
    // a change has been made to the port configuration; needed to conform to RscMgrDelegate protocol
    func portStatusChanged() {
        
    }
    
    // data is ready to read
    func readBytesAvailable(_ length: UInt32) {
        
        let data: Data = rscMgr.getDataFromBytesAvailable()   // note: may also process text using rscMgr.getStringFromBytesAvailable()
        let message = String(data: data, encoding: String.Encoding.utf8)!
        
        // Need to implement same checking for CCINFO
        print(message)
        bluetoothStatus = message
        
        bluetoothRx_array += message
        bluetoothRx_array = (bluetoothRx_array as NSString).replacingOccurrences(of: "?", with: "")
        
        if (bluetoothRx_array.range(of:"</CCINFO>") != nil) {
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "<CCINFO>")[1]
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "</CCINFO>")[0]
            bluetoothRx_array = bluetoothRx_array.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // url-encoded string
            methodToExecute = "ccInfo"
            ccInfo_chargeUser = 1;
            processPayment(method: methodToExecute)
            bluetoothRx_array = ""
        }
        else if (bluetoothRx_array.range(of:"</LOCK>") != nil) {
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "<LOCK>")[1]
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "</LOCK>")[0]
            bluetoothRx_array = bluetoothRx_array.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // url-encoded string
            //            processPayment(method: methodToExecute)
            bluetoothRx_array = ""
        }
        else if (bluetoothRx_array.range(of:"</FREEZER>") != nil) {
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "<FREEZER>")[1]
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "</FREEZER>")[0]
            bluetoothRx_array = bluetoothRx_array.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // url-encoded string
            //            processPayment(method: methodToExecute)
            bluetoothRx_array = ""
        }
        else if (bluetoothRx_array.range(of:"</KEEPALIVE>") != nil) {
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "<KEEPALIVE>")[1]
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "</KEEPALIVE>")[0]
            bluetoothRx_array = bluetoothRx_array.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // url-encoded string
            //            processPayment(method: methodToExecute)
            bluetoothRx_array = ""
        }
        
    }
    
    // MARK: End of RscMgr functions
    
    // Arduino
    // MARK: - Bluetooth Connection Functions
    func scanForPeriph() {
        serial.startScan()
        scanTimeoutTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.scanTimeOut), userInfo: nil, repeats: false)
    }
    
    func scanTimeOut() {
        serial.stopScan()
//        print("timedOut")
    }
    
    func connectToDefaultPeripheral() {
        let mainPeripheral = peripherals[0].peripheral
        serial.connectToPeripheral(mainPeripheral)
        print("-----")
        print(peripherals)
        print(mainPeripheral.name!)
        print(mainPeripheral.name!.characters.last!)
        print("-----")
        connectTimer?.invalidate()
        connectTimer = nil
        scanTimeoutTimer?.invalidate()
        scanTimeoutTimer = nil
        
        //        sendUnlockTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.sendUnlockMessage), userInfo: nil, repeats: true)
    }
    
    func sendUnlockMessage() {
        serial.sendMessageToDevice("UNLOCK\n")
//        rscMgr.write("UNLOCK\
        let unlockString = "UNLOCK\n"
//        let unlockString = "U\n"
        
        let cs = (unlockString as NSString).utf8String
        var buffer = unlockString.data(using: String.Encoding.utf8)!
        
        rscMgr.write(unlockString)
//        rscMgr.write(unlockString)
        
//        priceLabel.text = "HELP"
    }
    
    func sendLockMessage() {
        serial.sendMessageToDevice("LOCK\n")
//        rscMgr.write("LOCK\n")
        
        let lockString = "LOCK\n"
//        let lockString = "L\n"
        
        let cs = (lockString as NSString).utf8String
        var buffer = lockString.data(using: String.Encoding.utf8)!
        
        rscMgr.write(lockString)
        
        //        if (bluetoothStatus == "BOTH") {
        //            serial.sendMessageToDevice("LOCK\n")
        //        }
        //        else {
        //            alarm noise
        //        }
    }
    
    //MARK: BluetoothSerialDelegate
    
    func serialDidReceiveString(_ message: String) {
        print(message)
        bluetoothStatus = message
        
        if (message.range(of:"<CCINFO>") != nil) {
            bluetoothRx_array += message
        }
        else if (bluetoothRx_array.range(of:"</CCINFO>") == nil) {
            bluetoothRx_array += message
        }
        if (bluetoothRx_array.range(of:"</123CCINFO>") != nil) {
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "<CCINFO>")[1]
            bluetoothRx_array = bluetoothRx_array.components(separatedBy: "</123CCINFO>")[0]
            bluetoothRx_array = bluetoothRx_array.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! // String to send to php script,
//            if (!waitingForCC) {
//                processPayment(method: "ccInfo")
//            }
//            else {
//                // Epona449
//                registerUser();
//            }
            // Epona740
//            processPayment(method: "ccInfo")
            methodToExecute = "ccInfo"
            ccInfo_chargeUser = 1;
            processPayment(method: methodToExecute)
            bluetoothRx_array = ""
        }
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from BT")
        scanForPeriph()
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append(peripheral: peripheral, RSSI: theRSSI)
        peripherals.sort { $0.RSSI < $1.RSSI }
        connectToDefaultPeripheral()
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
    }
    
    func serialIsReady(_ peripheral: CBPeripheral) {
    }
    
    func serialDidChangeState() {
    }
    
    // MARK: - Pre-BT functions
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func paymentReset () {
        DispatchQueue.main.async {
            self.subscription = 0
            self.originalPriceLabel()
            self.resetKeurigLabel()
            self.keypadVersion = "phoneNumber"
            self.localRegistration = false;
            self.cardToken = ""
            self.firstName = ""
            self.lastName = ""
            self.fName_url = ""
            self.lName_url = ""
            self.waitingForCC = false;
            self.methodToExecute = "";
            self.ccInfo_chargeUser = 0
            self.phoneNumStringCount = 0
            self.pinNumStringCount = 0
            self.pinTryCount = 0
            self.pinRegistration = false;
            self.pinString_display = ["-", "-", "-", "-"]
            self.pinString = ["-", "-", "-", "-"]
            self.pinString_validate = ["-", "-", "-", "-"]
            self.phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
            self.phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
            self.swipeImage_view.isHidden = false
            self.pinPadImage_view.isHidden = false
            self.keurigLabel.isHidden = false
            self.priceLabel.isHidden = false
            self.subscribeButton.isHidden = false
        }
        phoneNumberDisplay.text = ""
        self.view.setNeedsDisplay()
//        self.viewDidLoad()
    }
    
//    func originalPriceLabel() {
//        let string = "$5.99 | $3.99\n\t\t\t\t\t\t\tMembers Only" //\n(subscription opens tomorrow)"
//        var attributedString = NSMutableAttributedString(string: string as String)
//        let zeroAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!] as [String : Any]
//        let firstAttributes = [NSStrikethroughStyleAttributeName: 2, NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!] as [String : Any]
//        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(6/170))!] as [String : Any]
//        attributedString.addAttributes(zeroAttributes, range: NSMakeRange(0,13))
//        attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attributedString.length))
//        
//        priceLabel.attributedText = attributedString
//        priceLabel.numberOfLines = 0
//    }
    
    func subscriptionPriceLabel() {
//        let string = "\n\n$12 / Month\n$3.99 / Smoothie" //\n(subscription opens tomorrow)"
//        var attributedString = NSMutableAttributedString(string: string as String)
//        let zeroAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(9/170))!] as [String : Any]
//        let initOff = 2
//        attributedString.addAttributes(zeroAttributes,
//                                       range: NSMakeRange(initOff,
//                                                          attributedString.length-initOff))
//        attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attributedString.length))
//        
//        priceLabel.attributedText = attributedString
//        priceLabel.numberOfLines = 0
//        self.view.setNeedsDisplay()
    }
    
    func processSubscription() {
        print("Process subscription")
        
        subscriptionPriceLabel()
        subscription = 1
        
        self.swipeImage_view.isHidden = false
        self.pinPadImage_view.isHidden = false
        self.keurigLabel.isHidden = false
        self.priceLabel.isHidden = false
        self.subscribeButton.isHidden = true
    }
    
    func phoneNumberPayment() {
        // Epona
        // get PIN
        self.keypadVersion = "PIN"
//        processPayment(method: "phoneNumber")
    }
    
    // Epona 658
    func processPayment(method: String) {
        // Process Payment - PPMT
//        self.payButton.backgroundColor = .black
//        self.payButton.setTitle("Wait", for: .normal)
//        self.payButton.setTitleColor(.white, for: .normal)
        
        var urlWithParams = ""
        let versionString = "&version=" + defaults.string(forKey: "version")!
        // Add one parameter
        if (method == "phoneNumber") {
            let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
            let companyString = "&companyName=" + defaults.string(forKey: "company")!
            urlWithParams = paymentAddress + phoneString + companyString + versionString
        }
        else if (method == "ccInfo") {
            print(">>>>>>>>>>>\n");
            print(bluetoothRx_array);
            print("<<<<<<<<<<<\n");
            let ccInfoString = "?ccInfo=" + bluetoothRx_array
            let chargeUser_now = "&chargeNow=" + String(ccInfo_chargeUser)
            let companyString = "&companyName=" + defaults.string(forKey: "company")!
            let subscribeString = "&subscribe=" + String(self.subscription)
            urlWithParams = paymentAddress + ccInfoString + companyString + versionString + chargeUser_now + subscribeString
        }
        else if (method == "PIN") { // Yields to "Needs Registration"
            let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
            let pinString_url = "&PIN=" + String(pinString)
            let companyString = "&companyName=" + defaults.string(forKey: "company")!
            let subscribeString = "&subscribe=" + String(self.subscription)
            urlWithParams = paymentAddress + phoneString + companyString + versionString + pinString_url + subscribeString
        }
        else if (method == "phoneThenSwipeRegister") {
            let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
            let pinString_url = "&PIN=" + String(pinString)
            let companyString = "&companyName=" + defaults.string(forKey: "company")!
            let tokenString_url = "&stripeToken=" + String(pinString)
            let subscribeString = "&subscribe=" + String(self.subscription)
            urlWithParams = paymentAddress + phoneString + companyString + versionString + pinString_url + tokenString_url + subscribeString
        }
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        print(">>>")
        print(urlWithParams)
        print("<<<")
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        /* TESTING HERE */
        
        // Execute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            DispatchQueue.main.async {
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            responseString = responseString.replacingOccurrences(of: "\n", with: "")
//            print("responseString = \(responseString)")
            
            
            let chargeResponse = responseString.components(separatedBy: ",")
            print(chargeResponse)
            
            if (chargeResponse[0] == "Customer not created") {
                // Version 1.0
                print("10.  pinString" + String(self.pinString) + "\n")
                self.registrationRequired()
            }
            else if (chargeResponse[0] == "Needs registration") {
                // Epona123
//                self.registerUser()
                self.waitingForCC = true;
//                let ccInfoString = "?ccInfo=" + bluetoothRx_array
//                let chargeUser_now = "&chargeNow=" + String(ccInfo_chargeUser)
//                let companyString = "&companyName=" + defaults.string(forKey: "company")!
//                urlWithParams = paymentAddress + ccInfoString + companyString + versionString + chargeUser_now
            }
            else if (chargeResponse[0] == "PIN is incorrect") {
                // Epona 892
                let formattedString = NSMutableAttributedString()
                let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                formattedString.append(NSAttributedString(string: "Uh oh!  Please re-enter your "))
                let text = "PIN"
                formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                formattedString.append(NSAttributedString(string: ".\nIt was incorrect :(."))
                self.keurigLabel.attributedText = formattedString
                
                self.pinString = ["-","-","-","-"];
                self.pinString_validate = ["-","-","-","-"];
                self.pinString_display = ["-","-","-","-"];
                self.pinNumStringCount = 0;
                
                self.keypadVersion = "PIN"
            }
            else if (chargeResponse[0] == "User not created") { // Card provided
                self.cardToken = chargeResponse[1]
                let cT = self.cardToken
                let codeToken_start = cT.substring(to:cT.index(cT.startIndex, offsetBy: 4));
                
                self.fName_url = "&firstName=" + String(chargeResponse[2])
                self.lName_url = "&lastName=" + String(chargeResponse[3])
                
                self.swipeImage_view.isHidden = true
                self.logoImage_view.isHidden = true
                self.priceLabel.isHidden = true
                
                // corkDork12
                
//                if (codeToken_start == "tok_") {
//                    self.waitingForCC = false;
//                }
                if (!self.waitingForCC) {
                    self.localRegistration = true;
                    
                    // Moved from corkDork12
                    let formattedString = NSMutableAttributedString()
                    let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                    formattedString.append(NSAttributedString(string: "Awesome!\nNow "))
                    var text = "enter "
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    formattedString.append(NSAttributedString(string: "your\n"))
                    text = "Phone Number"
                    formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                    self.keurigLabel.attributedText = formattedString
                    self.view.setNeedsDisplay()
                    // Moved from corkDork12
                }
                else {
                    print("0: \n")
//                    self.processPayment(method: "ccInfo")
                    self.registerUser()
//                    print("1: \n")
                    self.waitingForCC = false
//                    print("2: \n")
                }
                self.phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
                self.phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
                self.phoneNumStringCount = 0
                self.phoneNumberDisplay.text = ""
                // Epona123
                // Prompt - Needs to show that phone number is required for registration
                
                
                
                
                // Version 1.1+
                // Epona Epona
                
                // User has swiped their card, which is not on file in the system
                
                // Enter phone number
                // // In system?
                // // // Yes
                // // // // Capture PIN
                // // // // // Matches?
                // // // // // // Yes
                // // // // // // // New record in DB
                // // // // // // // Charge
                // // // // // // No
                // // // // // // // Ask for PIN again, but also have reset (this is done via text...manually)
                // // // No
                // // // // Capture PIN (label: alpha)
                // // // // Capture PIN
                // // // // Matches?
                // // // // // Yes
                // // // // // // Store in DB
                // // // // // No
                // // // // // // (GoTo: alpha)
            }
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    //                    print(data!)
                    //                    print(convertedJsonIntoDict)
                    if (String(describing: convertedJsonIntoDict["status"]!) == "succeeded") {
                        self.successfulPayment()
                        self.keypadVersion = "phoneNumber";
                    }
                    
                    // Get value by key
                    //                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    //                    print(firstNameValue!)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
//            semaphore.signal(); //910
            }
        }
        
        task.resume()
//        semaphore.wait(timeout: dispatch_time_t(2000));
        
        if ((method == "ccInfo") && (waitingForCC)) {
//            self.processPayment(method: "phoneThenSwipeRegister")
            methodToExecute = "phoneThenSwipeRegister"
            // Epona658 - Unhide
        }
        
        /* FINISHED TESTING */
    }
    
    func payUsing_worldSelector () {
        self.processPayment(method: methodToExecute)
    }
    
    //    func gotoVideo_transition(sender: UIButton) {
    //        self.performSegue(withIdentifier: "goto_videoTracking", sender: Any?.self)
    //    }
    
    func gotoSetup (sender: UIButton) {
        if (sender.title(for: .normal) == "Setup") {
            self.performSegue(withIdentifier: "gotoSetup", sender: Any?.self)
        }
    }
    
    func createPhone_andPIN () {
        
    }
    
    func phoneExists() {
        var urlWithParams = ""
        let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
        urlWithParams = phoneExistsAddress + phoneString
        
        print(urlWithParams)
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            responseString = responseString.replacingOccurrences(of: "\n", with: "")
            self.phoneExists_return(responseString: responseString)
            //            print("responseString = \(responseString)")
            
            
//            let chargeResponse = responseString.components(separatedBy: ",")
//            print(chargeResponse)
            
            // Epona
            }
        
        task.resume()
    }
    
    func phoneExists_return(responseString: String) {
        if (responseString == "Phone Number DNE") {
            print("DNE");
            // Epona
            // Register button
            // if registered, PIN set <-- button action to continue through this
            pinRegistration = true;
            registerPin()
            DispatchQueue.main.async {
                self.view.setNeedsDisplay()
            }
            // Enter PIN
            // Verify PIN
            // // Not matching
            // // // repeat 3x total
        }
        else {
            print("Exists");
            // Epona
            // Enter PIN
            DispatchQueue.main.async {
                self.view.setNeedsDisplay()
            }
            pinEntry()
            // // Correct
            // // // Create new customer and charge using provided info
            // // Incorrect
            // // // Ask for a re-entry
        }
    }
    
    func resetKeurigLabel() { // Epone9290
        DispatchQueue.main.async {
            let formattedString = NSMutableAttributedString()
            formattedString.append(NSAttributedString(string: "Enter "))
            let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
            var text = "Phone Number "
            formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
            formattedString.append(NSAttributedString(string: "\nor \n"))
            text = "Swipe Credit Card" // "Swipe Credit Card "
            formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
            self.keurigLabel.attributedText = formattedString
            
            self.pinPadImage_view.isHidden = false
            self.swipeImage_view.isHidden = false
            self.keurigLabel.isHidden = false
            self.priceLabel.isHidden = false
            self.logoImage_view.isHidden = false
            self.priceLabel.isHidden = false
            
            self.view.setNeedsDisplay()
        }
    }
    
    func registerPin() {
        DispatchQueue.main.async {
            self.swipeImage_view.isHidden = true
            self.logoImage_view.isHidden = true
            self.priceLabel.isHidden = true
            
            let formattedString = NSMutableAttributedString()
            formattedString.append(NSAttributedString(string: "Enter a "))
            let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
            var text = "PIN "
            formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
            formattedString.append(NSAttributedString(string: "\nto "))
            text = "Register" // "Swipe Credit Card "
            formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
            self.keurigLabel.attributedText = formattedString
            
            
            self.view.setNeedsDisplay()
            
            self.pinEntry()
            self.view.setNeedsDisplay()
        }
    }
    
    func pinEntry() {
        DispatchQueue.main.async {
            if (!self.pinRegistration) {
                self.logoImage_view.isHidden = true
                self.priceLabel.isHidden = true
                self.swipeImage_view.isHidden = true
                
                let formattedString = NSMutableAttributedString()
                formattedString.append(NSAttributedString(string: "Enter your "))
                let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
                var text = "PIN "
                formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                formattedString.append(NSAttributedString(string: "\nto "))
                text = "Pay" // "Swipe Credit Card "
                formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
                self.keurigLabel.attributedText = formattedString

            }
            // Epona 223
    //        self.buttonDel.sendActions(for: .touchUpInside)
            self.keypadVersion = "PIN" //<-- Automatic trigger for verifying matching
            
            self.pinString_display = ["-","-","-","-"];
            self.phoneNumberDisplay.text = String(self.pinString_display);
            self.view.setNeedsDisplay()
        }
    }
    
    func hashCheck() {
        var urlWithParams = ""
        let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
        let pinString_url = "&PIN=" + String(pinString)
        urlWithParams = pinCheckAddress + phoneString + pinString_url + version_url
        
        
        print(urlWithParams)
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            responseString = responseString.replacingOccurrences(of: "\n", with: "")
//            self.phoneExists_return(responseString: responseString)
            print("responseString = \(responseString)")
            
            if (responseString == "OK") {
                // Epona
                // get customer id
                // charge customer
            }
            else {
                self.incorrectPin()
            }
        }
        
        task.resume()
    }
    
    func incorrectPin () {
        // Epona
        // Clear PIN
        // Notify them of incorrect PIN & Remaining attempts
    }
    
    func registerUser() {
        //registerNewUserAddress
        var urlWithParams = ""
        let phoneString = "?phoneNumber=" + String(phoneNumString_exact)
        let pinString_url = "&PIN=" + pinString_str
        let token_url = "&stripeToken=" + String(cardToken)
        let chargeUser_now = "&chargeNow=" + String(ccInfo_chargeUser)
        let companyString = "&companyName=" + defaults.string(forKey: "company")!
        urlWithParams = registerNewUserAddress + phoneString + pinString_url + version_url + token_url + fName_url + lName_url + chargeUser_now + companyString
        print(">>>>>>>")
        print("Payment Posting")
        print(urlWithParams)
        print(">>>>>>>")
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        print(urlWithParams)
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            responseString = responseString.replacingOccurrences(of: "\n", with: "")
            //            self.phoneExists_return(responseString: responseString)
            print("responseString = \(responseString)")
            
            //>>>>>
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    //                    print(data!)
                    //                    print(convertedJsonIntoDict)
                    if (String(describing: convertedJsonIntoDict["status"]!) == "succeeded") {
                        self.successfulPayment()
                        self.keypadVersion = "phoneNumber";
                    }
                    
                    // Get value by key
                    //                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    //                    print(firstNameValue!)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            //<<<<<

        }
        
        task.resume()

    }
    
}



//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }

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
