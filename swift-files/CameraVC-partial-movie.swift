/*
CameraViewController.swift
reeal-primitive

Created by Nakul Chawla on 2/2/20.
Copyright © 2020 Nakul Chawla. All rights reserved.
*/

import UIKit
import Photos
import AVFoundation
import FirebaseFirestore


class CameraVC: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var movieFileOutput: AVCaptureMovieFileOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?
    
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private var setupResult: SessionSetupResult = .success
    
    // Communicate with the session and other session objects on ths queue
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    //DELEGATE
//    var movieDelegate: AVCaptureFileOutputRecordingDelegate?
    
    func didTapRecord() {
        
        print("You clicked record button...")
        
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }
        
        /*
         Disable the Camera button until recording finishes, and disable
         the Record button until recording starts or finishes.
         
         See the AVCaptureFileOutputRecordingDelegate methods.
         */
//        recordButton.isEnabled = false
//        questionLabel.isEnabled = false
        
        
//        let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation
        
        sessionQueue.async {
            if !movieFileOutput.isRecording {
                if UIDevice.current.isMultitaskingSupported {
                    self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                // Update the orientation on the movie file output video connection before recording.
                let movieFileOutputConnection = movieFileOutput.connection(with: .video)
//                movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation!
                
                let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
                
                if availableVideoCodecTypes.contains(.hevc) {
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                }
                
                // Start recording video to a temporary file.
                let outputFileName = NSUUID().uuidString
                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
            } else {
                movieFileOutput.stopRecording()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /// - Tag: DidStartRecording
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            //                self.recordButton.isEnabled = true
            //                self.questionLabel.isEnabled = false
            //                self.questionLabel.isHidden = true
            //                self.recordButton.setImage(UIImage(named: "Recording"), for: [])
        }
    }
    
    /// - Tag: DidFinishRecording
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        // Note: Because we use a unique file path for each recording, a new recording won't overwrite a recording mid-save.
        func cleanup() {
            let path = outputFileURL.path
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("Could not remove file at url: \(outputFileURL)")
                }
            }
            
            if let currentBackgroundRecordingID = backgroundRecordingID {
                backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
                
                if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                    UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                }
            }
            
        }
        
        var success = true
        
        if error != nil {
            print("Movie file finishing error: \(String(describing: error))")
            success = (((error! as NSError).userInfo[AVErrorRecordingSuccessfullyFinishedKey] as AnyObject).boolValue)!
        }
        
        if success {
            // Check the authorization status
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    // Save the movie file to the photo library and cleanup
                    PHPhotoLibrary.shared().performChanges({
                        let options = PHAssetResourceCreationOptions()
                        options.shouldMoveFile = true
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
                    }, completionHandler: { success, error in
                        if !success {
                            print("Couldn't save the movie to your photot library: \(String(describing:error))")
                        }
                        cleanup()
                    }
                    )
                    
                } else {
                    cleanup()
                }
            }
        } else {
            cleanup()
        }
        
        DispatchQueue.main.async {
            //                self.recordButton.isEnabled = true
            //                self.questionLabel.isEnabled = true
            //                self.questionLabel.isHidden = false
            //                self.recordButton.setImage(UIImage(named: "Record"), for: [])
            
            print("fileURL below")
            
            print(outputFileURL)
            
            //                FirebaseStorageManager().uploadTOFireBaseVideo(url: outputFileURL ) { (isSuccess, url) in
            //
            //                    let tempFeed = FeedItem();
            //
            //                    tempFeed.uid = globalUser.uid
            //                    tempFeed.username = globalUser.username ?? ""
            //                    tempFeed.reelUrl = url
            //
            //                    if (isSuccess) {
            //                        // Check whether the interval works
            //
            //                        let reelToAdd = Reel(url: url ,date: Timestamp())
            //                        reelToAdd.updateReelCountAndUrl()
            //                        tempFeed.updateFriendsFeed()
            //
            //                    }
            //
            //                    print("uploadVideoData: \(isSuccess), \(url as Any)")
            //                }
            
        }
    }
    
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutputForMovie()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            
            switch device.position {
                case AVCaptureDevice.Position.front:
                    self.frontCamera = device
                case AVCaptureDevice.Position.back:
                    self.backCamera = device
                default:
                    break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    

    func setupInputOutputForMovie() {
        if setupResult != .success {
            return
        }
        
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = .high
        
        // Add video input
        do {
            
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                DispatchQueue.main.async {
                    /*
                     Dispatch video streaming to the main queue because AVCaptureVideoPreviewLayer is the backing layer for PreviewView.
                     You can manipulate UIView only on the main thread.
                     Note: As an exception to the above rule, it's not necessary to serialize video orientation changes
                     on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                     Use the window scene's orientation as the initial video orientation. Subsequent orientation changes are
                     handled by CameraViewController.viewWillTransition(to:with:).
                     */
                    
                    self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.cameraPreviewLayer?.frame = self.view.frame
                    self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
                    
                }
                
            } else {
                print("Couldn't add video device input to the ession.")
                setupResult = .configurationFailed
                captureSession.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create videoa device input to the session.")
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
        
        // Add an audio input device
        do {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if captureSession.canAddInput(audioDeviceInput) {
                captureSession.addInput(audioDeviceInput)
            } else {
                print("Could not add audio device input to the session.")
            }
            
        } catch {
            print("Couldn't create audio device input: \(error)")
        }
        
        // Add the video output
        let movieFileOutput = AVCaptureMovieFileOutput()
        
        if self.captureSession.canAddOutput(movieFileOutput) {
            self.captureSession.beginConfiguration()
            self.captureSession.addOutput(movieFileOutput)
            self.captureSession.sessionPreset = .high
            if let connection = movieFileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
            self.captureSession.commitConfiguration()
            
            self.movieFileOutput = movieFileOutput
            
            DispatchQueue.main.async {
//                self.recordButton.isEnabled = true
//                self.questionLabel.isEnabled = true
//                self.questionLabel.isHidden = false
                
                /*
                 For photo captures during movie recording, Speed quality photo processing is prioritized
                 to avoid frame drops during recording.
                 */
                // self.photoQualityPrioritizationSegControl.selectedSegmentIndex = 0
                // self.photoQualityPrioritizationSegControl.sendActions(for: UIControl.Event.valueChanged)
            }
        }
        
        captureSession.commitConfiguration()
        
    }
    
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
}
