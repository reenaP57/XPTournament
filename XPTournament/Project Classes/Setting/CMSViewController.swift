//
//  CMSViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import WebKit

class CMSViewController: ParentViewController, CMSDelegate {
    
    enum CMSType {
        case aboutUs
        case termsAndConditions
        case privacyPolicy
        case contactUs
    }
    
    var webView: WKWebView!
    var cmsType = CMSType.aboutUs
    
    var cmsViewModel = CMSViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initailize() {
        
        cmsViewModel.cmsDelegate = self
        webView = WKWebView()
        self.view.addSubview(webView , marginInsets: .init(top: 0, left: (CScreenWidth * 15)/375, bottom: 0, right: 0))
        
        
        switch cmsType {
        case .aboutUs:
            self.title = CAboutUs
            cmsViewModel.loadCMSData(cmsType: "about-us")
        case .termsAndConditions:
            self.title = CTermsAndConditions
            cmsViewModel.loadCMSData(cmsType: "terms-and-conditions")
        case .privacyPolicy:
            self.title = CPrivacyPolicy
            cmsViewModel.loadCMSData(cmsType: "privacy-policy")
        default:
            self.title = CContactUs
        }
        
    }
    
    func cmsDetail(_ cmsInfo: CMSModel?) {
        
        if cmsInfo != nil {
            webView.loadHTMLString((cmsInfo?.description)!, baseURL: nil)
            webView.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }
    
}
