//
//  paymentViewController.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 3/1/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit
import CoreBluetooth


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

let baudRate: Int32 = 9600      // baud rate
var siteSpecificUnlockTimes = [[Int]]()

class paymentViewController: UIViewController, RscMgrDelegate {
    
    // Unit Testing
    var unitTesting = false
    
    // PIN was not set
    var pin_wasNotSet = false
    
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
    
    
    // Payment or Master Unlock
    var paymentOr_masterUnlock = false
    
    // siteSpecificUnlockTimes
    let unlock_TimeSpecific_interval: Double = 30
    let timeSpecificUnlockStatus_interval: Double = 5*60
    let timer_setOrientation_interval: Double = 60
    var timeSpecificUnlocked = false
    
    // RscMgr
    var rscMgr:  RscMgr!     // RscMgr handles the serial communication
    
    let defaults = UserDefaults.standard
    
    // Bluetooth Functionality
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var selectedPeripheral: CBPeripheral?
    var connectTimer: Timer?
    var scanTimeoutTimer: Timer?
    var sendUnlockTimer: Timer?
    let timeToRelock = 20.0
    var bluetoothStatus: String?
    
    // Regular Functionality
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var arduinoRx_message = String()
    
    let successTransition = 5.0
    let registrationTransition = 8.0
    
    // Keypad
    var keypadVersion = "phoneNumber";
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
    
    // Display Elements
    var logoImage_view = UIImageView()
    var swipeImage_view = UIImageView()
    var pinPadImage_view = UIImageView()
    let keurigLabel = UILabel()
    
    
    let payButton = UIButton()
    let subscribeButton = UIButton()
    let priceLabel = UILabel()
    let subscribeLabel = UILabel()
    let subscribeDetails = UILabel()
    
    let phoneNumberDisplay = UILabel()
    var phoneNumString: [Character] = ["(", " ", " ", " ", ")", " ", " ", " ", " ", "-", " ", " ", " ", " "]
    var phoneNumString_exact: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    var phoneNumStringCount = 0
    
    // Master Unlock
    let masterUnlockString = "CC062616"
    var input_last8 = [" ", " ", " ", " ", " ", " ", " ", " "]
    var printString = "      "
    
    // PIN Code Entry
    let pinLength = 4;
    var pinNumStringCount = 0
    let pinMaxTry = 3
    var pinTryCount = 0
    var pinRegistration = false;
    var pinString_display: [Character] = ["-", "-", "-", "-"]
    var pinString: [Character] = ["-", "-", "-", "-"]
    var pinString_validate: [Character] = ["-", "-", "-", "-"]
    var pinString_str = ""
    
    // Subscription Info
    var subscription = 0
    
    // Epona
    // Credit Card Swipe Info
    let version_url = "&version=3.0.0"
    var cardToken = ""
    var firstName = ""
    var lastName = ""
    var fName_url = ""
    var lName_url = ""
    var waitingForCC = false;
    var methodToExecute = "";
    var ccInfo_chargeUser = 0;
    
    // iPad registration
    var localRegistration = false;
    var swipeImage = UIImage()
    var pinPadImage = UIImage()
    
    let shapeLayer = CAShapeLayer()
    let checkMark = UILabel()
    let paymentSuccessfulLabel = UILabel()
    
    let disabledColor = UIColor(
        red: 240/255.0,
        green: 240/255.0,
        blue: 240/255.0,
        alpha: 1.0)
    let enabledColor = UIColor.black
    
    func resetPhoneNumber() {
    }
    
    func successfulPayment () {
    }
    
    func unsuccessfulPayment () {
    }
    
    func processingPaymentRequest () {
    }
    
    func undo_processingPaymentRequest() {
    }
    
    func hide_greenCircle_andCheck () {
    }
    
