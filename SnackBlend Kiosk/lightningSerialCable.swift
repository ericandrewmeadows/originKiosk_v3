//
//  lightningSerialCable.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/13/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

var rscMgr:  RscMgr!     // RscMgr handles the serial communication
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let unitTesting = appDelegate.unitTesting

class LightningSerialCable: NSObject, RscMgrDelegate {
    
    var arduinoRx_message = String()
    func enableComms() {
        rscMgr = RscMgr()
        rscMgr.setDelegate(self)
        rscMgr.enableExternalLogging(true)
    }
    
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
                    let processStatus = paymentFunctions.processPayment(method: methodToExecute, arduinoRx_message: arduinoRx_message, ccInfo_chargeUser: 1, subscription: 0)
                    if (processStatus == "Successful") {
                        paymentOr_masterUnlock = true
                        paymentFunctions.successfulPayment()
                    }
                    else if (processStatus == "Swipe Again") {
                    }
                    else if (processStatus == "Failed") {
                        paymentOr_masterUnlock = false
                        paymentFunctions.unsuccessfulPayment()
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
                
                if (arduinoRx_message == "State: Unlocked") {
                    lockState_actual = false
                }
                else if (arduinoRx_message == "State: Locked") {
                    lockState_actual = true
                }
                
                tempString = arduinoRx_message
                if (!unitTesting) {
                    arduinoFunctions.serverComms_lockCommunication(lockString: arduinoRx_message)
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
                    arduinoFunctions.serverComms_freezerCommunication(freezerString: arduinoRx_message)
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
                    arduinoFunctions.serverComms_keepAliveCommunication()
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
    
//    func extractAfterStart ( arduinoRx_message: String, startString: String ) -> String {
//        var arduinoRx_message = arduinoRx_message
//        if (arduinoRx_message.range(of:startString) == nil) {
//            return "error"
//        }
//        
//        if ((arduinoRx_message.components(separatedBy: startString).count) == 1) {
//            arduinoRx_message = ""
//        }
//        else {
//            arduinoRx_message = arduinoRx_message.components(separatedBy: startString)[1]
//        }
//        return arduinoRx_message
//    }
    
    // data is ready to read
    func readBytesAvailable(_ length: UInt32) {
        
        let data: Data = rscMgr.getDataFromBytesAvailable()   // note: may also process text using rscMgr.getStringFromBytesAvailable()
        let message = String(data: data, encoding: String.Encoding.utf8)!
        
        // This causes large log files
        // print(message)
        
        arduinoRx_message += message
        arduinoRx_message = (arduinoRx_message as NSString).replacingOccurrences(of: "?", with: "")
        NSLog("<ARDUINO_IN> = " + arduinoRx_message)
        
        let _ = processIncomingMessage()
        
    }
    
    // MARK: End of RscMgr functions
}
