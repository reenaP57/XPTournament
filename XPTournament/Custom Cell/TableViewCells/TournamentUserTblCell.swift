//
//  TournamentUserTblCell.swift
//  XPTournament
//
//  Created by Mind-00011 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TournamentUserTblCell: UITableViewCell {

    @IBOutlet weak var imgVUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: MIGenericLabel!
    @IBOutlet weak var lblSOS: MIGenericLabel!
    @IBOutlet weak var lblRating: MIGenericLabel!

    @IBOutlet weak var btnView: MIGenericButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgVUserProfile.layer.cornerRadius = self.imgVUserProfile.CViewHeight/2
            self.imgVUserProfile.layer.masksToBounds = true
        }
    }
    
    func setTournamentUserDetail(userInfo: TournamentAllUserDetailModel?) {
        
        imgVUserProfile.loadImageFromUrl(userInfo?.image, isPlaceHolderUser: true)
        lblUserName.text = userInfo?.fullName
        lblSOS.text = "\(userInfo?.sos ?? 0)"
        lblRating.text = "\(userInfo?.rating ?? 0)"
    }

}
