//
//  TournamentSearchTblCell.swift
//  XPTournament
//
//  Created by Mind-00011 on 16/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TournamentSearchTblCell: UITableViewCell {

    @IBOutlet weak var imgVTournament : UIImageView!
    @IBOutlet weak var lblTournamentName : UILabel!
    @IBOutlet weak var lblTournamentType : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblEntryFeeTxt : UILabel!
    @IBOutlet weak var lblEntryFee : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var imgVUser1 : UIImageView!
    @IBOutlet weak var imgVUser2 : UIImageView!
    @IBOutlet weak var imgVUser3 : UIImageView!
    @IBOutlet weak var btnCount : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        GCDMainThread.async {
            self.imgVUser1.layer.cornerRadius = self.imgVUser1.frame.height/2
            self.imgVUser2.layer.cornerRadius = self.imgVUser2.frame.height/2
            self.imgVUser3.layer.cornerRadius = self.imgVUser3.frame.height/2
        }
        
    }
    
    func setTournamentDetail(tournamentInfo: TournamentDetailModel) {
        
        imgVTournament.loadImageFromUrl(tournamentInfo.image, isPlaceHolderUser: false)
        lblTournamentName.text = tournamentInfo.title
        lblTournamentType.text = tournamentInfo.tournamentType == CSwissType ? CSwissTournamentType : CEliminationTournamentType
        lblStatus.text = tournamentInfo.tournamentStatus
        lblEntryFee.text = tournamentInfo.entryType == CPaidEntry ? "$\(tournamentInfo.entryFees ?? 0)" : CFree
        
        let playerCount = tournamentInfo.registeredPlayers ?? 0
        btnCount.setTitle(playerCount >= 100 ? "99+" : "\(playerCount)", for: .normal)
        btnCount.isHidden = Int(playerCount) <= 3
        
        lblDate.text =  DateFormatter.dateStringFrom(timestamp: tournamentInfo.startDate, withFormate: "dd MMM, yyyy")
        lblTime.text = DateFormatter.dateStringFrom(timestamp: tournamentInfo.startDate, withFormate: "hh:mm a")
        
        imgVUser1.isHidden = true
        imgVUser2.isHidden = true
        imgVUser3.isHidden = true
        
        //...For First User Image
        if tournamentInfo.usersImages?.count ?? 0 > 0 {
            if let user1 = tournamentInfo.usersImages?[0] {
                imgVUser1.isHidden = false
                imgVUser1.loadImageFromUrl(user1.valueForString(key: "image"), isPlaceHolderUser: true)
            }
        }
        //...For Second User Image
        if tournamentInfo.usersImages?.count ?? 0 > 1 {
            if let user2 = tournamentInfo.usersImages?[1] {
                imgVUser2.isHidden = false
                imgVUser2.loadImageFromUrl(user2.valueForString(key: "image"), isPlaceHolderUser: true)
            }
        }
        //...For Third User Image
        if tournamentInfo.usersImages?.count ?? 0 > 2 {
            if let user3 = tournamentInfo.usersImages?[2] {
                imgVUser3.isHidden = false
                imgVUser3.loadImageFromUrl(user3.valueForString(key: "image"), isPlaceHolderUser: true)
            }
        }
        
        switch (tournamentInfo.tournamentStatus) {
        case CLive:
            lblStatus.backgroundColor = CRGBA(r: 47, g: 92, b: 238, a: 0.90)
            break
        case CUpcoming:
            lblStatus.backgroundColor = CRGBA(r: 228, g: 35, b: 132, a: 0.90)
            break
        case CCompleted:
            lblStatus.backgroundColor = CRGBA(r: 32, g: 32, b: 32, a: 0.90)
            break
        default:
            break
        }
    }
}

