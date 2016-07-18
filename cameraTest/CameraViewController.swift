//
//  CameraViewController.swift
//  cameraTest
//
//  Created by Trevor J. Stone on 7/15/16.
//  Copyright © 2016 Trevor J. Stone. All rights reserved.
//
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // back camera
    var backCamera : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    backCamera = device as? AVCaptureDevice
                    if backCamera != nil {
                        print("Capture device found")
                        beginSession()
                    }
                }
            }
        }
    }
    
    // Sets the back cameras focus mode to "Locked"
    func configureDevice() {
        do {
            let device = backCamera
            try device!.lockForConfiguration()
            device!.focusMode = .Locked
            device!.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    
    func beginSession() {
        configureDevice()
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: backCamera))
            
        } catch {
            print(error)
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
}