    func numpadPressed(sender: UIButton) {
    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    var initialLoad = false
    
    var lockState = true
    var timer_hourSpecific: Timer?
    var timer_acquireUnlockTimes: Timer?
    var timer_setOrientation_landscapeLeft: Timer?
    
    func unlock_timeSpecific() {
    }
    
    func hidePinPad_true() {
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
        button6.isHidden = true
        button7.isHidden = true
        button8.isHidden = true
        button9.isHidden = true
        button0.isHidden = true
        pinpad_lowerLeft.isHidden = true
        pinpad_lowerRight.isHidden = true
    }
    
    func hidePinPad_false() {
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
        button6.isHidden = false
        button7.isHidden = false
        button8.isHidden = false
        button9.isHidden = false
        button0.isHidden = false
        pinpad_lowerLeft.isHidden = false
        pinpad_lowerRight.isHidden = false
    }

    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
        
        // rscMgr
        rscMgr = RscMgr()
        rscMgr.setDelegate(self)
        rscMgr.enableExternalLogging(true)
        
        // Software revision
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        print(nsObject as! String)
        
        defaults.set("3.0.0", forKey: "version")
        
        // Company name is device name <- Ease of setup of multiple devices
        defaults.set(UIDevice.current.name, forKey: "location")
        
        // Buttons
        let num_w = self.screenSize.width/8
        let num_h = self.screenSize.height/8
        
        // c#x
        let c1x = self.screenSize.width*(1/2 + 1/16)
        let c2x = self.screenSize.width*(1/2 + 1/16 + 1/8)
        let c3x = self.screenSize.width*(1/2 + 1/16 + 2/8)
        
        // r#y
        let r1y = self.screenSize.height*(1/4 + 1/8)
        let r2y = self.screenSize.height*(1/4 + 2/8)
        let r3y = self.screenSize.height*(1/4 + 3/8)
        let r4y = self.screenSize.height*(1/4 + 4/8)
        
        let imageName = "OriginLogo.png"
        let logoImage = UIImage(named: imageName)!
        logoImage_view = UIImageView(image: logoImage)
        logoImage_view.frame = CGRect(x: self.screenSize.width / 16, y: self.screenSize.height*(1/8),
                                      width: self.screenSize.width * 3 / 8,
                                      height: self.screenSize.height*(1/6))
        logoImage_view.contentMode = .scaleAspectFit
        view.addSubview(logoImage_view)
        
        // Swipe and PIN Pad icons
        swipeImage = UIImage(named: "creditCardSwipe.png")!
        swipeImage_view.image = swipeImage
        swipeImage_view.frame = CGRect(x: self.screenSize.width * (1/3 - 1/32),
                                       y: (r2y + r3y) / 2,
                                       width: self.screenSize.width / 16,
                                       height: self.screenSize.width / 16)
        swipeImage_view.contentMode = .scaleAspectFit
        swipeImage_view.isHidden = false;
        view.addSubview(swipeImage_view)
        
        pinPadImage = UIImage(named: "pinPadEntry.png")!
        pinPadImage_view.image = pinPadImage
        pinPadImage_view.frame = CGRect(x: self.screenSize.width * (1/6 - 1/32),
                                        y: (r2y + r3y) / 2,
                                        width: self.screenSize.width / 16,
                                        height: self.screenSize.width / 16)
        pinPadImage_view.contentMode = .scaleAspectFit
        pinPadImage_view.isHidden = false
        view.addSubview(pinPadImage_view)
        
        // Keurig for Health Smoothies - Label
        keurigLabel.frame = CGRect(x: self.screenSize.width / 24,
                                   y: r4y,
                                   width: self.screenSize.width * 5 / 12,
                                   height: self.screenSize.height / 6)
        keurigLabel.textAlignment = NSTextAlignment.center
        keurigLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        keurigLabel.font = UIFont(name: "Arial", size: self.screenSize.height*(7/170))
        keurigLabel.numberOfLines = 0
        keurigLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let formattedString = NSMutableAttributedString()
        formattedString.append(NSAttributedString(string: "Enter "))
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(7/170))!]
        var text = "Phone Number "
        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
        formattedString.append(NSAttributedString(string: "\nor \n"))
        text = "Swipe Credit Card" // "Swipe Credit Card "
        formattedString.append(NSMutableAttributedString(string:"\(text)", attributes:attrs))
        keurigLabel.attributedText = formattedString
        
        view.addSubview(keurigLabel)
        
        
