//
//  AppDelegate.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 10/03/25.
//

import UIKit
import IQKeyboardToolbarManager
import GoogleSignIn
import UserNotifications
import FirebaseCore
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardToolbarManager.shared.isEnabled = true
        // Override point for customization after application launch.
        
        FirebaseApp.configure() // ✅ Add this
        Messaging.messaging().delegate = self // ✅ Add this too

        registerForPushNotifications()

        
        return true
    }

    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📦 Refreshed FCM Token: \(fcmToken ?? "")")
        // Send to server if needed
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
        
        Messaging.messaging().token { token, error in
            if let token = token {
                print("🔥 FCM Token: \(token)")
            } else if let error = error {
                print("❌ Error getting FCM token: \(error.localizedDescription)")
            }
        }
    }

    // Called when APNs failed to register the device
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register: \(error.localizedDescription)")
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

