//
//  GenericTextView.swift
//  XPTournament
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*
 UITextView tag Info
 0 - Default textView
 1 - TextView with Movable Palceholder and Bottom line
 2 - TextView with normal Palceholder (ex. - Message and Comment TextView)
 3 - Description TextView with normal Palceholder (ex. - Message and Comment TextView)
 */

import UIKit


class GenericTextView: UITextView {

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
    }
}
