//
//  AppDelegate.swift
//  XPTournament
//
//  Created by mac-00017 on 13/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications

typealias deviceTokenSuccessCompletion = (() -> ())?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var loginUser: TblUser?
    var tabbarViewcontroller: TabbarViewController?
    var tabbarView: TabbarView?
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window.backgroundColor = ColorWhite
        
        // IQKeyboardManager related functions
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Set root view controller of the application.
        self.initRootViewController()
        window.makeKeyAndVisible()
        
        // Firebase Initialization
//        FirebasePushNotification.shared().Initialization(application)
        self.registerRemoteNotification(application: application)
        
        return true
    }
    
}

// MARK:- ------- PushNotification
// MARK:-
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerRemoteNotification(application: UIApplication) {
        
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: ((granted)")
        }

        UIApplication.shared.registerForRemoteNotifications()
        
        // Firebase Initialization
        FirebasePushNotification.shared().Initialization(application)
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: (error)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        FirebasePushNotification.shared().actionOnPushNotification(userInfo, isComingFromQuit: false)
        print("didReceive ======", userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        FirebasePushNotification.shared().actionOnPushNotification(userInfo, isComingFromQuit: false)
        print("willPresent ======", userInfo)
    }
}


//MARK:-
//MARK:- ------------ Application Flow
extension AppDelegate {
    func initRootViewController() {
        // Checking for user auto login..
        if CUserDefaults.value(forKey: UserDefaultRememberMe) != nil && CUserDefaults.value(forKey: UserDefaultUserID) != nil{
            loginUser = TblUser.findOrCreate(dictionary: ["id": CUserDefaults.object(forKey: UserDefaultUserID) as Any]) as? TblUser
            // Move user to home screen..
            appDelegate.deviceToken(type: CLoginType, successCompletion: {
                
            })
            self.initHomeViewController()
        }else {
            // Move user to login screen..
            self.initLoginViewController()
        }
        
    }
    
    func initLoginViewController(){
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController"))
        appDelegate.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
    }
    
    func initHomeViewController() {
        appDelegate.tabbarViewcontroller = TabbarViewController.initWithNibName() as? TabbarViewController
        appDelegate.setWindowRootViewController(rootVC: appDelegate.tabbarViewcontroller, animated: true, completion: nil)
    }
    
    // MARK:-
    // MARK:- ------------Root update
    
    func setWindowRootViewController(rootVC: UIViewController?, animated:Bool, completion: ((Bool) -> Void)?) {
        
        guard rootVC != nil else {
            return
        }
        
        UIView.transition(with: self.window, duration: animated ? 0.6 : 0.0, options: .transitionCrossDissolve, animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            
            self.window.rootViewController = rootVC
            UIView.setAnimationsEnabled(oldState)
        }) { (finished) in
            if let handler = completion {
                handler(true)
            }
        }
    }
    
    //MARK:-
    //MARK:- ------------ TabBar Controller
    func hideTabBar() {
        appDelegate.tabbarView?.CViewSetY(y: CScreenHeight)
    }
    
    func showTabBar() {
        appDelegate.tabbarView?.CViewSetY(y: CScreenHeight - 49.0 - (IS_iPhone_X_Series ? 34.0 : 0.0))
    }
}

// MARK:- ---------- General Method

extension AppDelegate {
    
    func logOut() {
        appDelegate.loginUser = nil
        TblUser.deleteAllObjects()
        TblRoundNotes.deleteAllObjects()
        CoreData.saveContext()
        CUserDefaults.removeObject(forKey: UserDefaultUserID)
        CUserDefaults.removeObject(forKey: UserDefaultRememberMe)
        CUserDefaults.synchronize()
        
        self.hideTabBar()
        appDelegate.tabbarView?.btnTabClicked(sender: (appDelegate.tabbarView?.btnHome)!)
        appDelegate.tabbarViewcontroller = nil
        appDelegate.initLoginViewController()
    }
    
    func deviceToken(type: Int, successCompletion: deviceTokenSuccessCompletion) {
        let token = CUserDefaults.string(forKey: UserDefaultNotificationToken)
        if token != nil {
            _ = APIRequest.shared().addRemoveToken(type: type, completion: { (response, error) in
                if (response != nil && error == nil) {
                    successCompletion?()
                }
            })
        } else {
            return
        }
        
    }
    
    func getTopMostViewController() -> UIViewController {
        let viewcontroller = CTopMostViewController
//        if viewcontroller.isKind(of: LGSideMenuController.classForCoder()) {
//            if let sideVC = viewcontroller as? LGSideMenuController {
//                if (sideVC.rootViewController?.isKind(of: UINavigationController.classForCoder()))!{
//                    if let navVC = sideVC.rootViewController as? UINavigationController {
//                        return navVC.viewControllers.last!
//                    }
//                }
//            }
//        }
         if viewcontroller.isKind(of: UINavigationController.classForCoder()) {
            if let navVC = viewcontroller as? UINavigationController {
                return navVC.viewControllers.last!
            }
        }
        
        return viewcontroller
    }
    
//    func internetGoesToOfflineOnline() {
//        // If Internet Connection appear to offline.......
//        let noInternetView = NoInternetView.viewFromXib as? NoInternetView
//        noInternetView?.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
//        
//        let net = NetworkReachabilityManager()
//        net?.startListening()
//        
//        net?.listener = { status in
//            if (net?.isReachable)! {
//                print("NETWORK REACHABLE")
//                noInternetView?.removeFromSuperview()
//                
//                if MIMQTT.shared().objMQTTClient != nil {
//                    MIMQTT.shared().objMQTTClient?.connect()
//                }
//            }else {
//                print("NETWORK UNREACHABLE")
//                noInternetView?.removeFromSuperview()
//                appDelegate.window.addSubview(noInternetView!)
//            }
//        }
//    }
}
