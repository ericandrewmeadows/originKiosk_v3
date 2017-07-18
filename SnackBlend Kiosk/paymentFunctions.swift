//
//  paymentFunctions.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

let paymentAddress = "https://io.calmlee.com/originKiosk_processPayment.php"
let receiptAddress = "https://io.calmlee.com/originKiosk_generateReceipt.php"

let lockAddress = "https://io.calmlee.com/lock_commands.php"
let keepAliveAddress = "https://io.calmlee.com/keepAlive_commands.php"
let freezerAddress = "https://io.calmlee.com/freezer_commands.php"
let siteSpecificUnlockTimesAddress = "https://io.calmlee.com/siteSpecificUnlockTimes.php"
let freezerSettingsAddress = "https://io.calmlee.com/freezerSettings.php"
let priceSettingsAddresss = "https://io.calmlee.com/priceSettings.php"

// Subscription Information
var subscription_priceSet: Bool = false
var subscription_smoothieCount1: Int = 0
var subscription_smoothieCount2: Int = 0
var subscription_smoothieCount3: Int = 0
var subscription_smoothiePrice1: Float = 2.99
var subscription_smoothiePrice2: Float = 0
var subscription_smoothiePrice3: Float = 0

// Payment Information
var payment_priceSet: Bool = false
var payment_employeeThreshold:  Int = 0
var payment_thresholdConfig:    Int = 0
var payment_threshold1:         Int = 0
var payment_threshold2:         Int = 0
var payment_price1:             Float = 9.99
var payment_price2:             Float = 0

// Arduino Lock
let unlockTime_max: CGFloat = 30.0 // Beckinsale
var unlockTime_remaining: CGFloat = 0.0
var unlockCountdown_timer: Timer?
let successPayment_transition = 5.0
let lockState_visualization_timeInterval = 0.01

// Payment or Master Unlock
var paymentOr_masterUnlock = false

// Lock state
var lockState_unlock_transmitted = false
var lockState_lock_transmitted = false
var lockState_actual = false

// siteSpecificUnlockTimes
var siteSpecificUnlockTimes = [[Int]]()
let unlock_TimeSpecific_interval: Double = 30
let timeSpecificUnlockStatus_interval: Double = 5*60
let timer_setOrientation_interval: Double = 60
var timeSpecificUnlocked = false

// Subscription Info
var subscription = 0

// Credit Card Swipe Info
let version_url = "&version=3.0.0"
var cardToken = ""
var firstName = ""
var lastName = ""
var fName_url = ""
var lName_url = ""
var waitingForCC = false
var methodToExecute = ""
var ccInfo_chargeUser = 0

// Receipt Information
var customerNumber: Int = 0
var chargeAmt:      Int = 0
var chargeTime:     Int = 0

// Phone Number Information
var phoneNumString: [Character] = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
var phoneNumString_exact: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
var phoneNumStringCount = 0

// Master Unlock
let masterUnlockString = "CC3423" // <- "DICE"
var input_last6 = [" ", " ", " ", " ", " ", " "]

