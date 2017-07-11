//
//  fileManagement.swift
//  originKiosk_v2
//
//  Created by Eric Meadows on 6/21/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
let documentsDirectory = paths[0]

func createLogs () {
    let fileName = "\(Date()).log"
    let logFilePath = (documentsDirectory as NSString).appendingPathComponent(fileName)
    freopen(logFilePath.cString(using: String.Encoding.ascii)!, "a+", stderr)
}

func uploadLogs() {
    // Dispatch async to upload file on load and delete old file
    defaults.set(UIDevice.current.name, forKey: "location")
    defaults.set("1.1", forKey: "version")

    let filemanager:FileManager = FileManager()
    let files = filemanager.enumerator(atPath: documentsDirectory)
    var logFile = ""
    while let file = files?.nextObject() {
        logFile = documentsDirectory + "/" + String(describing: file)
        sendLogFile(dataFile_path: logFile)
    }
}
