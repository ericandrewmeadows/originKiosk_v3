//
//  pinpadConfig.swift
//  originKiosk
//
//  Created by Eric Meadows on 7/10/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation
import UIKit

// Global Display Elements
var logoImage_view = UIImageView()
var circularMeter = CircularMeter()
var lockUnlockImage_view = UIImageView()
var backArrow_button = UIButton()

// Payment Status Visual Elements
// Processing
// Processing Icon
let processingIcon_maxCount = 3
var processingIcon_count = 0
let processingPayment_circle = CAShapeLayer()
let processingPayment_processingIcon = UILabel()
let processingPayment_processingIcon_string = NSMutableAttributedString()
let processingPayment_textAttrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "SegoeUISymbol", size: processingPayment_processingIcon.frame.height * 2 / 3)!]
let processingText = "\u{2022}\u{2022}\u{2022}"
// Labels
let processingPayment_label = UILabel()
var processingPayment_timer: Timer?
let processingPayment_timeInterval = 0.25

// Successful
let successfulPaymentImage_view = UIImageView()
let successfulPayment_label = UILabel()
// Declined
let declinedPaymentImage_view = UIImageView()
let declinedPayment_label = UILabel()
// Swipe Error
let invalidPaymentImage_view = UIImageView()
let invalidPayment_label = UILabel()

// Success Fade
var successfulPayment_elementFade_timer: Timer?
var successfulPayment_elementFade_timeInterval = 2.0
// Declined Fade
var declinedPayment_elementFade_timer: Timer?
var declinedPayment_elementFade_timeInterval = 3.0
// Invalid Fade
var invalidPayment_elementFade_timer: Timer?
var invalidPayment_elementFade_timeInterval = 3.0

// Receipt Yes No Fade
var receiptYesNo_elementFade_timer: Timer?
var receiptYesNo_elementFade_timeInterval = 0.1
var receiptYesNo_elementFade_timeMax: CGFloat = 5.0
var receiptYesNo_elementFade_timeRemaining: CGFloat = 0.0

// Lightning Cable - Connection Status Indicator
var lightningCableConnectionImage_view = UIImageView()
var lightningCableConnection_elementFade_timer: Timer?
var lightningCableConnection_elementFade_timeInterval = 0.1
var lightningCableConnection_elementFade_timeMax: CGFloat = 5.0
var lightningCableConnection_elementFade_timeRemaining: CGFloat = 0.0

// Logo - Functions as a non-changing button
let logoButton  = UIButton(type: .custom)

var swipeImage_view = UIImageView()
let instructionsText = UILabel()


let subscribeButton = UIButton()
let priceLabel = UILabel()
let subscribeLabel = UILabel()
let subscribeDetails = UILabel()

let enterYourPhoneNumber = UILabel()
let phoneNumberDisplay = UILabel()
let abovePhoneLayer = CAShapeLayer()
let belowPhoneLayer = CAShapeLayer()

let leftRightDividerLineLayer = CAShapeLayer()

let circle1 = CAShapeLayer()

var swipeImage = UIImage()
var pinPadImage = UIImage()

let priceLineLayer = CAShapeLayer()
var clearPhoneButton = UIButton()
let checkMark = UILabel()
let paymentSuccessfulLabel = UILabel()

let button1 = UIButton()
let button2 = UIButton()
let button3 = UIButton()
let button4 = UIButton()
let button5 = UIButton()
let button6 = UIButton()
let button7 = UIButton()
let button8 = UIButton()
let button9 = UIButton()
let button0 = UIButton()
let pinpad_lowerLeft = UIButton()
let pinpad_lowerRight = UIButton()

var instructionsButton1 = UIButton()
var instructionsLabel1 = UILabel()
var instructionsButton2 = UIButton()
var instructionsLabel2 = UILabel()
var instructionsButton3 = UIButton()
var instructionsLabel3 = UILabel()
var instructionsButton4 = UIButton()
var instructionsLabel4 = UILabel()

// Screen - Follow Instructions
var instructionsImage_view = UIImageView()
var instructionsLabel = UILabel()
var instructionsImage_sequence_number = 0
let instructionsImage_sequence_maxCount = 5
var instructionsImage_sequence_timer: Timer?
var instructionsImage_sequence_timeInterval = 1.5 // Longer on the first graphic (Freezer Unlocked)
let instructionsImage_sequence_timeInterval_final = 3.0

// Screen - Receipt Sent via SMS
var receiptSent_receiptImage_view = UIImageView()
var receiptSent_sentArrowImage_view = UIImageView()
var receiptSent_phoneImage_view = UIImageView()
var receiptSentLabel = UILabel()
var receiptSentScene_timer: Timer?
var receiptSentScene_timeInterval = 3.0

// Screen - SMS Receipt
var receiptImage_view = UIImageView()
var smsReceiptLabel = UILabel()
var receiptYes = UIButton()
var receiptNo = UIButton()

