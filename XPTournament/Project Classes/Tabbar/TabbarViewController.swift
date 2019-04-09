//
//  TabbarViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabbar()
    }

}

extension TabbarViewController {
    
    func setupTabbar() {
        
        self.tabBar.isHidden = true
        
        guard let tabbar = TabbarView.shared else { return }
        tabbar.frame = CGRect(x: 0, y: CScreenHeight - 49.0 - (IS_iPhone_X_Series ? 34.0 : 0.0), width: CScreenWidth, height: 49.0)
        
        tabbar.btnHome.isSelected = true
        tabbar.btnFlag.isSelected = false
        tabbar.btnNotification.isSelected = false
        tabbar.btnSetting.isSelected = false
        tabbar.btnProfile.isSelected = false
        
        appDelegate.tabbarView = tabbar
        appDelegate.tabbarView?.shadow(color: ColorShadow, shadowOffset: CGSize(width: 0, height: -7), shadowRadius:4, shadowOpacity: 2)
        self.view.addSubview(tabbar)
        
        guard let homeVC = CStoryboardTournament.instantiateViewController(withIdentifier: "TournamentViewController") as? TournamentViewController else { return }
        let homeNav = UINavigationController.rootViewController(viewController: homeVC)
        
        guard let upcomingMatchVC = CStoryboardTournament.instantiateViewController(withIdentifier: "UpcomingMatchViewController") as? UpcomingMatchViewController else { return }
        let upcomingMatchNav = UINavigationController.rootViewController(viewController: upcomingMatchVC)
        
        guard let notificationVC = CStoryboardTournament.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController else { return }
        let notificationNav = UINavigationController.rootViewController(viewController: notificationVC)
        
        guard let settingVC = CStoryboardSetting.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
        let settingNav = UINavigationController.rootViewController(viewController: settingVC)
        
        guard let profileVC = CStoryboardSetting.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
        let profileNav = UINavigationController.rootViewController(viewController: profileVC)
        
        
        self.setViewControllers([homeNav, upcomingMatchNav, notificationNav, settingNav, profileNav], animated: true)
    }
}
