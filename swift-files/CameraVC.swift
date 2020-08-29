// Copied from storyboard project

import UIKit
import Photos
import AVFoundation
import FirebaseFirestore

@available(iOS 13.0, *)
class CameraVC: UIViewController, AVCaptureFileOutputRecordingDelegate {

//    private var spinner: UIActivityIndicatorView!
   var windowOrientation: UIInterfaceOrientation {
       return view.window?.windowScene?.interfaceOrientation ?? .unknown
   }


   override func viewDidLoad() {
       super.viewDidLoad()

       self.questionLabel.text = todaysQuestion.question
       self.questionLabel.lineBreakMode = .byWordWrapping
       recordButton.isEnabled = true
       self.questionLabel.isHidden = false
       self.questionLabel.isEnabled = true
       previewView.layoutMargins = UIEdgeInsets.zero
       previewView.videoPreviewLayer.frame = UIScreen.main.bounds

       // Set up the video preview view.
       previewView.session = session

       switch AVCaptureDevice.authorizationStatus(for: .video) {
       case .authorized:
           // The user has previously granted access to the camera.
           break
       case .notDetermined:
           /*
            The user has not yet been presented with the option to grant
            video access. Suspend the session queue to delay session
            setup until the access request has completed.

            Note that audio access will be implicitly requested when we
            create an AVCaptureDeviceInput for audio during session setup.
            */
           sessionQueue.suspend()
           AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
               if !granted {
                   self.setupResult = .notAuthorized
               }
               self.sessionQueue.resume()
           })