class DisplayItems: NSObject {
    func configPinPad() {
        
        // Pin Pad for Phone Number
        // Buttons
        let num_w = screenSize.width * 35 / 256
        let num_h = screenSize.height * 35 / 384
        
        // c#x
        let c1x = screenSize.width * 97 / 1024
        let c2x = screenSize.width * 237 / 1024
        let c3x = screenSize.width * 377 / 1024
        
        // r#y
        let r1y = screenSize.height * 241 / 384
        let r2y = screenSize.height * 23 / 32
        let r3y = screenSize.height * 311 / 384
        let r4y = screenSize.height * 173 / 192
        
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
        pinpad_lowerLeft.frame = CGRect(x: c1x,
                                         y: r4y,
                                         width: button1.frame.width,
                                         height: button1.frame.height)
        pinpad_lowerLeft.setTitle("x", for: .normal)
        pinpad_lowerLeft.setTitleColor(.clear, for: .normal)
        pinpad_lowerLeft.layer.cornerRadius = button1.layer.cornerRadius
        pinpad_lowerLeft.contentMode = .scaleAspectFit
        pinpad_lowerLeft.setImage(#imageLiteral(resourceName: "delButton_image"), for: .normal)
        pinpad_lowerLeft.clipsToBounds = true
        pinpad_lowerLeft.imageEdgeInsets = UIEdgeInsetsMake(
            button1.frame.width*0,
            button1.frame.width/4,
            button1.frame.width*0,
            button1.frame.width/4)
        pinpad_lowerLeft.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height*2/3)
        pinpad_lowerLeft.backgroundColor = UIColor.white
        addRightBorder(button: pinpad_lowerLeft)
        addTopBorder(button: pinpad_lowerLeft)
        
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
        
        pinpad_lowerRight.frame = CGRect(x: c3x,
                                        y: r4y,
                                        width: button1.frame.width,
                                        height: button1.frame.height)
        pinpad_lowerRight.setTitle("Submit", for: .normal)
        pinpad_lowerRight.setTitleColor(.white, for: .normal)
        pinpad_lowerRight.backgroundColor = UIColor(red: 29.0/255.0, green: 177.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        pinpad_lowerRight.titleLabel?.font = UIFont.boldSystemFont(ofSize: button1.frame.height/3)
        pinpad_lowerRight.layer.cornerRadius = button1.layer.cornerRadius
        pinpad_lowerRight.clipsToBounds = true
        addLeftBorder(button: pinpad_lowerRight)
        addTopBorder(button: pinpad_lowerRight)
        
        // Enter Your Phone Number - Text
        enterYourPhoneNumber.frame = CGRect(x: screenSize.width * 49 / 1024,
                                            y: screenSize.height * 293 / 768,
                                            width: screenSize.width / 2,
                                            height: screenSize.height * 51 / 768)
        enterYourPhoneNumber.textAlignment = NSTextAlignment.center
        enterYourPhoneNumber.baselineAdjustment = UIBaselineAdjustment.alignCenters
        enterYourPhoneNumber.font = UIFont(name: "AvenirNext-Bold", size: screenSize.height * 3 / 64)
        enterYourPhoneNumber.numberOfLines = 0
        enterYourPhoneNumber.frame.size.width = screenSize.width / 2
        enterYourPhoneNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        enterYourPhoneNumber.text = "Enter your phone number"

        
        // Phone Number Display
        phoneNumberDisplay.frame = CGRect(x: screenSize.width / 20,
                                          y: screenSize.height * 193 / 384,
                                          width: screenSize.width / 2,
                                          height: screenSize.height * 65 / 768)
        phoneNumberDisplay.textAlignment = NSTextAlignment.center
        phoneNumberDisplay.baselineAdjustment = UIBaselineAdjustment.alignCenters
        phoneNumberDisplay.font = UIFont(name: "Arial", size: screenSize.height / 16)
        phoneNumberDisplay.numberOfLines = 0
        phoneNumberDisplay.frame.size.width = screenSize.width / 2
        phoneNumberDisplay.lineBreakMode = NSLineBreakMode.byWordWrapping
        // phoneNumberDisplay.text = "(937) 776-1657"
        phoneNumberDisplay.text = " "
        
        // Cancel Circle
        clearPhoneButton = UIButton(type: .custom)
        clearPhoneButton.frame = CGRect(x: screenSize.width * 533 / 1024,
                                        y: screenSize.height * 67 / 128,
                                        width: screenSize.width / 32,
                                        height: screenSize.width / 32)
        clearPhoneButton.layer.cornerRadius = 0.5 * clearPhoneButton.bounds.size.width
        clearPhoneButton.clipsToBounds = true
        clearPhoneButton.layer.borderWidth = screenSize.width / 512
        clearPhoneButton.layer.borderColor = UIColor.red.cgColor
        clearPhoneButton.setTitle("X", for: .normal)
        clearPhoneButton.setTitleColor(.red, for: .normal)
        clearPhoneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: clearPhoneButton.frame.height / 2)
        
        // Instructions
        // Set 1
        instructionsButton1 = UIButton(type: .custom)
        instructionsButton1.frame = CGRect(x: screenSize.width * 161 / 256,
                                           y: screenSize.height * 143 / 384,
                                           width: screenSize.width / 16,
                                           height: screenSize.width / 16)
        instructionsButton1.layer.cornerRadius = 0.5 * instructionsButton1.bounds.size.width
        instructionsButton1.clipsToBounds = true
        instructionsButton1.layer.borderWidth = screenSize.width * 3 / 1024
        instructionsButton1.layer.borderColor = UIColor.black.cgColor
        instructionsButton1.setTitle("1", for: .normal)
        instructionsButton1.setTitleColor(.black, for: .normal)
        instructionsButton1.titleLabel?.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 3 / 64)
        
