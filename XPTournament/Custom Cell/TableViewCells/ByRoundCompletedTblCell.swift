//
//  ByRoundCompletedTblCell.swift
//  XPTournament
//
//  Created by mac-00011 on 16/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import UIKit

enum cellTypeForByRound {
    case fromScoreCard
    case fromTournamentDetail
}

class ByRoundCompletedTblCell: UITableViewCell {
    
    //MARK:- UI Outlets
    //MARK:-
    
    @IBOutlet weak var imgVPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: MIGenericLabel!
    @IBOutlet weak var lblSos: MIGenericLabel!
    @IBOutlet weak var lblRating: MIGenericLabel!
    @IBOutlet weak var btnWinLost: MIGenericButton!
    @IBOutlet weak var lblTable: MIGenericLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
            self.btnWinLost.layer.cornerRadius = self.btnWinLost.frame.height/2
            self.btnWinLost.layer.borderWidth = 1
            self.btnWinLost.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.imgVPlayer.layer.cornerRadius = self.imgVPlayer.frame.height/2
        }
    }

    func cellConfigureByRoundCompleted(roundInfo: Any, cellType: cellTypeForByRound) {
       
        switch cellType {
            
        // For Score Card round Details
        case .fromScoreCard:
            if let scoreCardInfo = roundInfo as? ScoreCardListDetailModel {
                lblTable.text = "\(CTable) \(scoreCardInfo.table_no ?? 0)"
                if scoreCardInfo.user_id_one == 1 {
                    imgVPlayer.loadImageFromUrl(scoreCardInfo.image_two, isPlaceHolderUser: true)
                    lblPlayerName.text = scoreCardInfo.full_name_two
                    lblSos.text = "\(scoreCardInfo.sos_two ?? 0)"
                    lblRating.text = "\(scoreCardInfo.rating_two ?? 0)"
                } else {
                    imgVPlayer.loadImageFromUrl(scoreCardInfo.image_one, isPlaceHolderUser: true)
                    lblPlayerName.text = scoreCardInfo.full_name_one
                    lblSos.text = "\(scoreCardInfo.sos_one ?? 0)"
                    lblRating.text = "\(scoreCardInfo.rating_one ?? 0)"
                }
            }
        
        // For Completed Round Details
        case .fromTournamentDetail:
            if let myTournamentInfo = roundInfo as? RoundDetailModel {
                lblTable.text = "\(CTable) \(myTournamentInfo.table_no ?? 0)"
                if myTournamentInfo.user_id_one == 1 {
                    imgVPlayer.loadImageFromUrl(myTournamentInfo.image_two, isPlaceHolderUser: true)
                    lblPlayerName.text = myTournamentInfo.full_name_two
                    lblSos.text = "\(myTournamentInfo.sos_two ?? 0)"
                    lblRating.text = "\(myTournamentInfo.rating_two ?? 0)"
                } else {
                    imgVPlayer.loadImageFromUrl(myTournamentInfo.image_one, isPlaceHolderUser: true)
                    lblPlayerName.text = myTournamentInfo.full_name_one
                    lblSos.text = "\(myTournamentInfo.sos_one ?? 0)"
                    lblRating.text = "\(myTournamentInfo.rating_one ?? 0)"
                }
            }
        }
    }
}
