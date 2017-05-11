//
//  BluetoothTest.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 4/15/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothTest: UIViewController, BluetoothSerialDelegate {
    
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var selectedPeripheral: CBPeripheral?
    var connectTimer: Timer?
    var scanTimeoutTimer: Timer?
    var sendUnlockTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // init serial
        print("init")
        serial = BluetoothSerial(delegate: self)
        
        print("scan")
//        while (peripherals.count < 1) {
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
        }
        connectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(BluetoothTest.scanForPeriph), userInfo: nil, repeats: true)
//        }
//        serial.connectToPeripheral(selectedPeripheral!)
        
//        if serial.isReady {
//            print("Connected\n");
////            navItem.title = serial.connectedPeripheral!.name
////            barButton.title = "Disconnect"
////            barButton.tintColor = UIColor.red
////            barButton.isEnabled = true
//        } else if serial.centralManager.state == .poweredOn {
//            print("Powered\n");
////            navItem.title = "Bluetooth Serial"
////            barButton.title = "Connect"
////            barButton.tintColor = view.tintColor
////            barButton.isEnabled = true
//        } else {
//            print("Disconnected\n");
////            navItem.title = "Bluetooth Serial"
////            barButton.title = "Connect"
////            barButton.tintColor = view.tintColor
////            barButton.isEnabled = false
//        }
    }

    func scanForPeriph() {
        serial.startScan()
        scanTimeoutTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothTest.scanTimeOut), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scanTimeOut() {
        serial.stopScan()
        print("timedOut")
    }
    
    func connectToDefaultPeripheral() {
        let mainPeripheral = peripherals[0].peripheral
        serial.connectToPeripheral(mainPeripheral)
        print("-----")
        print(mainPeripheral.name!)
        print(mainPeripheral.name!.characters.last!)
        print("-----")
        connectTimer?.invalidate()
        connectTimer = nil
        scanTimeoutTimer?.invalidate()
        scanTimeoutTimer = nil
        print("abc")
        
        sendUnlockTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(BluetoothTest.sendUnlockMessage), userInfo: nil, repeats: true)
    }
    
    func sendUnlockMessage() {
        serial.sendMessageToDevice("TOP\n")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: BluetoothSerialDelegate
    
    func serialDidReceiveString(_ message: String) {
        print(message)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
//        reloadView()
//        dismissKeyboard()
//        let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        hud?.mode = MBProgressHUDMode.text
//        hud?.labelText = "Disconnected"
//        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append(peripheral: peripheral, RSSI: theRSSI)
        peripherals.sort { $0.RSSI < $1.RSSI }
        print(peripherals)
        connectToDefaultPeripheral()
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
//        if let hud = progressHUD {
//            hud.hide(false)
//        }
//        
//        tryAgainButton.isEnabled = true
//        
//        let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        hud?.mode = MBProgressHUDMode.text
//        hud?.labelText = "Failed to connect"
//        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialIsReady(_ peripheral: CBPeripheral) {
//        if let hud = progressHUD {
//            hud.hide(false)
//        }
//        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
//        dismiss(animated: true, completion: nil)
    }
    
    func serialDidChangeState() {
//        if let hud = progressHUD {
//            hud.hide(false)
//        }
//        
//        if serial.centralManager.state != .poweredOn {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
//            dismiss(animated: true, completion: nil)
//        }
    }

}
