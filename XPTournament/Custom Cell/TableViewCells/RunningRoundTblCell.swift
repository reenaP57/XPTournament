//
//  RunningRoundTblCell.swift
//  XPTournament
//
//  Created by Mind-00011 on 05/12/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
@objc protocol RunningRoundTblCellDelegate: class {
    @objc optional func tournamentMatchTypeSelected(isLive: Bool, roundIndex: Int)
}


class RunningRoundTblCell: UITableViewCell {

    @IBOutlet weak var lblRoundNumber: MIGenericLabel!
    @IBOutlet weak var viewSegmentController: UIView!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var lblSegmentSelected: UILabel!
    
    var runningRoundTblCellDelegate : RunningRoundTblCellDelegate!
    var rooundNumber = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
            self.viewSegmentController.layer.cornerRadius = self.viewSegmentController.frame.height / 2
            self.viewSegmentController.layer.borderWidth = 1
            self.viewSegmentController.layer.borderColor = CRGB(r: 235, g: 235, b: 235).cgColor
            
            self.lblSegmentSelected.layer.cornerRadius = self.lblSegmentSelected.frame.height / 2
        }
    }
    
}

// MARK:- --------- Configure
// MARK:-
extension RunningRoundTblCell {
    
//    func cellConfigureRunningRound(_ isLive : Bool, _ indexPath : IndexPath) {
    func cellConfigureRunningRound(tournamentInfo: TournamentDetailViewModel) {
        btnLive.isSelected = false
        btnCompleted.isSelected = false
        
        if (tournamentInfo.arrRoundCurrentlyRunningMatches.count - 1 >= tournamentInfo.selectedRoundIndexPath.item) {
            if tournamentInfo.selectedRoundIndexPath.item > tournamentInfo.swissRoundCounts - 1 {
                // It is elimanation Round
                rooundNumber = tournamentInfo.selectedRoundIndexPath.item - (tournamentInfo.swissRoundCounts - 1)
            }else {
                // It is normal Round
                rooundNumber = tournamentInfo.selectedRoundIndexPath.item+1
            }
            
        }
        
        if tournamentInfo.isOtherUserMatchLive {
            btnLive.isSelected = true
            lblSegmentSelected.text = CLive
            
            GCDMainThread.async {
                _ = self.lblSegmentSelected.setConstraintConstant(0, edge: .leading, ancestor: true)
            }
            
        }else {
            btnCompleted.isSelected = true
            lblSegmentSelected.text = CCompleted
            GCDMainThread.async {
                _ = self.lblSegmentSelected.setConstraintConstant(self.lblSegmentSelected.frame.width, edge: .leading, ancestor: true)
            }
        }
        
        // To show currenlty selected Round..
        if tournamentInfo.arrRoundCurrentlyRunningMatches.count > tournamentInfo.selectedRoundIndexPath.item {
            let mainRoundInfo = tournamentInfo.arrRoundCurrentlyRunningMatches[tournamentInfo.selectedRoundIndexPath.item]
            let roundText = tournamentInfo.selectedRoundIndexPath.item > tournamentInfo.swissRoundCounts - 1 ? "\(kElimantionText) \(tournamentInfo.selectedRoundIndexPath.item - (tournamentInfo.swissRoundCounts - 1))" : "\(kRoundText) \(tournamentInfo.selectedRoundIndexPath.item+1)"
            lblRoundNumber.attributedText = tournamentInfo.setAttributedRoundTitleForCompleted(selectedRound: roundText, player: mainRoundInfo.totalPlayers?.toString)
        } else {
            lblRoundNumber.attributedText = tournamentInfo.setAttributedRoundTitleForCompleted(selectedRound: "Round 0", player: "0")
        }

        
    }
}

// MARK:- ------- Action Event
// MARK:-
extension RunningRoundTblCell{
    
    @IBAction func btnSegmentCLK(_ sender : UIButton){
        var leadingSpace : CGFloat = 0.0
        btnLive.isSelected = false
        btnCompleted.isSelected = false
        if sender.tag == 0 {
            btnLive.isSelected = true
            lblSegmentSelected.text = CLive
            leadingSpace = 0.0
        } else {
            btnCompleted.isSelected = true
            lblSegmentSelected.text = CCompleted
            leadingSpace = lblSegmentSelected.frame.width
        }
     
        UIView.animate(withDuration: 0.3, animations: {
            _ = self.lblSegmentSelected.setConstraintConstant(leadingSpace, edge: .leading, ancestor: true)
        }) { (completed) in
            
            if self.runningRoundTblCellDelegate != nil {
                self.runningRoundTblCellDelegate?.tournamentMatchTypeSelected?(isLive: self.btnLive.isSelected, roundIndex: self.rooundNumber)
            }
            
        }
    }
}
