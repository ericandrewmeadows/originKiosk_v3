//
//  iPadLogs_upload.swift
//  originKiosk_v2
//
//  Created by Eric Meadows on 6/3/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import Foundation

var sentSuccessfully = false
let defaults = UserDefaults.standard
let mainUrl = "https://io.calmlee.com/ipad_commands.php"

func sendLogFile( dataFile_path: String ) {
    
    do {
        let attr: NSDictionary? = try FileManager.default.attributesOfItem(atPath: dataFile_path) as NSDictionary
        if let _attr = attr {
            let fileSize = _attr.fileSize();
            print(">> FS :" + String(fileSize) + " <<")
        }
    } catch {
        print("File Error")
    }
    
    let semaphore = DispatchSemaphore(value: 0);
    
    let url:  NSURL? = NSURL(string: mainUrl)
    
    let request = NSMutableURLRequest(url:url! as URL);
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
    
    
    if let imageData = NSData(contentsOfFile: dataFile_path) {
        
        let param = [
            "location" : defaults.string(forKey: "location")!,
            "version" : defaults.string(forKey: "version")!
        ]
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: {
                (data, response, error) -> Void in
                if let data = data {
                    if let httpResponse = response as? HTTPURLResponse {
                        if (httpResponse.statusCode == 200) {
                            // can delete log file (? or delete below); 200 = OK transmission
                        }
                    }
                    
                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    if ((responseString! as String) == "Success") {
                        // Remove the given file
                        do {
                            try FileManager.default.removeItem(atPath: dataFile_path)
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                    }
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
                
                sentSuccessfully = true
                
                semaphore.signal();
                
        })
        task.resume()
//        semaphore.wait(timeout: DispatchTime.now() + .seconds(10))
        if sentSuccessfully {
            let fileManager = FileManager.default
            try! fileManager.removeItem( atPath: dataFile_path )
        }
    }
    else {return}
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}



func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
    }
    
    let filename = "testing.csv"
    let mimetype = "text/csv"
    
    body.appendString(string: "--\(boundary)\r\n")
    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey as Data)
    body.appendString(string: "\r\n")
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    return body
}
