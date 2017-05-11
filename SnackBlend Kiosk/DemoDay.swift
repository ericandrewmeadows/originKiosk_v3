//
//  DemoDay.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 3/19/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit

class DemoDay: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName as! String)
            print("Font Names = [\(names)]")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageName = "OriginLogo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: self.screenSize.height * 0.1,
                                 width: self.screenSize.width,
                                 height: self.screenSize.height * 0.2)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let intOffset = self.screenSize.width * 0.05
        
        let flavorOffsetY = self.screenSize.height * 0.4
        
        let smoothie1 = "Berry Blast"
        let ingred1   = "Strawberry\nBlueberry\nBanana\nSpinach\nAlmond Milk"
        let smoothie2 = "A Little Bit Country"
        let ingred2   = "Apple\nStrawberry\nBlueberry\nKale\nAlmond Milk"
        let smoothie3 = "GoManGo"
        let ingred3   = "Mango\nStrawberry\nSpinach\nPeanut Butter\nAlmond Milk"
        
        //AvenirNextCondensed-Bold
        let flavorFont = UIFont(name: "Avenir-Heavy", size: self.screenSize.height * 0.05)
        
        let flavor1 = UILabel()
        flavor1.frame = CGRect(x: 0 + intOffset,
                               y: flavorOffsetY,
                             width: self.screenSize.width/3 - intOffset * 3 / 2,
                             height: self.screenSize.height * 0.1)
        flavor1.text = smoothie1
        flavor1.numberOfLines = 0
        flavor1.lineBreakMode = .byWordWrapping
        flavor1.font = flavorFont
        flavor1.textAlignment = NSTextAlignment.center
        flavor1.sizeToFit()
        flavor1.textAlignment = NSTextAlignment.center
        view.addSubview(flavor1)
        
        let flavor2 = UILabel()
        flavor2.frame = CGRect(x: self.screenSize.width/3 - intOffset,
                               y: flavorOffsetY,
                               width: self.screenSize.width/3 - intOffset,
                               height: self.screenSize.height * 0.1)
        flavor2.text = smoothie2
        flavor2.numberOfLines = 0
        flavor2.lineBreakMode = .byWordWrapping
        flavor2.font = flavor1.font
        flavor2.textAlignment = NSTextAlignment.center
        flavor2.sizeToFit()
        flavor2.frame = CGRect(x: flavor2.frame.maxX-self.screenSize.width/6,
                               y: flavor2.frame.minY,
                               width: flavor2.frame.width,
                               height: flavor2.frame.height)
        flavor2.textAlignment = NSTextAlignment.center
        view.addSubview(flavor2)
        
        let flavor3 = UILabel()
        flavor3.frame = CGRect(x: self.screenSize.width - intOffset - (self.screenSize.width/3 - intOffset * 3 / 2),
                               y: flavorOffsetY,
                               width: self.screenSize.width/3 - intOffset * 3 / 2,
                               height: self.screenSize.height * 0.1)
        flavor3.text = smoothie3
        flavor3.numberOfLines = 0
        flavor3.lineBreakMode = .byWordWrapping
        flavor3.font = flavor1.font
        flavor3.textAlignment = NSTextAlignment.center
        flavor3.sizeToFit()
        view.addSubview(flavor3)
        
        // Alignment Fix
        flavor2.frame.origin.x = self.screenSize.width / 2 - flavor2.frame.width / 2
        let flavor1_offsetX = (flavor2.frame.minX) / 2 - flavor1.frame.width / 2
        let flavor3_offsetX = flavor2.frame.maxX + (flavor2.frame.minX) / 2 -
                                flavor3.frame.width / 2
        flavor1.frame.origin.x = flavor1_offsetX
        flavor3.frame.origin.x = flavor3_offsetX
        
        let flavor_centerY = flavor2.frame.minY + (max(flavor1.frame.maxY, max(flavor2.frame.maxY, flavor3.frame.maxY)) - flavor2.frame.minY) / 2
        flavor1.frame.origin.y = flavor_centerY - flavor1.frame.height / 2
        flavor2.frame.origin.y = flavor_centerY - flavor2.frame.height / 2
        flavor3.frame.origin.y = flavor_centerY - flavor3.frame.height / 2
        
        
        
        // Ingredients
        let infoOffset = max(flavor1.frame.maxY, max(flavor2.frame.maxY, flavor3.frame.maxY)) + self.screenSize.height * 0.03
        let ingredientFont = UIFont(name: "Avenir", size: self.screenSize.height * 0.04)
        
        let info1 = UILabel()
        info1.frame = CGRect(x: flavor1.frame.minX,
                             y: infoOffset,
                             width: flavor1.frame.maxX - flavor1.frame.minX,
                             height: self.screenSize.height * 0.1)
        info1.text = ingred1
        info1.numberOfLines = 0
//        info1.lineBreakMode = .byWordWrapping
        info1.font = ingredientFont
        info1.textAlignment = NSTextAlignment.center
        info1.sizeToFit()
        info1.frame.origin.x = (flavor1.frame.origin.x + flavor1.frame.width / 2) -
                                (info1.frame.origin.x + info1.frame.width/2) +
                                info1.frame.origin.x
        view.addSubview(info1)
        
        let info2 = UILabel()
        info2.frame = CGRect(x: flavor2.frame.minX,
                             y: infoOffset,
                             width: flavor2.frame.width,
                             height: self.screenSize.height * 0.1)
        info2.text = ingred2
        info2.numberOfLines = 0
//        info2.lineBreakMode = .byWordWrapping
        info2.font = info1.font
        info2.textAlignment = NSTextAlignment.center
        info2.sizeToFit()
        info2.frame.origin.x = (flavor2.frame.origin.x + flavor2.frame.width / 2) -
            (info2.frame.origin.x + info2.frame.width/2) +
            info2.frame.origin.x
        view.addSubview(info2)
        
        let info3 = UILabel()
        info3.frame = CGRect(x: flavor3.frame.minX,
                             y: infoOffset,
                             width: self.screenSize.width/3 - intOffset * 3 / 2,
                             height: self.screenSize.height * 0.1)
        info3.text = ingred3
        info3.numberOfLines = 0
//        info3.lineBreakMode = .byWordWrapping
        info3.font = info1.font
        info3.textAlignment = NSTextAlignment.center
        info3.sizeToFit()
        info3.frame.origin.x = (flavor3.frame.origin.x + flavor3.frame.width / 2) -
            (info3.frame.origin.x + info3.frame.width/2) +
            info3.frame.origin.x
        view.addSubview(info3)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
