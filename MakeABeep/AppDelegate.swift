//
//  AppDelegate.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @objc var navigator: Navigator!
    var isGrantedNotificationAccess = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,_) in
                self.isGrantedNotificationAccess = granted
        }
        )
        FirebaseApp.configure()
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        var providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
//            FUITwitterAuth(),
            ]
        if let defaultAuthUI = authUI{
            providers.append(FUIPhoneAuth(authUI: defaultAuthUI))
            }
        authUI?.providers = providers
        
        navigator.appDelegate(didFinishLaunchingWithOptions: self)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print("didSignInWith user: \(user) error\(error)" )
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notification = response.notification
        
        let trigger = notification.request.trigger!
        
        
        if trigger.repeats == true, notification.request.trigger == notification.request.trigger as? UNTimeIntervalNotificationTrigger{
            
            let identifier = notification.request.identifier
            
            
            let content = UNMutableNotificationContent()
            content.title = "MakeABeep!"
            content.subtitle  = "The end!!!!"
            content.body = "The end!!!!!!!!!!!!!!!"
            
            
            let dateInterval = DateInterval(start: "00:00".toDate(format: "HH:mm")!, end: "00:01".toDate(format: "HH:mm")!)
            let duration = dateInterval.duration
            
            let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(Date().timeIntervalSince1970)",
                content: content,
                trigger: trigger2
            )
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        
        completionHandler()
    }
}