//        priceLabel.frame = CGRect(x: self.screenSize.width / 8,
//                                 y: r3y - self.screenSize.height / 16,
//                                 width: self.screenSize.width / 4,
//                                 height: self.screenSize.height / 8)
        // Subscription setup
        priceLabel.frame = CGRect(x: self.screenSize.width / 16,
                                  y: r1y - self.screenSize.height / 10.8,//(imageView.frame.maxY + (r2y + r3y) / 2) / 2 - self.screenSize.height / 5,
            width: self.screenSize.width * 3 / 8,
            height: self.screenSize.height / 5)
        
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 4)
        priceLabel.textAlignment = .center
        priceLabel.numberOfLines = 0
        view.addSubview(self.priceLabel)
        
        subscribeLabel.frame = CGRect(x: self.screenSize.width / 8,
                                      y: r3y - self.screenSize.height / 16,
                                      width: self.screenSize.width / 4,
                                      height: self.screenSize.height / 5)
        subscribeLabel.text = "$2.99"
        subscribeLabel.font = UIFont.boldSystemFont(ofSize: priceLabel.frame.height / 2)
        subscribeLabel.textAlignment = .center
        subscribeLabel.textColor = .black
        subscribeLabel.isHidden = true
        view.addSubview(self.subscribeLabel)
        
        set_priceLabels()
        view.setNeedsDisplay()
        
        subscribeDetails.frame = CGRect(x: self.screenSize.width / 24,
                                        y: r4y,
                                        width: self.screenSize.width * 5 / 12,
                                        height: self.screenSize.height / 6)
        subscribeDetails.textAlignment = NSTextAlignment.center
        subscribeDetails.baselineAdjustment = UIBaselineAdjustment.alignCenters
        subscribeDetails.font = UIFont(name: "Arial", size: self.screenSize.height*(7/170))
        subscribeDetails.numberOfLines = 0
        subscribeDetails.lineBreakMode = NSLineBreakMode.byWordWrapping
        subscribeDetails.text = "3 Smoothies / Week"
        subscribeDetails.isHidden = true
        view.addSubview(subscribeDetails)
        
        
        payButton.frame = CGRect(x: self.screenSize.width / 8,
                                 y: r2y - self.screenSize.height / 32,// r3y - self.screenSize.height / 16,
            width: self.screenSize.width / 4,
            height: self.screenSize.height / 16)
        payButton.setTitle("Pay Now", for: .normal)
        payButton.setTitleColor(.black, for: .normal)
        payButton.setTitleColor(UIColor(red: 75/255.0,
                                        green: 181/255.0,
                                        blue: 67/255.0,
                                        alpha: 1.0),
                                for: .highlighted)
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: payButton.frame.height / 2)
        payButton.backgroundColor = UIColor.white
        payButton.layer.borderColor = UIColor.black.cgColor
        payButton.layer.borderWidth = 6
        payButton.layer.cornerRadius = payButton.frame.height / 4//0.5 * button1.bounds.size.width
        payButton.clipsToBounds = true
        payButton.isHidden = true //Epona889
