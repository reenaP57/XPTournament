//  MIGenericButton.swift
//  XPTournament
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


import Foundation
import UIKit

class MIGenericButton: UIButton
{
    
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
        self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: round(CScreenWidth * ((self.titleLabel?.font.pointSize)! / 375)))
        
        switch self.tag {
        case 100: // Button With rounded cornere
            GCDMainThread.async {
                self.layer.cornerRadius = self.frame.height/2
                self.layer.masksToBounds = true
            }
        case 101: // Button With rounded cornere
            GCDMainThread.async {
                self.layer.cornerRadius = self.frame.height/2
                self.layer.borderWidth = 1
                self.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
              //  self.layer.masksToBounds = true
                self.shadow(color: ColorShadow, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 10, shadowOpacity: 10)

            }
        default:
            break
        }
        
        
    }
    
}
