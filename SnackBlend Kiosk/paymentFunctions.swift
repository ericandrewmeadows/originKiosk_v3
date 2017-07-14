//
//  paymentFunctions.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

let paymentAddress = "https://io.calmlee.com/userExists.php"
let phoneExistsAddress = "https://io.calmlee.com/phoneExists.php"
let pinExistsAddress = "https://io.calmlee.com/pinExists.php"
let pinCheckAddress = "https://io.calmlee.com/hashCheck.php"
let registerNewUserAddress = "https://io.calmlee.com/paymentPosting_GET.php"
let lockAddress = "https://io.calmlee.com/lock_commands.php"
let keepAliveAddress = "https://io.calmlee.com/keepAlive_commands.php"
let freezerAddress = "https://io.calmlee.com/freezer_commands.php"
let siteSpecificUnlockTimesAddress = "https://io.calmlee.com/siteSpecificUnlockTimes.php"
let freezerSettingsAddress = "https://io.calmlee.com/freezerSettings.php"
let priceSettingsAddresss = "https://io.calmlee.com/priceSettings.php"
let pinMigrationAddress = "https://io.calmlee.com/pinMigration.php"
//let paymentAddress = "https://io.calmlee.com/userExists_stripeTestMode.php"

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
let unlockTime_max: CGFloat = 30.0
var unlockTime_remaining: CGFloat = 0.0
var unlockCountdown_timer: Timer?
let successPayment_transition = 5.0
let lockState_visualization_timeInterval = 0.01

// Payment or Master Unlock
var paymentOr_masterUnlock = false

// Lock state
var lockState_transmitted = true
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
        
        var returnString = "Server Communication Error"
        var urlWithParams = ""
        let versionString = "&version=" + defaults.string(forKey: "version")!
        
        // V3 Payment Communications Structure
        if (method == "ccInfo") {
            let ccInfoString = "?ccInfo=" + arduinoRx_message
            let chargeUser_now = "&chargeNow=" + String(ccInfo_chargeUser)
            let companyString = "&locationName=" + defaults.string(forKey: "location")!
            let subscribeString = "&subscribe=" + String(subscription)
            urlWithParams = paymentAddress + ccInfoString + companyString + versionString + chargeUser_now + subscribeString
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
                
                let processStatus = responseString.components(separatedBy: ",")[0]
                
                if (processStatus == "Successful") {
                    paymentOr_masterUnlock = true
                    displayItems.transition_paymentProcessing_to_paymentSuccessful()
                }
                else if (processStatus == "Swipe Again") {
                }
                else if (processStatus == "Failed") {
                    paymentOr_masterUnlock = false
                    paymentFunctions.unsuccessfulPayment()
                }
            }
        }
        
        task.resume()
    }
    
    func receiptYesNo (sender: UIButton) {
        displayItems.hideScreen_smsReceipt()
        if (sender.titleLabel!.text! == "Yes") {
            displayItems.transition_smsReceipt_to_phonePinPad()
        }
        else {
            displayItems.transition_smsReceipt_to_unlocked()
        }
    }

    func numpadPressed (sender: UIButton) {
        let inputVal = (sender.titleLabel?.text)!
        if (inputVal != "x") {
            displayItems.phonePeriphery_visible()
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
            // Porter
            // Also call the function to send a receipt to a phone number, asynchronously
            displayItems.transition_phonePinPad_to_unlocked()
            return
        }
    }

    func clearPhoneNumber () {
        phoneNumString = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
        phoneNumString_exact = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
        phoneNumberDisplay.text = " "
        phoneNumStringCount = 0
        displayItems.phonePeriphery_hidden()
    }
    
    func smsReceipt_goToMain() {
        displayItems.hideScreen_phonePinPad()
        displayItems.showScreen_smsReceipt()
    }

    func successfulPayment () {
        // Sequencing begin...
    //    arduinoFunctions.arduinoLock_unlock()
    }
    func unsuccessfulPayment () {
        // Placeholder
    }

    func unlockTimer_timeRemaining () {
        unlockTime_remaining -= CGFloat(lockState_visualization_timeInterval)
        if (unlockTime_remaining < 0.0) {
            unlockTime_remaining = 0.0
            killUnlockTimer()
            displayItems.setLockImage_locked()
            arduinoFunctions.arduinoLock_lock()
            // Execute relock function here
            // This allows for multiple payments to go through and leave the freezer unlocked during these transactions
        }
        circularMeter.reloadData()
    }

    func killUnlockTimer () {
        unlockCountdown_timer?.invalidate()
        unlockCountdown_timer = nil
    }
}