//        view.addSubview(self.payButton)
        
        subscribeButton.frame = CGRect(x: self.screenSize.width / 12 * 3.5,
                                       y: r2y - self.screenSize.height / 32,
                                       width: self.screenSize.width / 3 / 3,
                                       height: payButton.frame.height)
        subscribeButton.tag = 10
        subscribeButton.setTitle("Join and get it for: $3.99", for: .normal)
        
        // NOW
        let subscribeString = "Join"
        let title = NSMutableAttributedString(string: subscribeString as String)
        
        let sub_zeroAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: self.screenSize.height*(9/170))!] as [String : Any]
        let sub_oneAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(8/170))!] as [String : Any]
        title.addAttributes(sub_oneAttributes, range: NSMakeRange(0,title.length))
        subscribeButton.setAttributedTitle(title, for: .normal)
        // NOW
        
        subscribeButton.setTitleColor(.black, for: .normal)
        subscribeButton.setTitleColor(UIColor(red: 75/255.0,
                                              green: 181/255.0,
                                              blue: 67/255.0,
                                              alpha: 1.0),
                                      for: .highlighted)
        subscribeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: payButton.frame.height / 2)
        subscribeButton.backgroundColor = UIColor.white
        subscribeButton.layer.borderColor = UIColor.black.cgColor
        subscribeButton.layer.borderWidth = 3
        subscribeButton.layer.cornerRadius = payButton.frame.height / 4//0.5 * button1.bounds.size.width
        subscribeButton.clipsToBounds = true
        subscribeButton.isHidden = false
        subscribeButton.addTarget(self, action: #selector(processSubscription), for: .touchUpInside)
        
        // Payment Successful - Label
        let circle_x = self.screenSize.width / 4
        let circle_r = self.screenSize.height / 16
        let circle_y = self.screenSize.height * 2 / 3 - circle_r
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: circle_x,
                               y: circle_y),
            radius: circle_r,
            startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        self.shapeLayer.path = circlePath.cgPath
        
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.strokeColor = self.shapeLayer.fillColor
        self.shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(self.shapeLayer)
        
        // Check Mark icon
        self.checkMark.frame = CGRect(x: circle_x - circle_r,
                                      y: circle_y - circle_r,
                                      width: circle_r * 2,
                                      height: circle_r * 2)
        self.checkMark.textAlignment = NSTextAlignment.center
        self.checkMark.baselineAdjustment = UIBaselineAdjustment.alignCenters
        self.checkMark.font = UIFont(name: "Arial", size: self.screenSize.height*(1/12))
        self.checkMark.textColor = UIColor.white
        self.checkMark.numberOfLines = 0
        self.checkMark.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.checkMark.text = "✓"
        view.addSubview(self.checkMark)
        
        // Payment Successful - Label
        self.paymentSuccessfulLabel.frame = CGRect(x: self.screenSize.width / 16,
                                                   y: self.screenSize.height*(3/4 - 1/12),
                                                   width: self.screenSize.width * 3 / 8,
                                                   height: self.screenSize.height*(1/6))
        self.paymentSuccessfulLabel.textAlignment = NSTextAlignment.center
        self.paymentSuccessfulLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        self.paymentSuccessfulLabel.font = UIFont(name: "Arial", size: self.screenSize.height*(7/160))
        self.paymentSuccessfulLabel.numberOfLines = 0
        self.paymentSuccessfulLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.paymentSuccessfulLabel.text = "Payment Successful"
        view.addSubview(self.paymentSuccessfulLabel)
        
        // Hide until successful payment
        if (!initialLoad) {
            self.shapeLayer.isHidden = true
            self.checkMark.isHidden = true
            self.paymentSuccessfulLabel.isHidden = true
        }
        
        
        // Phone Number Display
        phoneNumberDisplay.frame = CGRect(x: self.screenSize.width*(1/2 + 1/16),
                                          y: logoImage_view.frame.minY,
                                          width: self.screenSize.width*(3 / 8),
                                          height: self.screenSize.height*(1/4))
        phoneNumberDisplay.textAlignment = NSTextAlignment.center
        phoneNumberDisplay.baselineAdjustment = UIBaselineAdjustment.alignCenters
        phoneNumberDisplay.font = UIFont(name: "Arial", size: self.screenSize.height*(7/160))
        phoneNumberDisplay.numberOfLines = 0
        phoneNumberDisplay.frame.size.width = self.screenSize.width*(3 / 8)
        phoneNumberDisplay.lineBreakMode = NSLineBreakMode.byWordWrapping
        //        phoneNumberDisplay.text = "Enter your phone number to pay"
        phoneNumberDisplay.text = " "
        view.addSubview(phoneNumberDisplay)
        
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
        button1.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button1)
        addRightBorder(button: button1)
        view.addSubview(button1)
        
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
        button2.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button2)
        addRightBorder(button: button2)
        addLeftBorder(button: button2)
        view.addSubview(button2)
        
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
        button3.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button3)
        addLeftBorder(button: button3)
        view.addSubview(button3)
        
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
        button4.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button4)
        addRightBorder(button: button4)
        addTopBorder(button: button4)
        view.addSubview(button4)
        
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
        button5.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button5)
        addRightBorder(button: button5)
        addLeftBorder(button: button5)
        addTopBorder(button: button5)
        view.addSubview(button5)
        
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
        button6.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button6)
        addLeftBorder(button: button6)
        addTopBorder(button: button6)
        view.addSubview(button6)
        
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
        button7.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button7)
        addRightBorder(button: button7)
        addTopBorder(button: button7)
        view.addSubview(button7)
        
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
        button8.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button8)
        addRightBorder(button: button8)
        addLeftBorder(button: button8)
        addTopBorder(button: button8)
        view.addSubview(button8)
        
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
        button9.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addBottomBorder(button: button9)
        addLeftBorder(button: button9)
        addTopBorder(button: button9)
        view.addSubview(button9)
        
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
        pinpad_lowerRight.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addRightBorder(button: pinpad_lowerRight)
        addTopBorder(button: pinpad_lowerRight)
        view.addSubview(pinpad_lowerRight)
        
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
        button0.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addRightBorder(button: button0)
        addLeftBorder(button: button0)
        addTopBorder(button: button0)
        view.addSubview(button0)
        
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
        pinpad_lowerLeft.addTarget(self, action: #selector(numpadPressed), for: .touchUpInside)
        addLeftBorder(button: pinpad_lowerLeft)
        addTopBorder(button: pinpad_lowerLeft)
        view.addSubview(pinpad_lowerLeft)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initialLoad = true
        
        
        // Arduino
        connectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.scanForPeriph), userInfo: nil, repeats: true)
        
        serverComms_priceSettings()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            // Landscape Orientation - Required
            setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
            self.timer_setOrientation_landscapeLeft = Timer.scheduledTimer(timeInterval: self.timer_setOrientation_interval, target: self, selector: #selector(self.setOrientation_landscapeLeft_andBrightnessFull_andNoLock_local), userInfo: nil, repeats: true)
            
            //timer_acquireUnlockTimes
            self.serverComms_siteSpecificUnlockTimes()
            self.timer_acquireUnlockTimes = Timer.scheduledTimer(timeInterval: self.timeSpecificUnlockStatus_interval, target: self, selector: #selector(ViewController.serverComms_siteSpecificUnlockTimes), userInfo: nil, repeats: true)
            
            // Time-specific Locking
            self.unlock_timeSpecific()
            self.timer_hourSpecific = Timer.scheduledTimer(timeInterval: self.unlock_TimeSpecific_interval, target: self, selector: #selector(ViewController.unlock_timeSpecific), userInfo: nil, repeats: true)
            
            // Freezer Settings
            self.serverComms_freezerSettings()
            self.acquireFreezerSettings_timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.acquireFreezerSettings_timeInterval), target: self, selector: #selector(ViewController.serverComms_freezerSettings), userInfo: nil, repeats: true)
            
            // Price Settings
            self.serverComms_priceSettings()
            self.acquirePriceSettings_timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.acquirePriceSettings_timeInterval), target: self, selector: #selector(ViewController.serverComms_priceSettings), userInfo: nil, repeats: true)
        })
        
    }
    
    func setOrientation_landscapeLeft_andBrightnessFull_andNoLock_local () {
        setOrientation_landscapeLeft_andBrightnessFull_andNoLock()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func extractAfterStart ( arduinoRx_message: String, startString: String ) -> String {
        var arduinoRx_message = arduinoRx_message
        if (arduinoRx_message.range(of:startString) == nil) {
            return "error"
        }
        
        if ((arduinoRx_message.components(separatedBy: startString).count) == 1) {
            arduinoRx_message = ""
        }
        else {
            arduinoRx_message = arduinoRx_message.components(separatedBy: startString)[1]
        }
        return arduinoRx_message
    }
    
    // data is ready to read
    func readBytesAvailable(_ length: UInt32) {
        
        let data: Data = rscMgr.getDataFromBytesAvailable()   // note: may also process text using rscMgr.getStringFromBytesAvailable()
        let message = String(data: data, encoding: String.Encoding.utf8)!
        
        print(message)
        bluetoothStatus = message
        
        arduinoRx_message += message
        arduinoRx_message = (arduinoRx_message as NSString).replacingOccurrences(of: "?", with: "")
        NSLog(arduinoRx_message)
        
        let _ = processIncomingMessage()
        
    }
    
    // MARK: End of RscMgr functions
    
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
                    processPayment(method: methodToExecute)
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
                
                tempString = arduinoRx_message
                if (!unitTesting) {
                    serverComms_lockCommunication(lockString: arduinoRx_message)
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
                    serverComms_freezerCommunication(freezerString: arduinoRx_message)
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
                    serverComms_keepAliveCommunication()
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
    
    func paymentReset () {
    }
    
    func subscription_priceLabel() {
    }
    
    func noSubscription_priceLabel() {
        let string = "$" + String(format: "%.2f", payment_price1)
        let attributedString = NSMutableAttributedString(string: string as String)
        let secondAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: self.screenSize.height*(12/170))!] as [String : Any]
        attributedString.addAttributes(secondAttributes, range: NSMakeRange(0, string.characters.count))
        priceLabel.attributedText = attributedString
        self.view.setNeedsDisplay()
    }
    
    func unlocked_priceLabel() {
    }
    
    func subscriptionPriceLabel() {
    }
    
    func processSubscription() {
    }
    
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
                        self.siteSpecificUnlockTimes.append([startTime!, endTime!])
                    }
                }
                self.unlock_timeSpecific()
            }
        }
        
        task.resume()
    }
    
    // Freezer Settings - Server Communications
    var acquireFreezerSettings_timer: Timer?
    let acquireFreezerSettings_timeInterval = 15*60
    func serverComms_freezerSettings ( ) {
        
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
                        self.rscMgr.write(commString)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // Price Settings - Server Communications
    var acquirePriceSettings_timer: Timer?
    let acquirePriceSettings_timeInterval = 15*60
    func serverComms_priceSettings ( ) {
        
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
                    self.payment_priceSet = true
                    self.payment_employeeThreshold = Int(priceArray[0])!
                    self.payment_thresholdConfig = Int(priceArray[1])!
                    self.payment_threshold1 = Int(priceArray[2])!
                    self.payment_threshold2 = Int(priceArray[4])!
                    self.payment_price1 = Float(priceArray[3])!
                    self.payment_price2 = Float(priceArray[5])!
                }
                
                // Subscription information
                let subscriptionString = ((responseString.components(separatedBy: "</SUBSCRIPTION>")[0]).components(separatedBy: "<SUBSCRIPTION>")[1])
                if subscriptionString.range(of:",") != nil{
                    let subscriptionArray = subscriptionString.components(separatedBy: ",")
                    self.subscription_priceSet = true
                    self.subscription_smoothieCount1 = Int(subscriptionArray[0])!
                    self.subscription_smoothieCount2 = Int(subscriptionArray[2])!
                    self.subscription_smoothieCount3 = Int(subscriptionArray[4])!
                    self.subscription_smoothiePrice1 = Float(subscriptionArray[1])!
                    self.subscription_smoothiePrice2 = Float(subscriptionArray[3])!
                    self.subscription_smoothiePrice3 = Float(subscriptionArray[5])!
                    self.view.addSubview(self.subscribeButton)
                }
                
                self.set_priceLabels()
            }
        }
        task.resume()
    }
    
    func set_priceLabels() {
        if (self.timeSpecificUnlocked == true) {
            self.unlocked_priceLabel()
        }
        else if (self.subscription_priceSet) {
            self.subscription_priceLabel()
            self.view.addSubview(self.subscribeButton)
        }
        else {
            self.noSubscription_priceLabel()
            self.removeSubview(tag: self.subscribeButton.tag)
        }
    }
    
    func removeSubview(tag: Int){
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    func processPayment(method: String) {
        NSLog("Payment method - " + method)
        var urlWithParams = ""
        let versionString = "&version=" + defaults.string(forKey: "version")!
        
        // V3 Payment Communications Structure
        if (method == "ccInfo") {
            let ccInfoString = "?ccInfo=" + arduinoRx_message
            let chargeUser_now = "&chargeNow=" + String(ccInfo_chargeUser)
            let companyString = "&locationName=" + defaults.string(forKey: "location")!
            urlWithParams = paymentAddress + ccInfoString + companyString + versionString + chargeUser_now + subscribeString
            processingPaymentRequest()
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
                    self.paymentOr_masterUnlock = true
                    self.successfulPayment()
                }
                else if (chargeResponse[0] == "Swipe Again") {
                    
                }
                else if (chargeResponse[0] == "Failed") {
                    self.paymentOr_masterUnlock = false
                    self.unsuccessfulPayment()
                }
            }
        }
        
        task.resume()
    }
    
    func phoneExists() {
    }
    
    func phoneExists_return(responseString: String) {
    }
    
    func resetKeurigLabel() {
    }
    
    func registerUser() -> String {
    }
}

extension String {
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return self[startIndex...endIndex]
        }
    }
}

extension UILabel {
    /**
     Set Text With animation
     
     - parameter text:     String?
     - parameter duration: NSTimeInterval?
     */
    public func setTextAnimation(text: String? = nil, color: UIColor? = nil, duration: TimeInterval?, completion:(()->())? = nil) {
        UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = text ?? self.text
            self.textColor = color ?? self.textColor
        }) { (finish) in
            if finish { completion?() }
        }
    }
}

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension String {
    func substring(from: Int) -> String? {
        guard from < self.characters.count else { return nil }
        let fromIndex = index(self.startIndex, offsetBy: from)
        return substring(from: fromIndex)
    }
}

extension Array {
    
    func shiftRight( amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount: amount)
    }
}
