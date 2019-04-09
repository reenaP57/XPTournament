//
//  NotificationTblCell.swift
//  XPTournament
//
//  Created by Mac-00016 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class NotificationTblCell: UITableViewCell {

    @IBOutlet weak var imgVPlayer : UIImageView!
    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var vwDot : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgVPlayer.layer.cornerRadius = self.imgVPlayer.CViewHeight/2
            self.imgVPlayer.layer.masksToBounds = true
        }
    }

    func loadNotificationInfo(arrNotificationList: NotificationModel) {
        self.lblMsg.text = arrNotificationList.message
        self.imgVPlayer.loadImageFromUrl(arrNotificationList.image, isPlaceHolderUser: false)
        
        if arrNotificationList.isRead == 1 {
            self.lblMsg.textColor = ColorDarkGray
            self.vwDot.isHidden = true
        } else {
            self.lblMsg.textColor = ColorBlack
            self.vwDot.isHidden = false
        }
        
        lblTime.text = DateFormatter.shared().durationString(duration: "\(arrNotificationList.time ?? 0)")
    }
}
