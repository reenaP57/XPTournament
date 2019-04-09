//
//  SettingTblCell.swift
//  XPTournament
//
//  Created by Mind-00011 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SettingTblCell: UITableViewCell {

    @IBOutlet weak var imgvSetting: UIImageView!
    @IBOutlet weak var lblSettingTitle: MIGenericLabel!
    @IBOutlet weak var imgCircleArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgCircleArrow.layer.cornerRadius = self.imgCircleArrow.frame.width/2
            self.imgCircleArrow.shadow(color: CRGBA(r: 59, g: 104, b: 252, a: 1), shadowOffset: CGSize(width: 0.0, height: 5.0), shadowRadius: 5, shadowOpacity: 5)
        }
    }

}
