//
//  CustomAlertView.swift
//  Netrealty
//
//  Created by mac-0003 on 01/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

enum AlertType: Int {
    case alertView
    case confirmationView
}

class CustomAlertView: UIView {
    
    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var btnOk : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var btnAlertOk : UIButton!
    @IBOutlet weak var vwLine : UIView!
    
    class func initAlertView() -> CustomAlertView {
        let alertView : CustomAlertView = Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)?.last as! CustomAlertView
        alertView.frame = CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: CScreenHeight)
        alertView.layoutIfNeeded()
        return alertView
    }
    
    func showAlert(_ message : String?, okTitle: String?, cancleTitle: String?, type : AlertType, completion: ((Bool) -> Void)?) {
        
        if type == .alertView {
          self.btnAlertOk.isHidden = false
        }
        
        self.lblMsg.text = message
    }
}



