//
//  ConnectionAlertView.swift
//  XPTournament
//
//  Created by mac-00011 on 04/04/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import UIKit

class ConnectionAlertView: UIView {
    
    @IBOutlet weak var lblMessage: MIGenericLabel!
    @IBOutlet weak var viewConnectionAlert: UIView!
    
    class func initConnectionAlertView() -> UIView {
        if let objConnectionAlertView: ConnectionAlertView = Bundle.main.loadNibNamed("ConnectionAlertView", owner: nil, options: nil)?.last as? ConnectionAlertView {
            objConnectionAlertView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: objConnectionAlertView.viewConnectionAlert.frame.height)
            objConnectionAlertView.layoutIfNeeded()
            return objConnectionAlertView
        }
        return UIView()
    }
}
