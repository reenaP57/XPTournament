//
//  MIGenericTextFiled.swift
//  XPTournament
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit


class MIGenericTextFiled: UITextField {
    
    @IBInspectable var icon : String = ""
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
        self.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * ((self.font?.pointSize)! / 375)))
        GCDMainThread.async {
            self.setTextFieldApperance()
        }
    }
    
    func setTextFieldApperance() {

        switch self.tag {
        case 0: // To add Left image and bottom line.....(Like :- Login/Sign up etc related textfield)
            self.addLeftImageAsLeftView(strImgName: icon, leftPadding: 0)
            let vwLine = UIView(frame: CGRect(x: 0.0, y: self.CViewHeight - 1, width: self.CViewWidth, height: 1))
            vwLine.backgroundColor = ColorGray
            self.addSubview(vwLine)
        case 1: // To add border... (Like :- Verify email screen)
            self.layer.cornerRadius = 3
            self.layer.borderColor = CRGB(r: 235, g: 235, b: 235).cgColor
            self.layer.borderWidth = 1.0
        case 2: // To add bottom line without Left image.....(Like :- Profile)
            let vwLine = UIView(frame: CGRect(x: 0.0, y: self.CViewHeight - 1, width: self.CViewWidth, height: 1))
            vwLine.backgroundColor = ColorGray
            self.addSubview(vwLine)
        case 3: // To add bottom line With Right Image....(Like :- Edit Profile)
            self.addRightImageAsRightView(strImgName: icon, rightPadding: 20)
            self.addLeftImageAsLeftView(strImgName: "", leftPadding: 20)
            let vwLine = UIView(frame: CGRect(x: 0.0, y: self.CViewHeight - 1, width: self.CViewWidth, height: 1))
            vwLine.backgroundColor = ColorGray
            self.addSubview(vwLine)
        default:
            break
        }
        
    }
}
