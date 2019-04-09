//
//  MIGenericView.swift
//  XPTournament
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericView: UIView {

    @IBInspectable var cornerRaduis : CGFloat = 0.0
    @IBInspectable var shadowColor : UIColor = UIColor.white

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
      
        GCDMainThread.async {
            if self.tag == 100 {
                
                ///... A View that will in CornerRadius shape.
                self.layer.cornerRadius = self.cornerRaduis
                
            } else if self.tag == 101 {
                
                ///... A View that will in CornerRadius shape AND in shadow shape.
                self.shadow(color: ColorShadow, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 10, shadowOpacity: 10)
                self.layer.cornerRadius = self.cornerRaduis

            } else if self.tag == 102 {
                
                //...A View that will in Shadow (For Home screen)
                self.shadow(color: CRGBA(r: 0, g: 0, b: 0, a: 0.5), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 5, shadowOpacity: 0.5)
                self.layer.cornerRadius = self.cornerRaduis
            
            } else if self.tag == 103 {
                
                //...A View that will in CornerRadius shape.
                self.layer.cornerRadius = self.CViewHeight/2
            
            } else if self.tag == 104 {
                
                //...A View that will in CornerRadius shape With Shadow (For Bracket screen).
                self.shadow(color: self.shadowColor, shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 10, shadowOpacity: 10)
                self.layer.cornerRadius = self.cornerRaduis
            }
        }
    }
}
