//
//  ParentViewController.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0006. All rights reserved.
//

import UIKit

let CNavTitleFontSize : CGFloat = 25.0

class ParentViewController: UIViewController, UIGestureRecognizerDelegate
{
    //MARK:-
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAppearance()
        MIKeyboardManager.shared.enableKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        setupViewAppearance()
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-
    //MARK:- Navigation Setup
    
    fileprivate func navigationTitleViewHide() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: ""))
    }
    
    fileprivate func navigationTitle(align : NSTextAlignment) -> UILabel {
        let lblNavTitle = UILabel()
        lblNavTitle.text = self.title
        lblNavTitle.textColor = ColorBlack
        lblNavTitle.font = CFontRubik(size: CNavTitleFontSize, type: .bold).setUpAppropriateFont()
        lblNavTitle.textAlignment = align
        lblNavTitle.sizeToFit()
        lblNavTitle.CViewSetWidth(width: lblNavTitle.CViewWidth + 8)
        
        return lblNavTitle
    }
    
    fileprivate func setupViewAppearance() {
        
        //....Generic Navigation Setup
        
        self.navigationController?.navigationBar.tintColor = ColorBlack
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage =  #imageLiteral(resourceName: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_back")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "ic_nav_shadow")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:CFontRubik(size: CNavTitleFontSize, type: .bold).setUpAppropriateFont()!, NSAttributedString.Key.foregroundColor:ColorBlack]
        
        switch self.view.tag {
        case 1:
            // Right Align Title
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navigationTitle(align: .right))
            self.navigationTitleViewHide()
        case 2:
            // Left Align Title
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.navigationTitle(align: .left))
            self.navigationTitleViewHide()
        case 3:
            //Hide Navigation
            self.navigationController?.isNavigationBarHidden = true
        case 4:
            // Transparent with back button like:- Signup screen
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        default:
            print("")
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(self.navigationController!.viewControllers.count > 1) {
            return true
        }
        return false
    }
    
    func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK:-
//MARK:- ----------Action Event
extension ParentViewController {
    @IBAction func btnBackCLK(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
    }
}