        instructionsLabel1.frame = CGRect(x: screenSize.width * 363 / 512,
                                          y: screenSize.height * 297 / 768,
                                          width: screenSize.width * 35 / 128,
                                          height: screenSize.height * 41 / 768)
        instructionsLabel1.textAlignment = NSTextAlignment.left
        instructionsLabel1.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsLabel1.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 7 / 192)
        instructionsLabel1.numberOfLines = 0
        instructionsLabel1.frame.size.width = screenSize.width * 35 / 128
        instructionsLabel1.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructionsLabel1.text = "Grab smoothie pod"
        
        // Set 2
        instructionsButton2 = UIButton(type: .custom)
        instructionsButton2.frame = CGRect(x: screenSize.width * 161 / 256,
                                           y: screenSize.height * 69 / 128,
                                           width: screenSize.width / 16,
                                           height: screenSize.width / 16)
        instructionsButton2.layer.cornerRadius = 0.5 * instructionsButton2.bounds.size.width
        instructionsButton2.clipsToBounds = true
        instructionsButton2.layer.borderWidth = screenSize.width * 3 / 1024
        instructionsButton2.layer.borderColor = UIColor.black.cgColor
        instructionsButton2.setTitle("2", for: .normal)
        instructionsButton2.setTitleColor(.black, for: .normal)
        instructionsButton2.titleLabel?.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 3 / 64)
        
        instructionsLabel2.frame = CGRect(x: screenSize.width * 363 / 512,
                                          y: screenSize.height * 425 / 768,
                                          width: screenSize.width * 35 / 128,
                                          height: screenSize.height * 41 / 768)
        instructionsLabel2.textAlignment = NSTextAlignment.left
        instructionsLabel2.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsLabel2.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 7 / 192)
        instructionsLabel2.numberOfLines = 0
        instructionsLabel2.frame.size.width = screenSize.width * 35 / 128
        instructionsLabel2.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructionsLabel2.text = "Add almond milk"
        
        // Set 3
        instructionsButton3 = UIButton(type: .custom)
        instructionsButton3.frame = CGRect(x: screenSize.width * 161 / 256,
                                           y: screenSize.height * 271 / 384,
                                           width: screenSize.width / 16,
                                           height: screenSize.width / 16)
        instructionsButton3.layer.cornerRadius = 0.5 * instructionsButton3.bounds.size.width
        instructionsButton3.clipsToBounds = true
        instructionsButton3.layer.borderWidth = screenSize.width * 3 / 1024
        instructionsButton3.layer.borderColor = UIColor.black.cgColor
        instructionsButton3.setTitle("3", for: .normal)
        instructionsButton3.setTitleColor(.black, for: .normal)
        instructionsButton3.titleLabel?.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 3 / 64)
        
        instructionsLabel3.frame = CGRect(x: screenSize.width * 363 / 512,
                                          y: screenSize.height * 553 / 768,
                                          width: screenSize.width * 35 / 128,
                                          height: screenSize.height * 41 / 768)
        instructionsLabel3.textAlignment = NSTextAlignment.left
        instructionsLabel3.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsLabel3.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 7 / 192)
        instructionsLabel3.numberOfLines = 0
        instructionsLabel3.frame.size.width = screenSize.width * 35 / 128
        instructionsLabel3.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructionsLabel3.text = "Blend pod"
        
        // Set 4
        instructionsButton4 = UIButton(type: .custom)
        instructionsButton4.frame = CGRect(x: screenSize.width * 161 / 256,
                                           y: screenSize.height * 335 / 384,
                                           width: screenSize.width / 16,
                                           height: screenSize.width / 16)
        instructionsButton4.layer.cornerRadius = 0.5 * instructionsButton4.bounds.size.width
        instructionsButton4.clipsToBounds = true
        instructionsButton4.layer.borderWidth = screenSize.width * 3 / 1024
        instructionsButton4.layer.borderColor = UIColor.black.cgColor
        instructionsButton4.setTitle("4", for: .normal)
        instructionsButton4.setTitleColor(.black, for: .normal)
        instructionsButton4.titleLabel?.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 3 / 64)
        
        instructionsLabel4.frame = CGRect(x: screenSize.width * 363 / 512,
                                          y: screenSize.height * 681 / 768,
                                          width: screenSize.width * 35 / 128,
                                          height: screenSize.height * 41 / 768)
        instructionsLabel4.textAlignment = NSTextAlignment.left
        instructionsLabel4.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsLabel4.font = UIFont(name: "HelveticaNeue", size: screenSize.height * 7 / 192)
        instructionsLabel4.numberOfLines = 0
        instructionsLabel4.frame.size.width = screenSize.width * 35 / 128
        instructionsLabel4.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructionsLabel4.text = "Pour & enjoy"
        
        // Receipt Information
        // Receipt Icon
        let receipt_imageName = "receiptImage.png"
        let receiptImage = UIImage(named: receipt_imageName)!
        receiptImage_view = UIImageView(image: receiptImage)
        receiptImage_view.frame = CGRect(x: screenSize.width * 29 / 128,
                                         y: screenSize.height * 309 / 768,
                                         width: screenSize.width * 75 / 512,
                                         height: screenSize.width * 75 / 512)
        receiptImage_view.contentMode = .scaleAspectFit
        
        // Receipt Label
        smsReceiptLabel.frame = CGRect(x: screenSize.width * 41 / 1024,
                                       y: screenSize.height * 539 / 768,
                                       width: screenSize.width * 133 / 256,
                                       height: screenSize.height * 7 / 64)
        smsReceiptLabel.textAlignment = NSTextAlignment.center
        smsReceiptLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        smsReceiptLabel.font = UIFont(name: "HelveticaNeue-Bold", size: screenSize.height / 12)
        smsReceiptLabel.numberOfLines = 0
        smsReceiptLabel.frame.size.width = screenSize.width * 133 / 256
        smsReceiptLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        smsReceiptLabel.text = "SMS Receipt?"
        
        // Receipts - Yes
        receiptYes.frame = CGRect(x: screenSize.width * 149 / 1024,
                                  y: screenSize.height * 651 / 768,
                                  width: screenSize.width / 8,
                                  height: screenSize.width / 12)
        receiptYes.layer.cornerRadius = screenSize.width * 15 / 1024
        receiptYes.layer.borderWidth = screenSize.width * 3 / 512
        receiptYes.layer.borderColor = UIColor.black.cgColor
        receiptYes.setTitle("Yes", for: .normal)
        receiptYes.setTitleColor(.black, for: .normal)
        receiptYes.setTitleColor(.white, for: .highlighted)
        receiptYes.setBackgroundColor(color: .black, forState: .highlighted)
        receiptYes.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: screenSize.height * 3 / 64)
        
        // Receipts - No
        receiptNo.frame = CGRect(x: screenSize.width * 337 / 1024,
                                 y: screenSize.height * 651 / 768,
                                 width: screenSize.width / 8,
                                 height: screenSize.width / 12)
        receiptNo.layer.cornerRadius = screenSize.width * 15 / 1024
        receiptNo.layer.borderWidth = screenSize.width * 3 / 512
        receiptNo.layer.borderColor = UIColor.black.cgColor
        receiptNo.setTitle("No", for: .normal)
        receiptNo.setTitleColor(.black, for: .normal)
        receiptNo.setTitleColor(.white, for: .highlighted)
        receiptNo.setBackgroundColor(color: .black, forState: .highlighted)
        receiptNo.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: screenSize.height * 3 / 64)

        // Screen - Follow Instructions
        // Instructions Graphic
        instructionsImage_view.frame = CGRect(x: screenSize.width * 17 / 128,
                                              y: screenSize.height * 313 / 768,
                                              width: screenSize.width / 3,
                                              height: screenSize.height / 3)
        instructionsImage_view.layer.borderWidth = 8
        instructionsImage_view.layer.borderColor = UIColor.black.cgColor
        instructionsImage_view.layer.cornerRadius = 4
        instructionsImage_view.image = UIImage(named: "appChecklist_steps_0")
        
        // Instructions Label
        instructionsLabel.frame = CGRect(x: screenSize.width / 20,
                                         y: screenSize.height * 103 / 128,
                                         width: screenSize.width / 2,
                                         height: screenSize.height * 65 / 768)
        instructionsLabel.textAlignment = NSTextAlignment.center
        instructionsLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: screenSize.height / 16)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructionsLabel.text = "Follow Instructions"
        
        // Screen - Receipt Sent via SMS
        // SMS Receipt Sent Label
        receiptSentLabel.frame = CGRect(x: screenSize.width / 20,
                                        y: screenSize.height * 103 / 128,
                                        width: screenSize.width / 2,
                                        height: screenSize.height * 65 / 768)
        receiptSentLabel.textAlignment = NSTextAlignment.center
        receiptSentLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        receiptSentLabel.font = UIFont(name: "HelveticaNeue-Bold", size: screenSize.height / 16)
        receiptSentLabel.numberOfLines = 0
        receiptSentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        receiptSentLabel.text = "SMS Receipt Sent"
        
        // Receipt Being Sent Image
        receiptSent_receiptImage_view.frame = CGRect(x: screenSize.width * 119 / 1024,
                                                     y: screenSize.height * 57 / 128,
                                                     width: screenSize.width * 75 / 512,
                                                     height: screenSize.width * 75 / 512)
        receiptSent_receiptImage_view.image = UIImage(named: "receiptImage")
        receiptSent_receiptImage_view.contentMode = .scaleAspectFit
        
        // Sent Arrow Image
        receiptSent_sentArrowImage_view.frame = CGRect(x: screenSize.width * 283 / 1024,
                                                       y: screenSize.height * 393 / 768,
                                                       width: screenSize.width * 3 / 64,
                                                       height: screenSize.width * 3 / 64)
        receiptSent_sentArrowImage_view.image = UIImage(named: "forwardArrow")
        receiptSent_sentArrowImage_view.contentMode = .scaleAspectFit
        
        // Phone Receiving SMS Image
        receiptSent_phoneImage_view.frame = CGRect(x: screenSize.width * 87 / 256,
                                                   y: screenSize.height * 19 / 48,
                                                   width: screenSize.width * 3 / 16,
                                                   height: screenSize.width * 3 / 16)
        receiptSent_phoneImage_view.image = UIImage(named: "phone_smsReceived")
        receiptSent_phoneImage_view.contentMode = .scaleAspectFit

        // Phone Number - Separator Lines
        // Above Line
        let abovePhonePath = UIBezierPath(rect: CGRect(x: screenSize.width * 97 / 1024,
                                                       y: screenSize.height * 31 / 64,
                                                       width: screenSize.width * 105 / 256,
                                                       height: screenSize.height / 384))
        abovePhoneLayer.path = abovePhonePath.cgPath
        abovePhoneLayer.strokeColor = UIColor.black.cgColor
        abovePhoneLayer.fillColor = UIColor.black.cgColor
        abovePhonePath.stroke()
        
        // Below Line
        let belowPhonePath = UIBezierPath(rect: CGRect(x: screenSize.width * 97 / 1024,
                                                       y: screenSize.height * 465 / 768,
                                                       width: screenSize.width * 105 / 256,
                                                       height: screenSize.height / 384))
        belowPhoneLayer.path = belowPhonePath.cgPath
        belowPhoneLayer.strokeColor = UIColor.black.cgColor
        belowPhoneLayer.fillColor = UIColor.black.cgColor
        belowPhonePath.stroke()
        
        // Divider Line between Left and Right side of iPad
        
        let dividerPath = UIBezierPath(rect: CGRect(x: screenSize.width * 613 / 1024,
                                                    y: screenSize.height * 45 / 128,
                                                    width: screenSize.width * 1 / 1024,
                                                    height: screenSize.height * 5 / 8))
        leftRightDividerLineLayer.path = dividerPath.cgPath
        leftRightDividerLineLayer.strokeColor = UIColor.black.cgColor
        leftRightDividerLineLayer.fillColor = UIColor.black.cgColor
        dividerPath.stroke()
        
        // Unlock Meter View
        circularMeter.frame = CGRect(x: screenSize.width * 377 / 512,
                                     y: screenSize.height * 71 / 768,
                                     width: screenSize.width / 8,
                                     height: screenSize.width / 8)
        circularMeter.backgroundColor = UIColor.white
        
        lockUnlockImage_view.frame = CGRect(x: circularMeter.bounds.width / 4,
                                            y: circularMeter.bounds.height / 4,
                                            width: circularMeter.bounds.width / 2,
                                            height: circularMeter.bounds.height / 2)
        circularMeter.addSubview(lockUnlockImage_view)
        
        // Back Navigation Arrow
        backArrow_button.frame = CGRect(x: screenSize.width * 25 / 1024,
                                        y: screenSize.height * 197 / 384,
                                        width: screenSize.width * 3 / 64,
                                        height: screenSize.width * 3 / 64)
        backArrow_button.layer.cornerRadius = button1.layer.cornerRadius
        backArrow_button.contentMode = .scaleAspectFit
        backArrow_button.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backArrow_button.clipsToBounds = true
        backArrow_button.backgroundColor = UIColor.white
        
        
        // Logo Icon
        let logoImage = UIImage(named: "OriginLogo")!
        logoImage_view = UIImageView(image: logoImage)
        logoImage_view.frame = CGRect(x: screenSize.width * 3 / 32,
                                      y: screenSize.height * 13 / 192,
                                      width: screenSize.width * 211 / 512,
                                      height: screenSize.height * 83 / 384)
        logoImage_view.contentMode = .scaleAspectFit
        logoImage_view.isHidden = true
        
        logoButton.setImage(UIImage(named: "OriginLogo.png"), for: .normal)
        logoButton.frame = logoImage_view.frame
        logoButton.contentMode = .scaleAspectFit
        
        // Line between Logo and Price
        let priceLinePath = UIBezierPath(rect: CGRect(x: screenSize.width * 101 / 1024,
                                                      y: screenSize.height * 57 / 128,
                                                      width: screenSize.width * 103 / 256,
                                                      height: screenSize.height / 384))
        priceLineLayer.path = priceLinePath.cgPath
        priceLineLayer.strokeColor = UIColor.black.cgColor
        priceLineLayer.fillColor = UIColor.black.cgColor
        priceLinePath.stroke()
        
        // Swipe Icon
        swipeImage = UIImage(named: "creditCardSwipe.png")!
        swipeImage_view.image = swipeImage
        swipeImage_view.frame = CGRect(x: screenSize.width * 29 / 128,
                                       y: screenSize.height * 405 / 768,
                                       width: screenSize.width * 75 / 512,
                                       height: screenSize.width * 75 / 512)
        swipeImage_view.contentMode = .scaleAspectFit
        swipeImage_view.isHidden = false
        
        // Instructions Text - Label
        instructionsText.frame = CGRect(x: screenSize.width / 20,
                                        y: screenSize.height * 589 / 768,
                                        width: screenSize.width / 2,
                                        height: screenSize.height * 5 / 24)
        instructionsText.textAlignment = NSTextAlignment.center
        instructionsText.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionsText.font = UIFont(name: "Arial", size: screenSize.height / 16)
        instructionsText.numberOfLines = 0
        instructionsText.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let formattedString = NSMutableAttributedString()
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: screenSize.height / 16)!]
        let text = "Swipe Credit Card\nto start"
        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
        instructionsText.attributedText = formattedString
        
        // Lightning Cable - Connection Status
        lightningCableConnectionImage_view.frame = CGRect(x: screenSize.width * 15 / 16,
                                                          y: screenSize.height / 24,
                                                          width: screenSize.width / 32,
                                                          height: screenSize.width / 32)
        lightningCable_disconnected()

        
        // Payment Processing Status
        // - Circles -
        let circle_r = screenSize.width * 75 / 1024
        let circle_x = screenSize.width * 29 / 128 + circle_r
        let circle_y = screenSize.height * 309 / 768 + circle_r
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: circle_x,
                               y: circle_y),
            radius: circle_r,
            startAngle: CGFloat(0), endAngle:CGFloat(2 * π), clockwise: true)
        
        // Successful Payment
        // Image
        successfulPaymentImage_view.frame = CGRect(x: screenSize.width * 29 / 128,
                                                   y: screenSize.height * 309 / 768,
                                                   width: screenSize.width * 75 / 512,
                                                   height: screenSize.width * 75 / 512)
        successfulPaymentImage_view.image = UIImage(named: "paymentSuccessful")
        successfulPaymentImage_view.contentMode = .scaleAspectFit
        
        // Label
        successfulPayment_label.frame = CGRect(x: screenSize.width / 20,
                                               y: screenSize.height * 125 / 192,
                                               width: screenSize.width / 2,
                                               height: screenSize.height / 4)
        successfulPayment_label.textAlignment = NSTextAlignment.center
        successfulPayment_label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        successfulPayment_label.font = UIFont(name: "AvenirNext-Bold", size: screenSize.height / 12)
        successfulPayment_label.numberOfLines = 0
        successfulPayment_label.lineBreakMode = NSLineBreakMode.byWordWrapping
        successfulPayment_label.text = "Successful Payment"
        successfulPayment_label.sizeThatFits(CGSize(width: successfulPayment_label.frame.width,
                                                    height: successfulPayment_label.frame.height))
        
        // Declined Payment
        // Image
        declinedPaymentImage_view.frame = CGRect(x: screenSize.width * 29 / 128,
                                                 y: screenSize.height * 309 / 768,
                                                 width: screenSize.width * 75 / 512,
                                                 height: screenSize.width * 75 / 512)
        declinedPaymentImage_view.image = UIImage(named: "paymentDeclined")
        declinedPaymentImage_view.contentMode = .scaleAspectFit
        
        // Label
        declinedPayment_label.frame = CGRect(x: screenSize.width / 20,
                                             y: screenSize.height * 65 / 96,
                                             width: screenSize.width / 2,
                                             height: screenSize.height * 5 / 24)
        declinedPayment_label.textAlignment = NSTextAlignment.center
        declinedPayment_label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        declinedPayment_label.font = UIFont(name: "AvenirNext-Bold", size: screenSize.height / 16)
        declinedPayment_label.numberOfLines = 0
        declinedPayment_label.lineBreakMode = NSLineBreakMode.byWordWrapping
        declinedPayment_label.text = "Cannot complete\nUse a Different Card"
        declinedPayment_label.sizeThatFits(CGSize(width: declinedPayment_label.frame.width,
                                                  height: declinedPayment_label.frame.height))
        
        // Invalid Payment
        // Image
        invalidPaymentImage_view.frame = CGRect(x: screenSize.width * 29 / 128,
                                                y: screenSize.height * 309 / 768,
                                                width: screenSize.width * 75 / 512,
                                                height: screenSize.width * 75 / 512)
        invalidPaymentImage_view.image = UIImage(named: "paymentInvalid")
        invalidPaymentImage_view.contentMode = .scaleAspectFit
        
        // Label
        invalidPayment_label.frame = CGRect(x: screenSize.width / 20,
                                            y: screenSize.height * 65 / 96,
                                            width: screenSize.width / 2,
                                            height: screenSize.height * 5 / 24)
        invalidPayment_label.textAlignment = NSTextAlignment.center
        invalidPayment_label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        invalidPayment_label.font = UIFont(name: "AvenirNext-Bold", size: screenSize.height / 16)
        invalidPayment_label.numberOfLines = 0
        invalidPayment_label.lineBreakMode = NSLineBreakMode.byWordWrapping
        invalidPayment_label.text = "Card not read\nUse a Different Card"
        invalidPayment_label.sizeThatFits(CGSize(width: invalidPayment_label.frame.width,
                                                 height: invalidPayment_label.frame.height))
        
