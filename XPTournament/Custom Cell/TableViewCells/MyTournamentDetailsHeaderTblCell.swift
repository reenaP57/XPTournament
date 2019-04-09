//
//  MyTournamentDetailsHeaderTblCell.swift
//  XPTournament
//
//  Created by mac-0005 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

let CCompletedTournament    = 0
let CLiveMyTournament       = 1
let CLiveOtherTournament    = 2

protocol MyTournamentDetailsHeaderDelegate: class {
    // This is for to manage round time
    func userMovingInNextScreen()
}


class MyTournamentDetailsHeaderTblCell: UITableViewCell {

    @IBOutlet var viewUserWinDetails : UIView!
    @IBOutlet var viewUserWinSaperatorLine : UIView!
    @IBOutlet var btnViewBrackets : UIButton!
    @IBOutlet var btnViewAllPlayers  : UIButton!
    @IBOutlet var imgWinPlayer  : UIImageView!
    @IBOutlet var imgTournamentBanner  : UIImageView!
    @IBOutlet var btnZoomImage  : UIButton!
    @IBOutlet var btnViewRating  : UIButton!
    @IBOutlet var lblTournamentTitle  : UILabel!
    @IBOutlet var lblTournamentType  : UILabel!
    @IBOutlet var lblDesc  : UILabel!
    @IBOutlet var lblDate  : UILabel!
    @IBOutlet var lblTime  : UILabel!
    @IBOutlet var lblDuration  : UILabel!
    @IBOutlet var lblEntryFee  : UILabel!
    @IBOutlet var lblTotalPlayer  : UILabel!
    @IBOutlet var lblLocation  : UILabel!
    @IBOutlet var lblWinPlayerName : UILabel!
    @IBOutlet var lblSOS  : UILabel!
    @IBOutlet var lblRating  : UILabel!
    
    var myTournamentDetailsHeaderDelegate: MyTournamentDetailsHeaderDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.viewUserWinDetails.layer.cornerRadius = 13
            
            self.btnViewBrackets.shadow(color: CRGB(r: 228, g: 35, b: 132), shadowOffset: CGSize(width: 0, height: 4), shadowRadius: 6.0, shadowOpacity: 5.0)
            self.btnViewAllPlayers.shadow(color: CRGB(r: 101, g: 54, b: 233), shadowOffset: CGSize(width: 0, height: 4), shadowRadius: 6.0, shadowOpacity: 5.0)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        GCDMainThread.async {
            self.imgWinPlayer.layer.cornerRadius = self.imgWinPlayer.CViewHeight/2
            self.btnViewBrackets.layer.cornerRadius = self.btnViewBrackets.CViewHeight/2
            self.btnViewAllPlayers.layer.cornerRadius = self.btnViewAllPlayers.CViewHeight/2
        }
    }

    func setTournamentDetail(tournamentInfo: TournamentDetailModel, tournamentStatus: Int) {
    
        imgTournamentBanner.loadImageFromUrl(tournamentInfo.image, isPlaceHolderUser: false)
        lblTournamentTitle.text = tournamentInfo.title
        lblTournamentType.text = tournamentInfo.tournamentType == CSwissType ? CSwissTournamentType : CEliminationTournamentType
        lblDesc.text = tournamentInfo.description
        lblTotalPlayer.text = "\(tournamentInfo.registeredPlayers ?? 0)"
        lblLocation.text = tournamentInfo.venue
        lblDuration.text = "\(tournamentInfo.duration ?? 0) mins"
        lblEntryFee.text = "\(tournamentInfo.entryFees ?? 0)"
        lblDate.text =  DateFormatter.dateStringFrom(timestamp: tournamentInfo.startDate, withFormate: "dd MMM, yyyy")
        lblTime.text = DateFormatter.dateStringFrom(timestamp: tournamentInfo.startDate, withFormate: "hh:mm a")
        
        lblWinPlayerName.text = tournamentInfo.winnerPlayerName
        lblSOS.text = "\(tournamentInfo.winnerPlayerSOS ?? 0)"
        lblRating.text = "\(tournamentInfo.winnerPlayerRating ?? 0)"
        imgWinPlayer.loadImageFromUrl(tournamentInfo.winnerPlayerImage, isPlaceHolderUser: true)
        
        viewUserWinDetails.hide(byHeight: true)
        viewUserWinSaperatorLine.isHidden = false
        switch tournamentStatus {
        case CCompletedTournament:
        //...TournamentCompleted
            viewUserWinDetails.hide(byHeight: false)
            viewUserWinSaperatorLine.isHidden = true
            btnViewAllPlayers.setTitle(CViewAllPlayers, for: .normal)
        case CLiveMyTournament:
        //...LiveMyTournament
            btnViewAllPlayers.setTitle(CViewScoreCard, for: .normal)
            break
        default:
            break
        }
        
        //...Action
        btnZoomImage.touchUpInside { (sender) in
            self.viewController?.zoomGSImageViewer(self.imgTournamentBanner)
        }
        
        btnViewBrackets.touchUpInside { (sender) in
            if self.myTournamentDetailsHeaderDelegate != nil {
                self.myTournamentDetailsHeaderDelegate.userMovingInNextScreen()
            }
            
            if let bracketVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "BracketViewController") as? BracketViewController {
                let tournamentId : Int64 = tournamentInfo.id ?? 0
                bracketVC.viewModelTournamentBracket.tournamentID = Int(tournamentId)
                self.viewController?.navigationController?.pushViewController(bracketVC, animated: true)
            }
        }
        
        btnViewAllPlayers.touchUpInside { (sender) in
            if self.myTournamentDetailsHeaderDelegate != nil {
                self.myTournamentDetailsHeaderDelegate.userMovingInNextScreen()
            }
            
            switch tournamentStatus {
            case CLiveMyTournament:
            //...Live My Tournament
                if let scoreCardVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "ScoreCardViewController") as? ScoreCardViewController {
                    let tournamentId: Int64 = tournamentInfo.id ?? 0
                    scoreCardVC.viewModelScoreCard.tournamentID = Int(tournamentId)
                    self.viewController?.navigationController?.pushViewController(scoreCardVC, animated: true)
                }
         
            case CCompletedTournament, CLiveOtherTournament:
            //...Completed And Other Live Tournament
                if let tournamentUserVc = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "TournamentUserViewController") as? TournamentUserViewController {
                    let tournamentId: Int64 = tournamentInfo.id ?? 0
                    tournamentUserVc.viewModelTournamentUser.tournamentID = Int(tournamentId)
                    self.viewController?.navigationController?.pushViewController(tournamentUserVc, animated: true)
                }
                
            default:
                break
            }
        }
    }
    
}