       default:
           // The user has previously denied access.
           setupResult = .notAuthorized
       }


       /*
        Setup the capture session.
        In general, it's not safe to mutate an AVCaptureSession or any of its
        inputs, outputs, or connections from multiple threads at the same time.

        Don't perform these tasks on the main queue because
        AVCaptureSession.startRunning() is a blocking call, which can
        take a long time. Dispatch session setup to the sessionQueue, so
        that the main queue isn't blocked, which keeps the UI responsive.
        */
       sessionQueue.async {
           self.configureSession()
       }

       DispatchQueue.main.async {
//            self.spinner = UIActivityIndicatorView(style: .large)
//            self.spinner.color = UIColor.red
//            self.previewView.addSubview(self.spinner)
       }

   // End viewDidLoad
   }

   override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)

          sessionQueue.async {
              switch self.setupResult {
              case .success:
                  // Only setup observers and start the session if setup succeeded.
                  self.addObservers()
                  self.session.startRunning()
                  self.isSessionRunning = self.session.isRunning

              case .notAuthorized:
                  DispatchQueue.main.async {
                      let changePrivacySetting = "Reeal doesn't have permission to use the camera, please change privacy settings"
                      let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                      let alertController = UIAlertController(title: "Reeal", message: message, preferredStyle: .alert)

                      alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                              style: .cancel,
                                                              handler: nil))

                      alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                              style: .`default`,
                                                              handler: { _ in
                                                                  UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                            options: [:],
                                                                                            completionHandler: nil)
                      }))

                      self.present(alertController, animated: true, completion: nil)
                  }

              case .configurationFailed:
                  DispatchQueue.main.async {
                      let alertMsg = "Alert message when something goes wrong during capture session configuration"
                      let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                      let alertController = UIAlertController(title: "Reeal", message: message, preferredStyle: .alert)

                      alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                              style: .cancel,
                                                              handler: nil))

                      self.present(alertController, animated: true, completion: nil)
                  }
              }
          }
      }

   override func viewWillDisappear(_ animated: Bool) {
       sessionQueue.async {
           if self.setupResult == .success {
               self.session.stopRunning()
               self.isSessionRunning = self.session.isRunning
               self.removeObservers()
           }
       }

       super.viewWillDisappear(animated)
   }


   // MARK: Session Management

   private enum SessionSetupResult {
       case success
       case notAuthorized
       case configurationFailed
   }

   private let session = AVCaptureSession()
   private var isSessionRunning = false

   // Communicate with the session and other session objects on ths queue
   private let sessionQueue = DispatchQueue(label: "session queue")

   private var setupResult: SessionSetupResult = .success

   @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!

   @IBOutlet private weak var previewView: CameraPreviewView!

   // Call this on the session queue
   /// - Tag: ConfigureSession
   private func configureSession() {
       if setupResult != .success {
           return
       }

       session.beginConfiguration()

       session.sessionPreset = .high

       // Add video input
       do {

           let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
           let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)

           if session.canAddInput(videoDeviceInput) {
               session.addInput(videoDeviceInput)
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

                   var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                   if self.windowOrientation != .unknown {
                       if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation){
                           initialVideoOrientation = videoOrientation
                       }
                   }

                   self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
               }

           } else {
               print("Couldn't add video device input to the ession.")
               setupResult = .configurationFailed
               session.commitConfiguration()
               return
           }
       } catch {
           print("Couldn't create videoa device input to the session.")
           setupResult = .configurationFailed
           session.commitConfiguration()
           return
       }

       // Add an audio input device
       do {
           let audioDevice = AVCaptureDevice.default(for: .audio)
           let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)

           if session.canAddInput(audioDeviceInput) {
               session.addInput(audioDeviceInput)
           } else {
               print("Could not add audio device input to the session.")
           }

       } catch {
           print("Couldn't create audio device input: \(error)")
       }

       // Add the video output
       let movieFileOutput = AVCaptureMovieFileOutput()

       if self.session.canAddOutput(movieFileOutput) {
           self.session.beginConfiguration()
           self.session.addOutput(movieFileOutput)
           self.session.sessionPreset = .high
           if let connection = movieFileOutput.connection(with: .video) {
               if connection.isVideoStabilizationSupported {
                   connection.preferredVideoStabilizationMode = .auto
               }
           }
           self.session.commitConfiguration()

//            DispatchQueue.main.async {
//                captureModeControl.isEnabled = true
//            }

           self.movieFileOutput = movieFileOutput

           DispatchQueue.main.async {
               self.recordButton.isEnabled = true
               self.questionLabel.isEnabled = true
               self.questionLabel.isHidden = false

               /*
                For photo captures during movie recording, Speed quality photo processing is prioritized
                to avoid frame drops during recording.
                */
               // self.photoQualityPrioritizationSegControl.selectedSegmentIndex = 0
               // self.photoQualityPrioritizationSegControl.sendActions(for: UIControl.Event.valueChanged)
           }
       }

       session.commitConfiguration()

   // End configureSession()
   }
   // MARK: Device Configuration
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet private weak var recordButton: UIButton!
   @IBOutlet weak var questionLabel: UILabel!
   @IBAction func cancelButtonAction(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
   }

   @IBAction func recordMovie(_ recordButton: UIButton) {

       print("You clicked record button...")

       guard let movieFileOutput = self.movieFileOutput else {
           return
       }

       /*
        Disable the Camera button until recording finishes, and disable
        the Record button until recording starts or finishes.

        See the AVCaptureFileOutputRecordingDelegate methods.
        */
       recordButton.isEnabled = false
       questionLabel.isEnabled = false


       let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation

       sessionQueue.async {
           if !movieFileOutput.isRecording {
               if UIDevice.current.isMultitaskingSupported {
                   self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
               }

               // Update the orientation on the movie file output video connection before recording.
               let movieFileOutputConnection = movieFileOutput.connection(with: .video)
               movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation!

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
   // MARK: Recording movies

   private var movieFileOutput: AVCaptureMovieFileOutput?
   private var backgroundRecordingID: UIBackgroundTaskIdentifier?

   /// - Tag: DidStartRecording
   func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
       DispatchQueue.main.async {
           self.recordButton.isEnabled = true
           self.questionLabel.isEnabled = false
           self.questionLabel.isHidden = true
           self.recordButton.setImage(UIImage(named: "Recording"), for: [])
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
           self.recordButton.isEnabled = true
           self.questionLabel.isEnabled = true
           self.questionLabel.isHidden = false
           self.recordButton.setImage(UIImage(named: "Record"), for: [])

           print("fileURL below")

           print(outputFileURL)

           FirebaseStorageManager().uploadTOFireBaseVideo(url: outputFileURL ) { (isSuccess, url) in

               let tempFeed = FeedItem();

               tempFeed.uid = globalUser.uid
               tempFeed.username = globalUser.username ?? ""
               tempFeed.reelUrl = url

               if (isSuccess) {
                   // Check whether the interval works
                   let reelToAdd = Reel(url: url ,date: Timestamp())
                   reelToAdd.updateReelCountAndUrl()
                   tempFeed.updateFriendsFeed()

               }

               print("uploadVideoData: \(isSuccess), \(url as Any)")
           }

       }
   }

   // MARK: KVO and Notifications

   private var keyValueObservations = [NSKeyValueObservation]()
   /// - Tag: ObserveInterruption
   private func addObservers() {
       let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
           guard let isSessionRunning = change.newValue else { return }


           DispatchQueue.main.async {
               // Only enable the ability to change camera if the device has more than one camera.

               self.recordButton.isEnabled = isSessionRunning && self.movieFileOutput != nil
               self.questionLabel.isEnabled = isSessionRunning && self.movieFileOutput != nil
//                self.questionLabel.isHidden = !(isSessionRunning && self.movieFileOutput != nil)
           }
       }
       keyValueObservations.append(keyValueObservation)

       let systemPressureStateObservation = observe(\.videoDeviceInput.device.systemPressureState, options: .new) { _, change in
           guard let systemPressureState = change.newValue else { return }
           self.setRecommendedFrameRateRangeForPressureState(systemPressureState: systemPressureState)
       }
       keyValueObservations.append(systemPressureStateObservation)


       NotificationCenter.default.addObserver(self,
                                              selector: #selector(sessionRuntimeError),
                                              name: .AVCaptureSessionRuntimeError,
                                              object: session)

       /*
        A session can only run when the app is full screen. It will be interrupted
        in a multi-app layout, introduced in iOS 9, see also the documentation of
        AVCaptureSessionInterruptionReason. Add observers to handle these session
        interruptions and show a preview is paused message. See the documentation
        of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
        */
       NotificationCenter.default.addObserver(self,
                                              selector: #selector(sessionWasInterrupted),
                                              name: .AVCaptureSessionWasInterrupted,
                                              object: session)

   }

   private func removeObservers() {
       NotificationCenter.default.removeObserver(self)

       for keyValueObservation in keyValueObservations {
           keyValueObservation.invalidate()
       }
       keyValueObservations.removeAll()
   }


   /// - Tag: HandleRuntimeError
   @objc
   func sessionRuntimeError(notification: NSNotification) {
       guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }

       print("Capture session runtime error: \(error)")
       // If media services were reset, and the last start succeeded, restart the session.
       if error.code == .mediaServicesWereReset {
           sessionQueue.async {
               if self.isSessionRunning {
                   self.session.startRunning()
                   self.isSessionRunning = self.session.isRunning
               }
           }
       }
   }

   /// - Tag: HandleSystemPressure
   private func setRecommendedFrameRateRangeForPressureState(systemPressureState: AVCaptureDevice.SystemPressureState) {
       /*
        The frame rates used here are only for demonstration purposes.
        Your frame rate throttling may be different depending on your app's camera configuration.
        */
       let pressureLevel = systemPressureState.level
       if pressureLevel == .serious || pressureLevel == .critical {
           if self.movieFileOutput == nil || self.movieFileOutput?.isRecording == false {
               do {
                   try self.videoDeviceInput.device.lockForConfiguration()
                   print("WARNING: Reached elevated system pressure level: \(pressureLevel). Throttling frame rate.")
                   self.videoDeviceInput.device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 20)
                   self.videoDeviceInput.device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 15)
                   self.videoDeviceInput.device.unlockForConfiguration()
               } catch {
                   print("Could not lock device for configuration: \(error)")
               }
           }
       } else if pressureLevel == .shutdown {
           print("Session stopped running due to shutdown system pressure level.")
       }
   }

   /// - Tag: HandleInterruption
   @objc
   func sessionWasInterrupted(notification: NSNotification) {
       /*
        In some scenarios you want to enable the user to resume the session.
        For example, if music playback is initiated from Control Center while
        using reeal, then the user can let reeal resume
        the session running, which will stop music playback. Note that stopping
        music playback in Control Center will not automatically resume the session.
        Also note that it's not always possible to resume, see `resumeInterruptedSession(_:)`.
        */
       if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
           let reasonIntegerValue = userInfoValue.integerValue,
           let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
           print("Capture session was interrupted with reason \(reason)")


           if reason == .audioDeviceInUseByAnotherClient || reason == .videoDeviceInUseByAnotherClient {
               print("Audio Device is used by another client+ work on resume button")
           } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
               // Fade-in a label to inform the user that the camera is unavailable.
               print("Video Device not available")
           } else if reason == .videoDeviceNotAvailableDueToSystemPressure {
               print("Session stopped running due to shutdown system pressure level.")
           }

       }
   }

// End CameraViewController
}

extension AVCaptureVideoOrientation {
   init?(deviceOrientation: UIDeviceOrientation) {
       switch deviceOrientation {
       case .portrait: self = .portrait
       case .portraitUpsideDown: self = .portraitUpsideDown
       case .landscapeLeft: self = .landscapeRight
       case .landscapeRight: self = .landscapeLeft
       default: return nil
       }
   }

   init?(interfaceOrientation: UIInterfaceOrientation) {
       switch interfaceOrientation {
       case .portrait: self = .portrait
       case .portraitUpsideDown: self = .portraitUpsideDown
       case .landscapeLeft: self = .landscapeLeft
       case .landscapeRight: self = .landscapeRight
       default: return nil
       }
   }
}

extension AVCaptureDevice.DiscoverySession {
   var uniqueDevicePositionsCount: Int {

       var uniqueDevicePositions = [AVCaptureDevice.Position]()

       for device in devices where !uniqueDevicePositions.contains(device.position) {
           uniqueDevicePositions.append(device.position)
       }

       return uniqueDevicePositions.count
   }
}