//        // Circle
//        successfulPayment_circle.path = circlePath.cgPath
//        
//        successfulPayment_circle.fillColor = UIColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1.0).cgColor
//        successfulPayment_circle.strokeColor = successfulPayment_circle.fillColor
//        successfulPayment_circle.lineWidth = 3.0
//        
//        // - Check Mark -
//        successfulPayment_checkMark.frame = CGRect(x: circle_x - circle_r,
//                                                   y: circle_y - circle_r,
//                                                   width: circle_r * 2,
//                                                   height: circle_r * 2)
//        successfulPayment_checkMark.textAlignment = NSTextAlignment.center
//        successfulPayment_checkMark.baselineAdjustment = UIBaselineAdjustment.alignCenters
//        successfulPayment_checkMark.font = UIFont(name: "SegoeUISymbol", size: successfulPayment_checkMark.frame.height * 2 / 3) // SegoeUISymbol | SegoeUIEmoji
//        successfulPayment_checkMark.textColor = UIColor.white
//        successfulPayment_checkMark.numberOfLines = 0
//        successfulPayment_checkMark.lineBreakMode = NSLineBreakMode.byWordWrapping
//        successfulPayment_checkMark.text = "\u{2714}"//"✓"
        
        // - Label -
        
        // Processing
        // Circle
        processingPayment_circle.path = circlePath.cgPath
        
        processingPayment_circle.fillColor = UIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0).cgColor
        processingPayment_circle.strokeColor = processingPayment_circle.fillColor
        processingPayment_circle.lineWidth = 3.0
        
        // - Check Mark -
        processingPayment_processingIcon.frame = CGRect(x: circle_x - circle_r,
                                                   y: circle_y - circle_r * 9 / 8,
                                                   width: circle_r * 2,
                                                   height: circle_r * 2)
        processingPayment_processingIcon.textAlignment = NSTextAlignment.center
        processingPayment_processingIcon.baselineAdjustment = UIBaselineAdjustment.alignCenters
        // processingPayment_processingIcon.font = UIFont(name: "SegoeUISymbol", size: processingPayment_processingIcon.frame.height * 2 / 3) // SegoeUISymbol | SegoeUIEmoji
        // processingPayment_processingIcon.textColor = UIColor.white
        processingPayment_processingIcon.numberOfLines = 0
        processingPayment_processingIcon.lineBreakMode = NSLineBreakMode.byWordWrapping
        // processingPayment_processingIcon.text = ""
        processingPayment_processingIcon_string.append(NSMutableAttributedString(string: processingText, attributes: processingPayment_textAttrs))
        
        // - Label -
        processingPayment_label.frame = CGRect(x: screenSize.width / 20,
                                               y: screenSize.height * 125 / 192,
                                               width: screenSize.width / 2,
                                               height: screenSize.height / 4)
        processingPayment_label.textAlignment = NSTextAlignment.center
        processingPayment_label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        processingPayment_label.font = UIFont(name: "AvenirNext-Bold", size: screenSize.height / 12)
        processingPayment_label.numberOfLines = 0
        processingPayment_label.lineBreakMode = NSLineBreakMode.byWordWrapping
        processingPayment_label.text = "Processing"
        processingPayment_label.sizeThatFits(CGSize(width: processingPayment_label.frame.width,
                                                    height: processingPayment_label.frame.height))

        // Payment Display Information
        priceLabel.frame = CGRect(x: screenSize.width / 20,
                                  y: screenSize.height * 21 / 64,
                                  width: screenSize.width / 2,
                                  height: screenSize.height * 65 / 768)
        
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: screenSize.height / 16)
        priceLabel.textAlignment = .center
        priceLabel.numberOfLines = 0
        
        // Subscribe Button - added to view depending on server configuration
        subscribeLabel.frame = CGRect(x: screenSize.width / 8,
                                      y: r3y - screenSize.height / 16,
                                      width: screenSize.width / 4,
                                      height: screenSize.height / 5)
        subscribeLabel.text = "$2.99"
        subscribeLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 2)
        subscribeLabel.textAlignment = .center
        subscribeLabel.textColor = .black
        subscribeLabel.isHidden = true
        
        subscribeDetails.frame = CGRect(x: screenSize.width / 24,
                                        y: r4y,
                                        width: screenSize.width * 5 / 12,
                                        height: screenSize.height / 6)
        subscribeDetails.textAlignment = NSTextAlignment.center
        subscribeDetails.baselineAdjustment = UIBaselineAdjustment.alignCenters
        subscribeDetails.font = UIFont(name: "Arial", size: screenSize.height*(7/170))
        subscribeDetails.numberOfLines = 0
        subscribeDetails.lineBreakMode = NSLineBreakMode.byWordWrapping
        subscribeDetails.text = "3 Smoothies / Week"
        subscribeDetails.isHidden = true
        
        subscribeButton.frame = CGRect(x: screenSize.width / 12 * 3.5,
                                       y: r2y - screenSize.height / 32,
                                       width: screenSize.width / 3 / 3,
                                       height: screenSize.height / 16)
        subscribeButton.tag = 10
        subscribeButton.setTitle("Join and get it for: $3.99", for: .normal)
        
        let subscribeString = "Join"
        let title = NSMutableAttributedString(string: subscribeString as String)
        
        //  let sub_zeroAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: screenSize.height*(9/170))!] as [String : Any]
        let sub_oneAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: screenSize.height*(8/170))!] as [String : Any]
        title.addAttributes(sub_oneAttributes, range: NSMakeRange(0,title.length))
        subscribeButton.setAttributedTitle(title, for: .normal)
        
        subscribeButton.setTitleColor(.black, for: .normal)
        subscribeButton.setTitleColor(UIColor(red: 75/255.0,
                                              green: 181/255.0,
                                              blue: 67/255.0,
                                              alpha: 1.0),
                                      for: .highlighted)
        subscribeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: subscribeButton.frame.height / 2)
        subscribeButton.backgroundColor = UIColor.white
        subscribeButton.layer.borderColor = UIColor.black.cgColor
        subscribeButton.layer.borderWidth = 3
        subscribeButton.layer.cornerRadius = subscribeButton.frame.height / 4//0.5 * button1.bounds.size.width
        subscribeButton.clipsToBounds = true
        subscribeButton.isHidden = false
        
