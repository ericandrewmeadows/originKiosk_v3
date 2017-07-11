//
//  pinpadConfig.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

func configPinPad(screenSize: CGRect) {
    
    // Buttons
    let num_w = screenSize.width/8
    let num_h = screenSize.height/8
    
    // c#x
    let c1x = screenSize.width*(1/2 + 1/16)
    let c2x = screenSize.width*(1/2 + 1/16 + 1/8)
    let c3x = screenSize.width*(1/2 + 1/16 + 2/8)
    
    // r#y
    let r1y = screenSize.height*(1/4 + 1/8)
    let r2y = screenSize.height*(1/4 + 2/8)
    let r3y = screenSize.height*(1/4 + 3/8)
    let r4y = screenSize.height*(1/4 + 4/8)
    
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
    addBottomBorder(button: button1)
    addRightBorder(button: button1)
    
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
    addBottomBorder(button: button2)
    addRightBorder(button: button2)
    addLeftBorder(button: button2)
    
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
    addBottomBorder(button: button3)
    addLeftBorder(button: button3)
    
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
    addBottomBorder(button: button4)
    addRightBorder(button: button4)
    addTopBorder(button: button4)
    
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
    addBottomBorder(button: button5)
    addRightBorder(button: button5)
    addLeftBorder(button: button5)
    addTopBorder(button: button5)
    
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
    addBottomBorder(button: button6)
    addLeftBorder(button: button6)
    addTopBorder(button: button6)
    
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
    addBottomBorder(button: button7)
    addRightBorder(button: button7)
    addTopBorder(button: button7)
    
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
    addBottomBorder(button: button8)
    addRightBorder(button: button8)
    addLeftBorder(button: button8)
    addTopBorder(button: button8)
    
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
    addBottomBorder(button: button9)
    addLeftBorder(button: button9)
    addTopBorder(button: button9)
    
    // ROW 4
    pinpad_lowerRight.frame = CGRect(x: c1x,
                                     y: r4y,
                                     width: button1.frame.width,
                                     height: button1.frame.height)
    pinpad_lowerRight.setTitle("Cancel", for: .normal)
    pinpad_lowerRight.setTitleColor(.black, for: .normal)
    pinpad_lowerRight.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height/4)
    pinpad_lowerRight.backgroundColor = UIColor.white
    pinpad_lowerRight.layer.cornerRadius = button1.layer.cornerRadius
    pinpad_lowerRight.clipsToBounds = true
    addRightBorder(button: pinpad_lowerRight)
    addTopBorder(button: pinpad_lowerRight)
    
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
    addRightBorder(button: button0)
    addLeftBorder(button: button0)
    addTopBorder(button: button0)
    
    pinpad_lowerLeft.frame = CGRect(x: c3x,
                                    y: r4y,
                                    width: button1.frame.width,
                                    height: button1.frame.height)
    pinpad_lowerLeft.setTitle("x", for: .normal)
    pinpad_lowerLeft.setTitleColor(.clear, for: .normal)
    pinpad_lowerLeft.layer.cornerRadius = button1.layer.cornerRadius
    pinpad_lowerLeft.setImage(#imageLiteral(resourceName: "delButton_image"), for: .normal)
    pinpad_lowerLeft.clipsToBounds = true
    pinpad_lowerLeft.imageEdgeInsets = UIEdgeInsetsMake(
        button1.frame.width*0,
        button1.frame.width/8,
        button1.frame.width*0,
        button1.frame.width/8)
    pinpad_lowerLeft.contentMode = .scaleAspectFit
    pinpad_lowerLeft.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
    pinpad_lowerLeft.backgroundColor = UIColor.white
    addLeftBorder(button: pinpad_lowerLeft)
    addTopBorder(button: pinpad_lowerLeft)
}

// border
let border_c = UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1.0).cgColor
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
