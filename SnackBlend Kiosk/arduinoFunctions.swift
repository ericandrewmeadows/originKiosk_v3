//
//  arduinoFunctions.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation

func sendUnlockMessage(rscMgr: RscMgr) {
    let unlockString = "UNLOCK\n"
    rscMgr.write(unlockString)
    lockState = false
    serverComms_lockCommunication(lockString: "Sent: Unlock")
}

func sendLockMessage(rscMgr: RscMgr) {
    if (paymentOr_masterUnlock == true) {
        paymentOr_masterUnlock = false
    }
    let lockString = "LOCK\n"
    rscMgr.write(lockString)
    lockState = true
    serverComms_lockCommunication(lockString: "Sent: Lock")
}

// MARK: Dashboard and Server-Set Settings Functions
// Timers
var acquireFreezerSettings_timer: Timer?
var timer_hourSpecific: Timer?
var timer_acquireUnlockTimes: Timer?
var timer_setOrientation_landscapeLeft: Timer?
var acquirePriceSettings_timer: Timer?
// Intervals
let acquirePriceSettings_timeInterval = 15*60
let acquireFreezerSettings_timeInterval = 15*60


// Lock Messages - Server Communications
func serverComms_lockCommunication( lockString: String ) {
    //        "State: Unlocked, State: Locked, Sent: Unlock, Sent: Lock"
    var lockString = lockString
    
    lockString = lockString.components(separatedBy: ": ")[1]
    
    // Create NSURL Object
    let lockString_url = "?lockMessage=" + lockString
    let locationName_url = "&locationName=" + defaults.string(forKey: "location")!
    var urlWithParams = lockAddress + lockString_url + locationName_url
    urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
    
    NSLog("serverComms_lockCommunication")
    NSLog("--> " + urlWithParams)
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
        }
    }
    
    task.resume()
    
}

// Keep Alive Messages - Server Communications
func serverComms_keepAliveCommunication() {
    
    // Create NSURL Object
    let locationName_url = "?locationName=" + defaults.string(forKey: "location")!
    var urlWithParams = keepAliveAddress + locationName_url
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
        }
    }
    
    task.resume()
    
}

// Freezer Messages - Server Communications
func serverComms_freezerCommunication( freezerString: String ) {
    // freezerString - Temp: ##.##, State: (On/Off/SS)
    
    let freezerComponents = freezerString.components(separatedBy: ",")
    var freezerTemp = freezerComponents[0]
    freezerTemp = freezerTemp.components(separatedBy: ": ")[1]
    var freezerState = freezerComponents[1]
    freezerState = freezerState.components(separatedBy: ": ")[1]
    
    // Create NSURL Object
    let locationName_url = "?locationName=" + defaults.string(forKey: "location")!
    let freezerTemp_url = "&freezerTemp=" + freezerTemp
    let freezerState_url = "&freezerState=" + freezerState
    var urlWithParams = freezerAddress + locationName_url + freezerTemp_url + freezerState_url
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
        }
    }
    
    task.resume()
    
}

// Freezer Messages - Server Communications
func serverComms_siteSpecificUnlockTimes( ) {
    
    // Create NSURL Object
    let locationName_url = "?locationName=" + defaults.string(forKey: "location")!
    var urlWithParams = siteSpecificUnlockTimesAddress + locationName_url
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
            
            let responseArray = responseString.components(separatedBy: ";")
            
            for items in responseArray {
                if (items.characters.count) > 0 {
                    let times = items.components(separatedBy: ",")
                    let startTime = Int(times[0])
                    let endTime = Int(times[1])
                    siteSpecificUnlockTimes.append([startTime!, endTime!])
                }
            }
        }
    }
    
    task.resume()
}

// Freezer Settings - Server Communications
func serverComms_freezerSettings (rscMgr: RscMgr) {
    
    // Create NSURL Object
    let locationName_url = "?locationName=" + defaults.string(forKey: "location")!
    var urlWithParams = freezerSettingsAddress + locationName_url
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
            
            let responseArray = responseString.components(separatedBy: ";")
            
            if ( responseArray[0] == "Exists" ) {
                if ( responseArray[1].characters.count > 0 ) {
                    let items = responseArray[1].components(separatedBy: ",")
                    let freezerInterval = items[0]
                    let lowTemp = items[1]
                    let highTemp = items[2]
                    
                    // Send "FreezerSettings:freezerInterval,lowTemp,highTemp\n"
                    let commString = "FreezerSettings:" + freezerInterval + "," + lowTemp + "," + highTemp + "\n"
                    NSLog(commString)
                    rscMgr.write(commString)
                }
            }
        }
    }
    
    task.resume()
}

// Price Settings - Server Communications
func serverComms_priceSettings ( ) -> Bool {
    var returnVar = false
    
    // Create NSURL Object
    let locationName_url = "?locationName=" + defaults.string(forKey: "location")!
    var urlWithParams = priceSettingsAddresss + locationName_url
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
            
            // Price information
            let priceString = (responseString.components(separatedBy: "</PRICE>")[0]).components(separatedBy: "<PRICE>")[1]
            if priceString.range(of:",") != nil{
                let priceArray = priceString.components(separatedBy: ",")
                payment_priceSet = true
                payment_employeeThreshold = Int(priceArray[0])!
                payment_thresholdConfig = Int(priceArray[1])!
                payment_threshold1 = Int(priceArray[2])!
                payment_threshold2 = Int(priceArray[4])!
                payment_price1 = Float(priceArray[3])!
                payment_price2 = Float(priceArray[5])!
            }
            
            // Subscription information
            let subscriptionString = ((responseString.components(separatedBy: "</SUBSCRIPTION>")[0]).components(separatedBy: "<SUBSCRIPTION>")[1])
            if subscriptionString.range(of:",") != nil{
                let subscriptionArray = subscriptionString.components(separatedBy: ",")
                subscription_priceSet = true
                subscription_smoothieCount1 = Int(subscriptionArray[0])!
                subscription_smoothieCount2 = Int(subscriptionArray[2])!
                subscription_smoothieCount3 = Int(subscriptionArray[4])!
                subscription_smoothiePrice1 = Float(subscriptionArray[1])!
                subscription_smoothiePrice2 = Float(subscriptionArray[3])!
                subscription_smoothiePrice3 = Float(subscriptionArray[5])!
                returnVar = true
            }
        }
    }
    task.resume()
    return returnVar
}