class PaymentFunctions: NSObject {
    // Server Payment Processing
    func processPayment(method: String, arduinoRx_message: String, ccInfo_chargeUser: Int, subscription: Int) {
        
        displayItems.hideScreen_paymentSwipe()
        displayItems.showScreen_paymentProcessing()
        processingPayment_timer = Timer.scheduledTimer(timeInterval: processingPayment_timeInterval,
                                                       target: displayItems.self,
                                                       selector: #selector(displayItems.processingPayment_displayUpdate),
                                                       userInfo: nil, repeats: true)
        
        var urlWithParams = ""
        let versionString = "&version=" + defaults.string(forKey: "version")!
        
        // V3 Payment Communications Structure
        if (method == "ccInfo") {
            let ccInfoString = "?ccInfo=" + arduinoRx_message
            let locationString = "&locationName=" + defaults.string(forKey: "location")!
            urlWithParams = paymentAddress + ccInfoString + locationString + versionString
            if (unitTesting) {
                urlWithParams += "&unitTesting=1"
            }
        }
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // Execute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            DispatchQueue.main.async {
                // Check for error
                if error != nil
                {
                    print("error=\(String(describing: error))")
                    return
                }
                
                // Print out response string
                var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                responseString = responseString.replacingOccurrences(of: "\n", with: "")
                NSLog("<URL_PAYMENT_REPLY> = " + responseString)
                print("<URL_PAYMENT_REPLY> = " + responseString)
                
                let processingInfo = responseString.components(separatedBy: ",")
                let processStatus = processingInfo[0]
                
                displayItems.processingPayment_displayUpdate_kill()
                if (processStatus == "Successful") {
                    paymentOr_masterUnlock = true
                    
                    customerNumber = Int(processingInfo[1])!
                    chargeAmt = Int(processingInfo[2])!
                    chargeTime = Int(processingInfo[3])!
                    if (processingInfo[4] != "NA") {
                        self.resetPhoneNumber()
                        print(processingInfo[4])
                        for character in processingInfo[4].characters {
                            paymentFunctions.addTo_phoneNumber(inputVal: character)
                        }
                        print(">>>")
                        print(String(phoneNumString))
                        print(">>>")
                    }
                    
                    displayItems.transition_paymentProcessing_to_paymentSuccessful()
                }
                else if (processStatus == "Swipe Again") {
                    paymentFunctions.swipeAgain()
                }
                else if (processStatus == "Invalid Card") {
                    paymentFunctions.invalidCard()
                }
                else if (processStatus == "Failed") {
                    paymentOr_masterUnlock = false
                    paymentFunctions.unsuccessfulPayment()
                }
            }
        }
        
        task.resume()
    }
    
    func transmitReceipt () {
        
        var urlWithParams = ""
        let versionString = "&version=" + defaults.string(forKey: "version")!
        
        // V3 Receipt Communications Structure
        let locationString = "?locationName=" + defaults.string(forKey: "location")!
        let customerNumberString = "&customerNumber=" + String(customerNumber)
        let chargeAmtString = "&chargeAmt=" + String(chargeAmt)
        let chargeTimeString = "&chargeTime=" + String(chargeTime)
        let phoneNumberString = "&phoneNumber=" + String(phoneNumString_exact)
        
        urlWithParams = receiptAddress + locationString + customerNumberString + chargeAmtString + chargeTimeString + phoneNumberString + versionString
        if (unitTesting) {
            urlWithParams += "&unitTesting=1"
            print("<<>>")
            print(urlWithParams)
            print("<<>>")
        }
        
        // Create NSURL Object
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // Execute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            DispatchQueue.main.async {
                // Check for error
                if error != nil
                {
                    print("error=\(String(describing: error))")
                    return
                }
                NSLog("<RECEIPT_TRANSMITTED>")
            }
        }
        
        task.resume()
    }
    
    func receiptYesNo (sender: UIButton) {
        displayItems.hideScreen_smsReceipt()
        if (sender.titleLabel!.text! == "Yes") {
            receiptYesNo_elementFade_timeRemaining = receiptYesNo_elementFade_timeMax
            displayItems.transition_smsReceipt_to_phonePinPad()
        }
        else {
            receiptYesNo_elementFade_timer?.invalidate()
            receiptYesNo_elementFade_timer = nil
            displayItems.transition_smsReceiptNo_to_unlocked()
        }
    }
    
    func addTo_phoneNumber (inputVal: Character) {
        if phoneNumStringCount < 10 {
            phoneNumString_exact[phoneNumStringCount] = inputVal
            phoneNumStringCount += 1
            if phoneNumStringCount <= 3 {
                phoneNumString[phoneNumStringCount] = inputVal
            }
            else if phoneNumStringCount <= 6 {
                phoneNumString[phoneNumStringCount+2] = inputVal
            }
            else if phoneNumStringCount <= 10 {
                phoneNumString[phoneNumStringCount+3] = inputVal
            }
        }
        phoneNumberDisplay.text = String(phoneNumString)
    }

    func numpadPressed (sender: UIButton) {
        receiptYesNo_elementFade_timeRemaining = receiptYesNo_elementFade_timeMax
        let inputVal = (sender.titleLabel?.text)!
        if (inputVal != "x") {
            displayItems.phonePeriphery_visible()
            addTo_phoneNumber(inputVal: Character(inputVal))
            if (phoneNumStringCount == 10) {
                displayItems.showAndEnable_pinpad_lowerRight()
            }
            else {
                displayItems.hideAndDisable_pinpad_lowerRight()
            }
        }
        else {
            if phoneNumStringCount > 0 {
                displayItems.hideAndDisable_pinpad_lowerRight()
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
                displayItems.phonePeriphery_hidden()
            }
        }
    }
    
    func phoneNumber_submit (sender: UIButton) {
        let inputVal = (sender.titleLabel?.text)!
        if (inputVal == "Submit") {
            // Beckinsale
            transmitReceipt()
            displayItems.transition_phonePinPad_to_smsReceiptSent()
        }
    }
    
    func resetPhoneNumber() {
        phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
        phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
        phoneNumStringCount = 0
    }

    func clearPhoneNumber () {
        receiptYesNo_elementFade_timeRemaining = receiptYesNo_elementFade_timeMax
        phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
        phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
        phoneNumberDisplay.text = " "
        phoneNumStringCount = 0
        displayItems.phonePeriphery_hidden()
    }
    
    func smsReceipt_goToMain() {
        receiptYesNo_elementFade_timeRemaining = receiptYesNo_elementFade_timeMax
        displayItems.hideScreen_phonePinPad()
        displayItems.showScreen_smsReceipt()
    }

    func successfulPayment () {
        // Sequencing begin...
//        arduinoFunctions.arduinoLock_unlock()
        displayItems.transition_paymentSuccessful_to_smsReceipt()
    }
    func unsuccessfulPayment () {
        // Placeholder
        print("---------->>>>> unsuccessfulPayment")
        displayItems.transition_paymentProcessing_to_paymentDeclined()
    }
    func invalidCard () {
        print("---------->>>>> invalidCard")
        displayItems.transition_paymentProcessing_to_paymentSwipeAgain()
    }
    func swipeAgain () {
        print("---------->>>>> swipeAgain")
        displayItems.transition_paymentProcessing_to_paymentSwipeAgain()
    }

    func unlockTimer_timeRemaining () {
        unlockTime_remaining -= CGFloat(lockState_visualization_timeInterval)
        if (unlockTime_remaining < 0.0) {
            unlockTime_remaining = 0.0
            killUnlockTimer()
            displayItems.setLockImage_locked()
            lockState_repeatLockComms_unlocked_timer?.invalidate()
            lockState_repeatLockComms_unlocked_timer = nil
            lockState_repeatLockComms_locked_timer?.invalidate()
            lockState_repeatLockComms_locked_timer = nil
            lockState_unlock_transmitted = false
            lockState_lock_transmitted = false
            lockState_verification_unlocked = false
            lockState_verification_locked = false
            arduinoFunctions.arduinoLock_lock()
            // Execute relock function here
            // This allows for multiple payments to go through and leave the freezer unlocked during these transactions
        }
        circularMeter.reloadData()
    }
    
    func receiptYesNo_elementFade () {
        receiptYesNo_elementFade_timeRemaining -= CGFloat(receiptYesNo_elementFade_timeInterval)
        if (receiptYesNo_elementFade_timeRemaining < 0.0) {
            receiptYesNo_elementFade_timeRemaining = 0.0
            receiptYesNo_elementFade_timer?.invalidate()
            receiptYesNo_elementFade_timer = nil
            displayItems.hideScreen_smsReceipt()
            displayItems.hideScreen_phonePinPad()
            arduinoFunctions.arduinoLock_unlock()
            displayItems.showScreen_instructionsSequence()
            displayItems.instructionsImage_displayUpdate()
        }
    }

    func killUnlockTimer () {
//        lockState_sequenceStarted_unlocked = false
//        lockState_sequenceStarted_locked = false
        unlockCountdown_timer?.invalidate()
        unlockCountdown_timer = nil
    }
}
