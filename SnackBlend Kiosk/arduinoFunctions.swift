//
//  arduinoFunctions.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation

// - Lock and Unlock Constants -
let unlockString = "UNLOCK\n"
let lockString = "LOCK\n"

var lockState_verification_locked = false
var lockState_verification_unlocked = false

var lockState_sequenceStarted_unlocked = false

var lockState_repeatLockComms_unlocked_timer: Timer?
let lockState_repeatLockComms_timeInterval = 0.1

class ArduinoFunctions: NSObject {
    
    // Locking Functions - with Challenge & Response verification
    // Lock State - Unlock
    func arduinoLock_unlock () {
        if (!lockState_sequenceStarted_unlocked) {
            lockState_sequenceStarted_unlocked = true
            unlockTime_remaining = unlockTime_max
            paymentFunctions.killUnlockTimer()
            sendLockMessage_unlock()
            lockMessage_loop_unlock()
        }
        else {
            lockState_repeatLockComms_unlocked_timer = nil
            if (!lockState_verification_unlocked) { // Unlock Sent & Unverified -> Send Unlock => Verify
                sendLockMessage_unlock()
                lockMessage_loop_unlock()
            }
            else { // Unlock Verified
                lockState_sequenceStarted_unlocked = false
                unlockCountdown_timer = Timer.scheduledTimer(timeInterval: lockState_animation_timeInterval,
                                                             target: PaymentViewController.self,
                                                             selector: #selector(PaymentViewController.unlockTimer_timeRemaining_local),
                                                             userInfo: nil, repeats: true)
            }
        }
    }
    // Lock State - Lock
    func arduinoLock_lock () {
        if (!lockState_sequenceStarted_unlocked) {
            lockState_repeatLockComms_unlocked_timer = nil
            if (!lockState_verification_locked) { // Lock Sent & Unverified -> Send Unlock => Verify
                sendLockMessage_lock()
                lockMessage_loop_lock()
            }
            else { // Lock Verified
                setLockImage_locked()
            }
        }
    }
    
    // Lock State - Sender Functions
    func sendLockMessage_unlock () {
        rscMgr.write(unlockString)
        serverComms_lockCommunication(lockString: "Sent: Unlock")
        lockState_transmitted = false
    }
    func sendLockMessage_lock () {
        if (paymentOr_masterUnlock == true) {
            paymentOr_masterUnlock = false
        }
        rscMgr.write(lockString)
        lockState_transmitted = true
        serverComms_lockCommunication(lockString: "Sent: Lock")
    }
    
    // Lock State - Repetition Mechanisms
    func lockMessage_loop_unlock () {
        lockState_repeatLockComms_unlocked_timer = Timer.scheduledTimer(timeInterval: lockState_repeatLockComms_timeInterval,
                                                                        target: self,
                                                                        selector: #selector(arduinoLock_unlock),
                                                                        userInfo: nil, repeats: false)
    }
    func lockMessage_loop_lock () {
        lockState_repeatLockComms_unlocked_timer = Timer.scheduledTimer(timeInterval: lockState_repeatLockComms_timeInterval,
                                                                        target: self,
                                                                        selector: #selector(arduinoLock_lock),
                                                                        userInfo: nil, repeats: false)
    }

    // Lock State - Verification
    func verifyState_lock_locked () {
        if (true && lockState_actual && lockState_transmitted) {
            NSLog("<LOCK_VERIFICATION> = LOCKED : OK")
            lockState_verification_locked = true
        }
        else {
            NSLog("<LOCK_VERIFICATION> = LOCKED : NG")
            lockState_verification_locked = false
        }
    }
    func verifyState_lock_unlocked () {
        if !(false || lockState_actual || lockState_transmitted) {
            NSLog("<LOCK_VERIFICATION> = UNLOCKED : OK")
            lockState_verification_unlocked = true
        }
        else {
            NSLog("<LOCK_VERIFICATION> = UNLOCKED : NG")
            lockState_verification_unlocked = false
        }
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
        
        NSLog("<URL_LOCK> = " + urlWithParams)
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
    func serverComms_siteSpecificUnlockTimes() {
        
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
    func serverComms_freezerSettings () {
        
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
                        NSLog("<ARDUINO_OUT> = " + commString)
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
}
