//
//  animationWindow.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/11/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

let π:CGFloat = CGFloat(Double.pi)
let lockState_animation_timeInterval = 0.01

@IBDesignable class CircularMeter: UIView {
    
    // @IBInspectable var counterColor: UIColor = UIColor(red: 50/255,
    //                                                    green: 205/255,
    //                                                    blue: 50/255,
    //                                                    alpha: 0.64)
    
    @IBInspectable var counterColor: UIColor = UIColor.black
    
    func reloadData () {
        setNeedsDisplay()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        
        self.addSubview(lockUnlockImage_view)
        
        // Previously used for stress number - now used for lock image
        // var newFrame:  CGRect = CGRectMake(bounds.width/4,
        //                                    bounds.height/4,
        //                                    bounds.width/2,
        //                                    bounds.height/2);
        
        // stressIndex_number?.frame = newFrame
        
        // Main variables
        let center = CGPoint(x: bounds.width / 2,y: bounds.width / 2)
        let arcWidth: CGFloat = screenSize.width / 128 //radius/2 for filled circle
        let radius = bounds.width / 2 - arcWidth / 2
        
        // Draw outer meter (data)
        let startAngle:  CGFloat = 0
        let endAngle = 2 * π * (unlockTime_remaining / unlockTime_max)
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = arcWidth
        path.lineCapStyle = CGLineCap.round
        counterColor.setStroke()
        path.stroke()
    }
}
