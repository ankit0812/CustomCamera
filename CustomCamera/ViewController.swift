//
//  ViewController.swift
//  CustomCamera
//
//  Created by KingpiN on 10/04/17.
//  Copyright © 2017 KingpiN. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: BBDarkThemedViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var toolbarView: UIView!

    @IBOutlet weak var flashButtonOutlet: UIButton!
    @IBOutlet weak var flipButtonOutlet: UIButton!
    
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var flashOffImage: UIImage?
    var flashOnImage: UIImage?
    var videoStartImage: UIImage?
    var videoStopImage: UIImage?
    var isRecording = false
    
    var transform = CGAffineTransform(a: -0.598460069057858, b: -0.801152635733831, c: 0.801152635733831, d: -0.598460069057858, tx: 0.0, ty: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        // AVCapture
        
        self.toolbarView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        session = AVCaptureSession()
        
        self.navigationController?.title = "Camera"
        
        for device in AVCaptureDevice.devices() {
            if let device = device as? AVCaptureDevice , device.position == AVCaptureDevicePosition.back {
                self.device = device
            }
        }
        
        do {
            
            if let session = session {
                
                videoInput = try AVCaptureDeviceInput(device: device)
                
                session.addInput(videoInput)
                
                // Don't allow use of microphone
                session.usesApplicationAudioSession = false
                    
                videoOutput = AVCaptureMovieFileOutput()
                let totalSeconds = 15.0     //Total Seconds of capture time
                let timeScale: Int32 = 30 //FPS
                
                let maxDuration = CMTimeMakeWithSeconds(totalSeconds, timeScale)
                
                videoOutput?.maxRecordedDuration = maxDuration
                videoOutput?.minFreeDiskSpaceLimit = 1024 * 1024 //SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
                
                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
                
                let videoLayer = AVCaptureVideoPreviewLayer(session: session)
                videoLayer?.frame = self.cameraView.bounds
                videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                self.cameraView.layer.addSublayer(videoLayer!)
                session.startRunning()
            }
            cameraView.bringSubview(toFront: flashButtonOutlet)
            cameraView.bringSubview(toFront: flipButtonOutlet)
            
            videoStartImage = UIImage(named: "video_button")
            videoStopImage = UIImage(named: "video_button_rec")
        } catch {
            print ("error occured kutreya")
        }
        flashConfiguration()
        self.startCamera()
    }
    
    func startCamera() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.authorized {
            session?.startRunning()
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            session?.stopRunning()
        }
    }
    
    func stopCamera() {
        if self.isRecording {
            self.toggleRecording()
        }
        session?.stopRunning()
    }

    func toggleRecording() {
        guard let videoOutput = videoOutput else {
            return
        }
        
        self.isRecording = !self.isRecording
        
        let shotImage: UIImage?
        if self.isRecording {
            shotImage = videoStopImage
        } else {
            shotImage = videoStartImage
        }
        recordButtonOutlet.setImage(shotImage, for: UIControlState())
        
        if self.isRecording {
            
            let outputPath = "\(NSTemporaryDirectory())originalVideo.mov"
            let outputURL = URL(fileURLWithPath: outputPath)
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: outputPath) {
                do {
                    try fileManager.removeItem(atPath: outputPath)
                } catch {
                    print("error removing item at path: \(outputPath)")
                    self.isRecording = false
                    return
                }
            }
            flipButtonOutlet.isEnabled = false
            flashButtonOutlet.isEnabled = false
            videoOutput.startRecording(toOutputFileURL: outputURL, recordingDelegate: self)
        } else {
            videoOutput.stopRecording()
            flipButtonOutlet.isEnabled = true
            flashButtonOutlet.isEnabled = true
        }
        return
    }
    
    func flashConfiguration() {
        do {
            if let device = device {
                try device.lockForConfiguration()
                device.flashMode = AVCaptureFlashMode.off
                flashButtonOutlet.setImage(UIImage(named: "ico_flash_button"), for: .normal)
                device.unlockForConfiguration()
            }
        } catch _ {
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flashButtonAction(_ sender: Any) {
        do {
            if let device = device {
                try device.lockForConfiguration()
                let mode = device.flashMode
                if mode == AVCaptureFlashMode.off {
                    device.flashMode = AVCaptureFlashMode.on
                    flashButtonOutlet.setImage(UIImage(named: "ico_flash_button"), for: .normal)
                } else if mode == AVCaptureFlashMode.on {
                    device.flashMode = AVCaptureFlashMode.off
                    flashButtonOutlet.setImage(UIImage(named: "ico_flash_button"), for: .normal)
                }
                device.unlockForConfiguration()
            }
        } catch _ {
            flashButtonOutlet.setImage(UIImage(named: "ico_flash_button"), for: .normal)
            return
        }
        
    }


    @IBAction func flipButtonAction(_ sender: Any) {
        let button = sender as! UIButton
        print(button.transform)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {

            button.transform = self.transform
            self.transform = self.transform == CGAffineTransform(a: -0.598460069057858, b: -0.801152635733831, c: 0.801152635733831, d: -0.598460069057858, tx: 0.0, ty: 0.0) ? CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0) : CGAffineTransform(a: -0.598460069057858, b: -0.801152635733831, c: 0.801152635733831, d: -0.598460069057858, tx: 0.0, ty: 0.0)
            self.session?.stopRunning()
            do {
                self.session?.beginConfiguration()
                if let session = self.session {
                    for input in session.inputs {
                        session.removeInput(input as! AVCaptureInput)
                    }
                    let position = (self.videoInput?.device.position == AVCaptureDevicePosition.front) ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front
                    for device in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
                        if let device = device as? AVCaptureDevice , device.position == position {
                            self.videoInput = try AVCaptureDeviceInput(device: device)
                            session.addInput(self.videoInput)
                        }
                    }
                }
                self.session?.commitConfiguration()
            } catch {
            }
            self.session?.startRunning()
        }, completion: nil)
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    
    func manageCroppingToSquare(filePath: URL , completion: @escaping (_ outputURL : URL?) -> ()) {
        
        // output file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let outputPath = documentsURL?.appendingPathComponent("squareVideo.mov")
        if FileManager.default.fileExists(atPath: (outputPath?.path)!) {
            do {
               try FileManager.default.removeItem(atPath: (outputPath?.path)!)
            }
            catch {
                print ("Error deleting file")
            }
        }
        
        //input file
        let asset = AVAsset.init(url: filePath)
        print (asset)
        let composition = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //input clip
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        //make it square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: CGFloat(clipVideoTrack.naturalSize.height), height: CGFloat(clipVideoTrack.naturalSize.height))
        videoComposition.frameDuration = CMTimeMake(1, 30)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        //rotate to potrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
        let t2: CGAffineTransform = t1.rotated(by: .pi/2)
        let finalTransform: CGAffineTransform = t2
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //exporter 
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        exporter?.outputURL = outputPath
        exporter?.videoComposition = videoComposition
        
        exporter?.exportAsynchronously() { handler -> Void in
            if exporter?.status == .completed {
                print("Export complete")
                DispatchQueue.main.async(execute: {
                    completion(outputPath)
                })
                return
            } else if exporter?.status == .failed {
                print("Export failed - \(String(describing: exporter?.error))")
            }
            completion(nil)
            return
        }
    }
}

extension ViewController : AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("started recording to: \(fileURL)")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("finished recording to: \(outputFileURL)")
        manageCroppingToSquare(filePath: outputFileURL) { (url) in
            let vcNew = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoEditorViewController") as! VideoEditorViewController
            vcNew.assetsURL = url
            self.navigationController?.pushViewController(vcNew, animated: true)
        }
    }
}
