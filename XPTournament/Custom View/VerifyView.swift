//
//  VerifyView.swift
//  XPTournament
//
//  Created by Mind-00011 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class VerifyView: UIView {

    
    @IBOutlet weak var vwAlertVerify: UIView!
    @IBOutlet weak var btnOk: MIGenericButton!
    @IBOutlet weak var lblVerify: MIGenericLabel!
    @IBOutlet weak var imgVLogo: UIImageView!
    
    class func initVerifyView() -> UIView
    {
        let objVerifyView: VerifyView = Bundle.main.loadNibNamed("VerifyView", owner: nil, options: nil)?.last as! VerifyView
        objVerifyView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        objVerifyView.layoutIfNeeded()
        objVerifyView.vwAlertVerify.frame = CGRect(x: 20.0, y: CScreenHeight, width: CScreenWidth - 40, height: objVerifyView.vwAlertVerify.CViewHeight)
        objVerifyView.vwAlertVerify.roundCorners([.topLeft, .topRight], radius: 10)
        return objVerifyView
    }
    
}

//    MARK:-
//    MARK:- Action Events

extension VerifyView {
    
    @IBAction func btnOkClicked(_ sender: MIGenericButton) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.vwAlertVerify.CViewSetY(y: CScreenHeight)
        }, completion: { (completed) in
            self.removeFromSuperview()
        })
    }
}
    

