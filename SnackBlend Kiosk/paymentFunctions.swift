//
//  paymentFunctions.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation

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
let timeToRelock = 20.0
let successPayment_transition = 5.0

// Payment or Master Unlock
var paymentOr_masterUnlock = false

// Lock state
var lockState = true

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

// Server Payment Processing
func processPayment(method: String, arduinoRx_message: String, ccInfo_chargeUser: Int, subscription: Int) -> String {
    
    var returnString = "Server Communication Error"
    NSLog("Payment method - " + method)
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
            NSLog(responseString)
            
            
            let chargeResponse = responseString.components(separatedBy: ",")
            
            if (chargeResponse[0] == "Successful") {
                returnString = "Successful"
            }
            else if (chargeResponse[0] == "Swipe Again") {
                returnString = "Swipe Again"
            }
            else if (chargeResponse[0] == "Failed") {
                returnString = "Failed"
            }
        }
    }
    
    task.resume()
    return returnString
}
