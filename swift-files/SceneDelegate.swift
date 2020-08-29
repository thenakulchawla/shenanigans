//
//  SceneDelegate.swift
//  reeal-primitive
//
//  Created by Nakul Chawla on 2/1/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.
//
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        //Firebase
        let session = FirebaseSession()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(session))

            self.window = window
            window.makeKeyAndVisible()

        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    // MARK: - Notifications

    func userNotificationCenter(center: UNUserNotificationCenter,
                                didReceiveNotificationResponse response: UNNotificationResponse,
                                withCompletionHandler completionHandler: () -> Void) {
        print("didReceiveNotificationResponse")

        completionHandler()
    }

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        let userInfo = notification.request.content.userInfo

        let viewToShow = FriendRequestsView()

        let session = FirebaseSession()
        session.listen()

        globalUser.getFriendRequests() { isSuccess in
            if isSuccess {

                //TODO: make this in SceneDelegate
                if let window = UIApplication.shared.keyWindow {
                    self.window = window

                    window.rootViewController = UIHostingController(rootView: viewToShow.environmentObject(session))

                    window.makeKeyAndVisible()

                }

            }

        }



        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)


        // Change this to your preferred presentation option
        completionHandler([.badge, .alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveResponse")
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        let viewToShow = FriendRequestsView()

        let session = FirebaseSession()
        session.listen()

        globalUser.getFriendRequests() { isSuccess in
            if isSuccess {

                //TODO: make this in SceneDelegate
                if let window = UIApplication.shared.keyWindow {
                    self.window = window

                    window.rootViewController = UIHostingController(rootView: viewToShow.environmentObject(session))

                    window.makeKeyAndVisible()

                }

            }

        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }




}