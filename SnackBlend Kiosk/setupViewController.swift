//
//  setupViewController.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 4/4/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit

class setupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let getCompanies_webAddress = "https://io.calmlee.com/companyFetch.php"
    let getPaymentConfig_webAddress = "https://io.calmlee.com/paymentConfig.php"
    
    var companyPicker = UIPickerView()
    var myLabel: UILabel!
    
    let backButton = UIButton()
    let deployButton = UIButton()
    
    var companyList: [String]!
    var currentCompany = String()
    
    let screenSize: CGRect = UIScreen.main.bounds
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = getCompanyList()
        
        companyPicker.dataSource = self;
        companyPicker.delegate = self;
        companyPicker.frame = CGRect(x: 0, y: self.screenSize.height / 4,
                                     width: self.screenSize.width, height: self.screenSize.height / 2)
        companyPicker.layer.borderColor = UIColor.black.cgColor
        companyPicker.layer.borderWidth = 5
        view.addSubview(companyPicker)
        
        let deployHeight = self.screenSize.height / 8
        let deployWidth = self.screenSize.width / 2
        deployButton.frame = CGRect(x: self.screenSize.width * 5 / 8 - deployWidth / 2,
                                    y: self.screenSize.height * 7 / 8 - deployHeight / 2,
                                    width: deployWidth,
                                    height: deployHeight)
        deployButton.setTitle("Deploy", for: .normal)
        deployButton.titleLabel!.font = UIFont(name: "Arial", size: deployButton.frame.height / 2)
        deployButton.setTitleColor(UIColor(
                                    red: 75/255.0,
                                    green: 181/255.0,
                                    blue: 67/255.0,
                                    alpha: 1.0), for: .normal)
        deployButton.setTitleColor(UIColor(
                                    red: 255/255.0,
                                    green: 255/255.0,
                                    blue: 255/255.0,
                                    alpha: 1.0), for: .highlighted)
        deployButton.setBackgroundColor(color: UIColor(
                                    red: 75/255.0,
                                    green: 181/255.0,
                                    blue: 67/255.0,
                                    alpha: 1.0), forState: .highlighted)
        deployButton.layer.borderWidth = 2
        deployButton.layer.borderColor = deployButton.currentTitleColor.cgColor
        deployButton.addTarget(self, action: #selector(setupPayment), for: .touchUpInside)
        view.addSubview(deployButton)
        
        let backHeight = self.screenSize.height / 8
        let backWidth = self.screenSize.width / 6
        backButton.frame = CGRect(x: deployButton.frame.minX / 2 - backWidth / 2,
                                  y: self.screenSize.height * 7 / 8 - backHeight / 2,
                                  width: backWidth,
                                  height: backHeight)
        backButton.setTitle("Cancel", for: .normal)
        backButton.titleLabel!.font = UIFont(name: "Arial", size: backButton.frame.height / 2)
        backButton.setTitleColor(UIColor(
                                    red: 255/255.0,
                                    green: 0/255.0,
                                    blue: 0/255.0,
                                    alpha: 1.0), for: .normal)
        backButton.setTitleColor(UIColor(
                                    red: 255/255.0,
                                    green: 255/255.0,
                                    blue: 255/255.0,
                                    alpha: 1.0), for: .highlighted)
        backButton.setBackgroundColor(color: UIColor(
                                    red: 255/255.0,
                                    green: 0/255.0,
                                    blue: 0/255.0,
                                    alpha: 1.0), forState: .highlighted)
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = backButton.currentTitleColor.cgColor
        backButton.addTarget(self, action: #selector(gotoMain), for: .touchUpInside)
        view.addSubview(backButton)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoMain(sender: UIButton) {
        self.performSegue(withIdentifier: "gotoMain", sender: Any?.self)
    }
    
    func setupPayment (sender: UIButton) {
        
        deployButton.setTitleColor(UIColor(
            red: 255/255.0,
            green: 255/255.0,
            blue: 255/255.0,
            alpha: 1.0), for: .normal)
        deployButton.setBackgroundColor(color: UIColor(
            red: 75/255.0,
            green: 181/255.0,
            blue: 67/255.0,
            alpha: 1.0), forState: .normal)
        
        getPaymentStructure()
        
        deployButton.setTitleColor(UIColor(
            red: 75/255.0,
            green: 181/255.0,
            blue: 67/255.0,
            alpha: 1.0), for: .normal)
        deployButton.setBackgroundColor(color: UIColor(
            red: 255/255.0,
            green: 255/255.0,
            blue: 255/255.0,
            alpha: 1.0), forState: .normal)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return companyList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        currentCompany = companyList[row]
        return companyList[row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let attributedString = NSMutableAttributedString(string: companyList[row], attributes: [NSForegroundColorAttributeName : UIColor.black])
//        print(companyList[row])
//        return attributedString
//    }
    
//    func pickerView(_: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 36.0
//    }

    
    func getCompanyList () -> [String] {
        
        // Create NSURL Object
        let myUrl = NSURL(string: getCompanies_webAddress);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // String Array output
        var returnStringArray: [String] = []
        let sem = DispatchSemaphore(value: 0)
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let chargeResponse = String(describing: responseString!).components(separatedBy: "\"")
            for item in chargeResponse {
                if (item.characters.count > 1) {
                    returnStringArray += [item]
                }
            }
            sem.signal()
        }
        
        task.resume()
//        sem.wait(timeout: .distantFuture)
        return(returnStringArray)
    }
    
    func getPaymentStructure () {
        
        // Process Payment - PPMT
        // Add one parameter
        let urlWithParams = getPaymentConfig_webAddress + "?company=" + String(currentCompany)
        
        // Create NSURL Object
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        /* TESTING HERE */
        let sem = DispatchSemaphore(value: 0)
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //             print("responseString = \(responseString)")
            _ = String(describing: responseString!).components(separatedBy: ",")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    self.defaults.set(Int((convertedJsonIntoDict["location"] as? String)!)!,
                                      forKey: "location")
                    
                    self.defaults.set(Int((convertedJsonIntoDict["employeeThresh"] as? String)!)!,
                                      forKey: "employeeThresh")
                    
                    self.defaults.set(Int((convertedJsonIntoDict["threshold1"] as? String)!)!,
                                 forKey: "threshold1")
                    self.defaults.set(Int((convertedJsonIntoDict["threshold2"] as? String)!)!,
                                 forKey: "threshold2")
                    
                    self.defaults.set(Float((convertedJsonIntoDict["price1"] as? String)!)!,
                                 forKey: "price1")
                    self.defaults.set(Float((convertedJsonIntoDict["price2"] as? String)!)!,
                                 forKey: "price2")
                    
                    sem.signal()
//                    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                        print("\(key) = \(value) \n")
//                    }
//                    print(threshold1, threshold2, price1, price2)
//                    defaults.set(25, forKey: "Age")

                    
                    // Get value by key
                    //                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    //                    print(firstNameValue!)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
//        sem.wait(timeout: .distantFuture)
        /* FINISHED TESTING */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
