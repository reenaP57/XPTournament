//
//  TabbarView.swift
//  XPTournament
//
//  Created by Mac-00016 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TabbarView: UIView {

    @IBOutlet weak var btnHome : UIButton!
    @IBOutlet weak var btnFlag : UIButton!
    @IBOutlet weak var btnNotification : UIButton!
    @IBOutlet weak var btnSetting : UIButton!
    @IBOutlet weak var btnProfile : UIButton!
    @IBOutlet weak var vwLineHome : UIView!

    private static var tabbar : TabbarView? = {
        
        guard let tabbar = TabbarView.viewFromXib as? TabbarView else{
            return nil
        }
        
        return tabbar
    }()
    
    static var shared : TabbarView? {
        return tabbar
    }

}

extension TabbarView {
    
    @IBAction func btnTabClicked (sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnHome.isSelected = false
        btnFlag.isSelected = false
        btnNotification.isSelected = false
        btnSetting.isSelected = false
        btnProfile.isSelected = false
        sender.isSelected = true
        
        var bottomLineLeadingSpace : CGFloat = 0.0
        switch sender.tag {
        case 0:
            bottomLineLeadingSpace = 0.0
        case 1:
            bottomLineLeadingSpace = CScreenWidth - vwLineHome.CViewWidth*4
        case 2:
            bottomLineLeadingSpace = CScreenWidth - vwLineHome.CViewWidth*3
        case 3:
            bottomLineLeadingSpace = CScreenWidth - vwLineHome.CViewWidth*2
        case 4:
            bottomLineLeadingSpace = CScreenWidth - vwLineHome.CViewWidth
        default:
            print("")
        }
        
        UIView.animate(withDuration: 0.3) {
            _ = self.vwLineHome.setConstraintConstant(bottomLineLeadingSpace, edge: .leading, ancestor: true)
        }        
        appDelegate.tabbarViewcontroller?.selectedIndex = sender.tag
    }
}
