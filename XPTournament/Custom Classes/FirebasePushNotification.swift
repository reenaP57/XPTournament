//
//  FirebasePushNotification.swift
//  XPTournament
//
//  Created by mac-0005 on 04/02/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications

let CNotificationType = "notification_type"
let CNotificationData = "gcm.notification.data"
let kScreenMovingTime = 0.5


class FirebasePushNotification: NSObject {
    
    // MARK:- Singletone class setup..
    // MARK:-
    private override init() {
        super.init()
    }
    
    private static var firebasePushNotification: FirebasePushNotification = {
        let firebasePushNotification = FirebasePushNotification()
        return firebasePushNotification
    }()
    
    static func shared() ->FirebasePushNotification {
        return firebasePushNotification
    }
}

// MARK:- Firebase Setup
// MARK:-
extension FirebasePushNotification {
    
    // Initialization
    func Initialization(_ application: UIApplication) {
        FirebaseApp.configure()

//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
 
}

// MARK:- MessagingDelegate
// MARK:-
extension FirebasePushNotification: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken ===== ",fcmToken)
        // Do your Stuffs here...
        CUserDefaults.setValue(fcmToken, forKey: UserDefaultNotificationToken)
        CUserDefaults.synchronize()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        self.actionOnPushNotification(userInfo, isComingFromQuit: false)
//        print("didReceive ======", userInfo)
//        
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        self.actionOnPushNotification(userInfo, isComingFromQuit: false)
//        print("willPresent ======", userInfo)
//        
//    }
}

// MARK:- UNUserNotificationCenterDelegate
// MARK:-
//extension FirebasePushNotification: UNUserNotificationCenterDelegate {
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
////        Messaging.messaging().apnsToken = deviceToken as Data
//
//        // Do your Stuffs here...
//    }
//}

// MARK:- Notification Navigation
// MARK:-

extension FirebasePushNotification {
    func actionOnPushNotification(_ userInfo: [AnyHashable: Any], isComingFromQuit: Bool) {
        
        if let notificationJsonString = userInfo.valueForJSON(key: CNotificationData) as? String {
            /*
            if let notificationInfo = MIMQTT.shared().convertToDictionary(text: notificationJsonString) {
                
                print("didReceiveNotification ====== ", notificationInfo)
                
                let applicationState = UIApplication.shared.applicationState
                let viewController = appDelegate.getTopMostViewController()
                let notificationType = notificationInfo.valueForInt(key: CNotificationType)
                
                if applicationState == .active && !isComingFromQuit {
                    
                    let notTitle = notificationInfo.valueForString(key: "title")
                    let notBody = notificationInfo.valueForString(key: "body")
                    
                    switch notificationType {
                    case 1, 2:
                        // 1 = Group Chat
                        // 2 = OTO Chat
                        if !viewController.isKind(of: UserChatDetailViewController.classForCoder()) && !viewController.isKind(of: ChatListViewController.classForCoder()) && !viewController.isKind(of: GroupsViewController.classForCoder()) && !viewController.isKind(of: GroupChatDetailsViewController.classForCoder()) {
                            NotificationAlertView.shared?.showNotification(notTitle, message: notBody, imageName: "", completion: { (completion) in
                                notificationType == 1 ? self.moveOnGroupChatScreen(notificationInfo) : self.moveOnOTOChatScreen(notificationInfo)
                            })
                        }
                        
                        break
                    default:
                        break
                    }
                }else {
                    // From Background.
                    
                    switch notificationType {
                    case 1, 2:
                        // 1 = Group Chat
                        // 2 = OTO Chat
                        if !viewController.isKind(of: UserChatDetailViewController.classForCoder()) && !viewController.isKind(of: ChatListViewController.classForCoder()) && !viewController.isKind(of: GroupsViewController.classForCoder()) && !viewController.isKind(of: GroupChatDetailsViewController.classForCoder()) {
                            notificationType == 1 ? self.moveOnGroupChatScreen(notificationInfo) : self.moveOnOTOChatScreen(notificationInfo)
                        }
                        break
                    default:
                        break
                    }
                }
            }
       */
        }
    }
    
}