//        hideScreen_paymentSwipe() // Initial Sequence Start
        hideScreen_phonePinPad()
        hideScreen_smsReceipt()
        hideScreen_paymentSuccessful()
        hideScreen_paymentProcessing()
        hideScreen_paymentInvalid()
        hideScreen_paymentDeclined()
        hideScreen_instructionsSequence()
        hideScreen_receiptSent()
    }
    
    func lightningCable_disconnected () {
        lightningCableConnectionImage_view.isHidden = false
        lightningCableConnectionImage_view.image = UIImage(named: "disconnected")
    }
    func lightningCable_connected () {
        lightningCableConnectionImage_view.image = UIImage(named: "connected")
        lightningCableConnection_elementFade_timeRemaining = lightningCableConnection_elementFade_timeMax
        lightningCableConnection_elementFade_timer = Timer.scheduledTimer(timeInterval: lightningCableConnection_elementFade_timeInterval,
                                                                          target: self,
                                                                          selector: #selector(self.lightningCableConnection_elementFade),
                                                                          userInfo: nil, repeats: true)
    }
    func lightningCableConnection_elementFade () {
        lightningCableConnection_elementFade_timeRemaining -= CGFloat(lightningCableConnection_elementFade_timeInterval)
        if (lightningCableConnection_elementFade_timeRemaining < 0.0) {
            lightningCableConnection_elementFade_timeRemaining = 0.0
            lightningCableConnectionImage_view.isHidden = true
            lightningCableConnection_elementFade_timer?.invalidate()
            lightningCableConnection_elementFade_timer = nil
        }
    }

    // - Hide/Show Screen Functions -
    //   > Credit Card Swipe <
    func hideScreen_paymentSwipe () {
        instructionsText.isHidden = true
        priceLineLayer.isHidden = true
        priceLabel.isHidden = true
        swipeImage_view.isHidden = true
    }
    func showScreen_paymentSwipe () {
        paymentFunctions.resetPhoneNumber()
        instructionsText.isHidden = false
        priceLineLayer.isHidden = false
        priceLabel.isHidden = false
        swipeImage_view.isHidden = false
    }
    
    // SMS Receipt Sent
    func hideScreen_receiptSent () {
        receiptSentLabel.isHidden = true
        receiptSent_receiptImage_view.isHidden = true
        receiptSent_sentArrowImage_view.isHidden = true
        receiptSent_phoneImage_view.isHidden = true
    }
    func showScreen_receiptSent () {
        receiptSentLabel.isHidden = false
        receiptSent_receiptImage_view.isHidden = false
        receiptSent_sentArrowImage_view.isHidden = false
        receiptSent_phoneImage_view.isHidden = false
    }
    
    //   > Instructions Sequence <
    func hideScreen_instructionsSequence () {
        instructionsImage_view.isHidden = true
        instructionsLabel.isHidden = true
    }
    func showScreen_instructionsSequence () {
        instructionsImage_view.isHidden = false
        instructionsLabel.isHidden = false
    }

    //   > Phone Pin Pad <
    func hideScreen_phonePinPad () {
        enterYourPhoneNumber.isHidden = true
        phoneNumpad_hidden()
        backArrow_button.isHidden = true
        phonePeriphery_hidden()
    }
    func showScreen_phonePinPad () {
        enterYourPhoneNumber.isHidden = false
        phoneNumpad_visible()
        backArrow_button.isHidden = false
        phonePeriphery_visible()
        if (phoneNumStringCount > 0) {
            phonePeriphery_visible()
        }
        else {
            phonePeriphery_hidden()
        }
    }

    //   > SMS Receipt <
    func hideScreen_smsReceipt () {
        smsReceiptLabel.isHidden = true
        receiptImage_view.isHidden = true
        receiptYes.isHidden = true
        receiptNo.isHidden = true
    }
    func showScreen_smsReceipt () {
        smsReceiptLabel.isHidden = false
        receiptImage_view.isHidden = false
        receiptYes.isHidden = false
        receiptNo.isHidden = false
    }

    //   > Payments <
    //     : Successful :
    func hideScreen_paymentSuccessful () {
        successfulPaymentImage_view.isHidden = true
        successfulPayment_label.isHidden = true
    }
    func showScreen_paymentSuccessful () {
        unlockTime_remaining = unlockTime_max
        successfulPaymentImage_view.isHidden = false
        successfulPayment_label.isHidden = false
        successfulPayment_elementFade_timer = Timer.scheduledTimer(timeInterval: successfulPayment_elementFade_timeInterval,
                                                                   target: self,
                                                                   selector: #selector(self.transition_paymentSuccessful_to_smsReceipt),
                                                                   userInfo: nil, repeats: false)
    }
    //     : Declined :
    func hideScreen_paymentDeclined () {
        declinedPaymentImage_view.isHidden = true
        declinedPayment_label.isHidden = true
    }
    func showScreen_paymentDeclined () {
        declinedPaymentImage_view.isHidden = false
        declinedPayment_label.isHidden = false
        declinedPayment_elementFade_timer = Timer.scheduledTimer(timeInterval: declinedPayment_elementFade_timeInterval,
                                                                 target: self,
                                                                 selector: #selector(self.transition_paymentDeclined_to_paymentSwipe),
                                                                 userInfo: nil, repeats: false)
    }
    //     : Invalid :
    func hideScreen_paymentInvalid () {
        invalidPaymentImage_view.isHidden = true
        invalidPayment_label.isHidden = true
    }
    func showScreen_paymentInvalid () {
        invalidPaymentImage_view.isHidden = false
        invalidPayment_label.isHidden = false
        invalidPayment_elementFade_timer = Timer.scheduledTimer(timeInterval: invalidPayment_elementFade_timeInterval,
                                                                target: self,
                                                                selector: #selector(self.transition_paymentInvalid_to_paymentSwipe),
                                                                userInfo: nil, repeats: false)
    }
    
    //     = Transitions =
    //       ~ After Initial Swipe ~
    func transition_paymentSwipe_to_paymentProcessing() {
        hideScreen_paymentSwipe()
        showScreen_paymentProcessing()
    }
    
    //       ~ All Payment Processing Outcomes ~
    //         * Successful *
    func transition_paymentProcessing_to_paymentSuccessful () {
        processingPayment_displayUpdate_kill()
        hideScreen_paymentProcessing()
        showScreen_paymentSuccessful()
    }
    //         * Declined *
    func transition_paymentProcessing_to_paymentDeclined () {
        processingPayment_displayUpdate_kill()
        hideScreen_paymentProcessing()
        showScreen_paymentDeclined()
    }
    //         * Invalid *
    func transition_paymentProcessing_to_paymentSwipeAgain () {
        processingPayment_displayUpdate_kill()
        hideScreen_paymentProcessing()
        showScreen_paymentInvalid()
    }
    
    //       ~ All Transitions After Successful Payment ~
    func transition_paymentSuccessful_to_smsReceipt () {
        hideScreen_paymentSuccessful()
        showScreen_smsReceipt()
        receiptYesNo_elementFade_timeRemaining = receiptYesNo_elementFade_timeMax
        receiptYesNo_elementFade_timer = Timer.scheduledTimer(timeInterval: receiptYesNo_elementFade_timeInterval,
                                                              target: paymentFunctions.self,
                                                              selector: #selector(paymentFunctions.receiptYesNo_elementFade),
                                                              userInfo: nil, repeats: true)
    }
    func transition_smsReceipt_to_phonePinPad () {
        hideScreen_smsReceipt()
        showScreen_phonePinPad()
    }
    
    //       ~ All Transitions After Unsuccessful Payment ~
    func transition_paymentDeclined_to_paymentSwipe() {
        hideScreen_paymentDeclined()
        showScreen_paymentSwipe()
    }
    func transition_paymentInvalid_to_paymentSwipe() {
        hideScreen_paymentInvalid()
        showScreen_paymentSwipe()
    }
    // SMS Receipt Transitions
    func transition_phonePinPad_to_smsReceiptSent () {
        hideScreen_phonePinPad()
        showScreen_receiptSent()
        receiptSentScene_timer = Timer.scheduledTimer(timeInterval: receiptSentScene_timeInterval,
                                                      target: self,
                                                      selector: #selector(transition_smsReceiptYes_to_unlocked),
                                                      userInfo: nil, repeats: false)
    }
    func transition_smsReceiptYes_to_unlocked () { // User selected "Yes" & completed
        hideScreen_receiptSent()
        arduinoFunctions.arduinoLock_unlock()
        showScreen_instructionsSequence()
        instructionsImage_displayUpdate()
    }
    func transition_smsReceiptNo_to_unlocked () { // User selected "No" & then we transition to Unlocking
        hideScreen_smsReceipt()
        arduinoFunctions.arduinoLock_unlock()
        showScreen_instructionsSequence()
        instructionsImage_displayUpdate()
    }
    func transition_instructionsSequence_to_paymentSwipe() {
        hideScreen_instructionsSequence()
        showScreen_paymentSwipe()
    }
    func transition_phonePinPad_to_unlocked () {
        hideScreen_phonePinPad()
        arduinoFunctions.arduinoLock_unlock()
    }
    

    //     : Processing :
    func hideScreen_paymentProcessing () {
        processingPayment_circle.isHidden = true
        processingPayment_processingIcon.isHidden = true
        processingPayment_label.isHidden = true
    }
    func showScreen_paymentProcessing () {
        processingPayment_circle.isHidden = false
        processingPayment_processingIcon.isHidden = false
        processingPayment_label.isHidden = false
    }
    
    // Instructions Graphic - Image Update
    func instructionsImage_displayUpdate () {
        instructionsImage_sequence_timer = nil
        instructionsImage_sequence_timer?.invalidate()
        
        let imageName = "appChecklist_steps_" + String(instructionsImage_sequence_number)
        instructionsImage_view.image = UIImage(named: imageName)
        
        // Follow Instructions Label - Update
        if (instructionsImage_sequence_number == 0) {
            instructionsLabel.text = "Freezer Unlocked"
            instructionsImage_sequence_timeInterval = 3.0
        }
        else if (instructionsImage_sequence_number == instructionsImage_sequence_maxCount) {
            instructionsLabel.text = "Follow Instructions"
            instructionsImage_sequence_timeInterval = 3.0
        }
        else {
            instructionsLabel.text = "Follow Instructions"
            instructionsImage_sequence_timeInterval = 1.5
        }
        
        // Follow Instructions Graphic - Update
        if (instructionsImage_sequence_number < instructionsImage_sequence_maxCount) {
            instructionsImage_sequence_number += 1
            instructionsImage_sequence_timer = Timer.scheduledTimer(timeInterval: instructionsImage_sequence_timeInterval,
                                                                    target: self,
                                                                    selector: #selector(instructionsImage_displayUpdate),
                                                                    userInfo: nil, repeats: false)
        }
        else if (instructionsImage_sequence_number == instructionsImage_sequence_maxCount) {
            instructionsImage_sequence_number += 1
            instructionsImage_sequence_timer = Timer.scheduledTimer(timeInterval: instructionsImage_sequence_timeInterval_final,
                                                                    target: self,
                                                                    selector: #selector(instructionsImage_displayUpdate),
                                                                    userInfo: nil, repeats: false)
        }
        else {
            instructionsImage_sequence_number = 0
            transition_instructionsSequence_to_paymentSwipe()
        }
    }


    // Hide/Show Pin Pad
    func phoneNumpad_visible() {
        enterYourPhoneNumber.isHidden = false
        for button in [button1,button2,button3,button4,button5,button6,button7,button8,button9,button0,pinpad_lowerLeft,pinpad_lowerRight] {
            button.isHidden = false
        }
    }

    func phoneNumpad_hidden() {
        enterYourPhoneNumber.isHidden = true
        for button in [button1,button2,button3,button4,button5,button6,button7,button8,button9,button0,pinpad_lowerLeft,pinpad_lowerRight] {
            button.isHidden = true
        }
    }

    func phonePeriphery_visible() {
        phoneNumberDisplay.isHidden = false
        abovePhoneLayer.isHidden = false
        belowPhoneLayer.isHidden = false
        clearPhoneButton.isHidden = false
        showAndEnable_pinpad_lowerPeriphery()
    }

    func phonePeriphery_hidden() {
        phoneNumberDisplay.isHidden = true
        abovePhoneLayer.isHidden = true
        belowPhoneLayer.isHidden = true
        clearPhoneButton.isHidden = true
        hideAndDisable_pinpad_lowerPeriphery()
    }

    func showAndEnable_pinpad_lowerPeriphery () {
        showAndEnable_pinpad_lowerLeft()
        showAndEnable_pinpad_lowerRight()
    }

    func showAndEnable_pinpad_lowerLeft () {
        pinpad_lowerLeft.setImage(#imageLiteral(resourceName: "delButton_image"), for: .normal)
        pinpad_lowerLeft.isEnabled = true
    }

    func showAndEnable_pinpad_lowerRight () {
        pinpad_lowerRight.setTitleColor(.white, for: .normal)
        pinpad_lowerRight.backgroundColor = UIColor(red: 29.0/255.0, green: 177.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        pinpad_lowerRight.isEnabled = true
    }

    func hideAndDisable_pinpad_lowerPeriphery () {
        hideAndDisable_pinpad_lowerLeft()
        hideAndDisable_pinpad_lowerRight()
    }

    func hideAndDisable_pinpad_lowerLeft () {
        pinpad_lowerLeft.setImage(nil, for: .normal)
        pinpad_lowerLeft.isEnabled = false
    }

    func hideAndDisable_pinpad_lowerRight () {
        pinpad_lowerRight.setTitleColor(.clear, for: .normal)
        pinpad_lowerRight.backgroundColor = UIColor.clear
        pinpad_lowerRight.isEnabled = false
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

    func setLockImage_unlocked () {
        lockUnlockImage_view.image = UIImage(named: "unlockLockImage_unlocked")
    }

    func setLockImage_locked () {
        lockUnlockImage_view.image = nil
        // lockUnlockImage_view.image = UIImage(named: "unlockLockImage_locked")
    }

    func processingPayment_displayUpdate () {
        if (processingIcon_count < processingIcon_maxCount) {
            processingIcon_count += 1
        }
        else {
            processingIcon_count = 0
        }
        processingPayment_processingIcon.text = String(repeating: "\u{2022}", count: processingIcon_count)
        var range = NSRange(location: 0, length: processingIcon_count)
        processingPayment_processingIcon_string.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: range)
        range = NSRange(location: processingIcon_count, length: processingIcon_maxCount - processingIcon_count)
        processingPayment_processingIcon_string.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: range)
        processingPayment_processingIcon.attributedText = processingPayment_processingIcon_string
    }

    func processingPayment_displayUpdate_kill () {
        processingPayment_timer?.invalidate()
        processingPayment_timer = nil
    }
}
