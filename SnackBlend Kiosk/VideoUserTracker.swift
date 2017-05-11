//
//  VideoUserTracker.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 3/8/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit
import AVFoundation

//import Metal
//import MetalKit
//
//import Accelerate
//import MetalPerformanceShaders

class VideoUserTracker: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /*
     NEW SECTION HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    */
    
//    var device : MTLDevice = MTLCreateSystemDefaultDevice()!
    
    
    
    /*
     NEW SECTION HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    */
    

    
    var bytesPerRows: size_t = 0
    var rowCount = 0

    var cameraImage: CIImage?
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow,
                                                                                      CIDetectorTracking: true])
    
    internal func captured(image: UIImage) {
        imageView.image = image
        
//        eyeImage(cameraImage: cameraImage!, leftEye: true)
        
//        let openCVWrapper = OpenCVWrapper()
        
        let detector: CIDetector = CIDetector(ofType:CIDetectorTypeFace, context:nil, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])!;
//        let results:NSArray = detector.featuresInImage(CIImage(image, options: NSDictionary());
        let results: NSArray = detector.features(in: CIImage(image: image)!) as NSArray
        print(results)
//        openCVWrapper.isThisWorking()

//        let processedImage = OpenCVWrapper.processImage(withOpenCV: image)

    }
    
    @IBOutlet weak var imageView: UIImageView!

//    // create CIDetector object with CIDetectorTypeFace type
//    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
//    context:nil
//    options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
//    
//    // give it CIImage and receive an array with CIFaceFeature objects
//    NSArray *features = [detector featuresInImage:newImage];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCameraSession()
//
        self.view.layer.addSublayer(self.previewLayer)
//
        self.cameraSession.startRunning()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetHigh
        return s
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResizeAspect
        return preview!
    }()
    
    func setupCameraSession() {
        
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        
        for device in videoDevices!{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.front {
                captureDevice = device
                break
            }
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            
            cameraSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    func exifOrientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        default:
            return 6
        }
    }
    
    func videoBox(frameSize: CGSize, apertureSize: CGSize) -> CGRect {
        let apertureRatio = apertureSize.height / apertureSize.width
        let viewRatio = frameSize.width / frameSize.height
        
        var size = CGSize.zero
        
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width
            size.height = apertureSize.width * (frameSize.width / apertureSize.height)
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width)
            size.height = frameSize.height
        }
        
        var videoBox = CGRect(origin: .zero, size: size)
        
        if (size.width < frameSize.width) {
            videoBox.origin.x = (frameSize.width - size.width) / 2.0
        } else {
            videoBox.origin.x = (size.width - frameSize.width) / 2.0
        }
        
        if (size.height < frameSize.height) {
            videoBox.origin.y = (frameSize.height - size.height) / 2.0
        } else {
            videoBox.origin.y = (size.height - frameSize.height) / 2.0
        }
        
        return videoBox
    }
    
    func calculateFaceRect(facePosition: CGPoint, faceBounds: CGRect, clearAperture: CGRect) -> CGRect {
        let parentFrameSize = previewLayer.frame.size
        let previewBox = videoBox(frameSize: parentFrameSize, apertureSize: clearAperture.size)
        
        var faceRect = faceBounds
        
        swap(&faceRect.size.width, &faceRect.size.height)
        swap(&faceRect.origin.x, &faceRect.origin.y)
        
        let widthScaleBy = previewBox.size.width / clearAperture.size.height
        let heightScaleBy = previewBox.size.height / clearAperture.size.width
        
        faceRect.size.width *= widthScaleBy
        faceRect.size.height *= heightScaleBy
        faceRect.origin.x *= widthScaleBy
        faceRect.origin.y *= heightScaleBy
        
        faceRect = faceRect.offsetBy(dx: 0.0, dy: previewBox.origin.y)
        let frame = CGRect(x: parentFrameSize.width - faceRect.origin.x - faceRect.size.width / 2.0 - previewBox.origin.x / 2.0, y: faceRect.origin.y, width: faceRect.width, height: faceRect.height)
        
        return frame
    }
    
    /*
        NEW SECTION HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    */
    
    /*
     NEW SECTION ENDS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     */
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you collect each frame and process it
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [String : Any]?)
        
        // Current Section that works
        let options: [String : Any] = [CIDetectorImageOrientation: exifOrientation(orientation: UIDevice.current.orientation),
                                       CIDetectorSmile: true,
                                       CIDetectorEyeBlink: true]
        let allFeatures = faceDetector?.features(in: ciImage, options: options)
        
        let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        let cleanAperture = CMVideoFormatDescriptionGetCleanAperture(formatDescription!, false)
        
        guard let features = allFeatures else { return }
        
//        // Removed
        func getImageArray() -> NSData {
            CVPixelBufferLockBaseAddress(pixelBuffer!,CVPixelBufferLockFlags(rawValue: 0));
            
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer!);
            self.bytesPerRows = bytesPerRow
            let width = CVPixelBufferGetWidth(pixelBuffer!);
            let height = CVPixelBufferGetHeight(pixelBuffer!);
            self.rowCount = height;
            let src_buff = CVPixelBufferGetBaseAddress(pixelBuffer!);
            let data = NSData(bytes: src_buff!, length: bytesPerRow * height)
            return data
        }
//        var _ = getImageArray()
//        print(self.bytesPerRows, self.rowCount)
        
        
        /*
         NEW SECTION HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        */
        
        
        
        /*
         NEW SECTION HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        */
//        print(texture(pixelBuffer: pixelBuffer!))
        
        
//        print(getImageArray())
        
        
//        for feature in features {
//            if let faceFeature = feature as? CIFaceFeature {
//                print(faceFeature.trackingID, faceFeature.bounds)
//            }
//        }
        
        
        
        // OLD
        //, faceFeature.faceAngle)
//                let faceRect = calculateFaceRect(facePosition: faceFeature.mouthPosition, faceBounds: faceFeature.bounds, clearAperture: cleanAperture)
//                let featureDetails = ["has smile: \(faceFeature.hasSmile)",
//                    "has closed left eye: \(faceFeature.leftEyeClosed)",
//                    "has closed right eye: \(faceFeature.rightEyeClosed)"]
//                print(faceFeature.hasSmile)
//                
//                update(with: faceRect, text: featureDetails.joined(separator: "\n"))
//            }
//        }
        
//        if features.count == 0 {
//            DispatchQueue.main.async {
//                self.detailsView.alpha = 0.0
//            }
//        }

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you can count how many frames are dropped
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
