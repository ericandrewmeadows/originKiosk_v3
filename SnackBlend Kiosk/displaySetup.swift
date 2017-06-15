//
//  displaySetup.swift
//  originKiosk_v2
//
//  Created by Eric Meadows on 6/15/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

func setOrientation_landscapeLeft_andBrightnessFull_andNoLock () {
    let value = UIInterfaceOrientation.landscapeLeft.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    UIScreen.main.brightness = CGFloat(1.0)
    UIApplication.shared.isIdleTimerDisabled = true
}
