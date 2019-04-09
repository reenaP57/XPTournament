//
//  MyMatchRoundCompletedTblCell.swift
//  XPTournament
//
//  Created by mac-0005 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum cellType {
    case FromScoreCard
    case FromUpcomingMatches
    case FromMyTournamentDetail
    case FromCurrentlyRunningTournamentDetail
}

class MyMatchRoundCompletedTblCell: UITableViewCell {
    
    @IBOutlet var lblNamePlayerFirst : UILabel!
    @IBOutlet var lblNamePlayerSecond : UILabel!
    @IBOutlet var lblSOSFirst : UILabel!
    @IBOutlet var lblSOSSecond : UILabel!
    @IBOutlet var lblRatingFirst : UILabel!
    @IBOutlet var lblRatingSecond : UILabel!
    @IBOutlet var imgPlayerFirst : UIImageView!
    @IBOutlet var btnWinLostFirst : UIButton!
    @IBOutlet var imgPlayerSecond : UIImageView!
    @IBOutlet var btnWinLostSecond : UIButton!
    @IBOutlet var lblTimer : UILabel!
    @IBOutlet var lblVS : UILabel!
    @IBOutlet weak var lblTable: MIGenericLabel!
    
    var cellType: cellType?
    var cellRoundInformation: RoundDetailModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.btnWinLostFirst.layer.cornerRadius = self.btnWinLostFirst.frame.height/2
            self.btnWinLostFirst.layer.borderWidth = 1
            self.btnWinLostFirst.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.btnWinLostSecond.layer.cornerRadius = self.btnWinLostSecond.frame.height/2
            self.btnWinLostSecond.layer.borderWidth = 1
            self.btnWinLostSecond.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.lblVS.layer.borderWidth = 1
            self.lblVS.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.imgPlayerFirst.layer.cornerRadius = self.imgPlayerFirst.frame.height/2
            self.imgPlayerSecond.layer.cornerRadius = self.imgPlayerSecond.frame.height/2
        }
        
    }
}

// MARK:- --- Configuration
// MARK:-
extension MyMatchRoundCompletedTblCell {
    func cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: Any, cellType: cellType) {
        
        switch cellType {
            
        case .FromUpcomingMatches:
            if let upcomingMatchInfo = matchInfo as? UpcomingMatchesDetailModel {
                
                lblTable.text = "\(CTable) \(upcomingMatchInfo.table_no ?? 0)"
                lblNamePlayerFirst.text = upcomingMatchInfo.full_name_one
                lblNamePlayerSecond.text = upcomingMatchInfo.full_name_two
                lblSOSFirst.text = "\(upcomingMatchInfo.sos_one ?? 0)"
                lblSOSSecond.text = "\(upcomingMatchInfo.sos_two ?? 0)"
                lblRatingFirst.text = "\(upcomingMatchInfo.rating_two ?? 0)"
                lblRatingSecond.text = "\(upcomingMatchInfo.rating_two ?? 0)"
                imgPlayerFirst.loadImageFromUrl(upcomingMatchInfo.image_one, isPlaceHolderUser: true)
                imgPlayerSecond.loadImageFromUrl(upcomingMatchInfo.image_two, isPlaceHolderUser: true)
            }
            
            //...Hide Win-Lost Button
            btnWinLostFirst.isHidden = true
            _ = btnWinLostFirst.setConstraintConstant(-(btnWinLostFirst.frame.height+5), edge: .top, ancestor: true)
            btnWinLostSecond.isHidden = true
            _ = btnWinLostSecond.setConstraintConstant(-(btnWinLostSecond.frame.height+5), edge: .top, ancestor: true)
            lblTimer.isHidden = true
            
        case .FromScoreCard:
            
            lblTimer.isHidden = true
            if let scoreCardInfo = matchInfo as? ScoreCardListDetailModel {
                lblTable.text = "\(CTable) \(scoreCardInfo.table_no ?? 0)"
                lblNamePlayerFirst.text = scoreCardInfo.full_name_one
                lblNamePlayerSecond.text = scoreCardInfo.full_name_two
                lblSOSFirst.text = "\(scoreCardInfo.sos_one ?? 0)"
                lblSOSSecond.text = "\(scoreCardInfo.sos_two ?? 0)"
                lblRatingFirst.text = "\(scoreCardInfo.rating_two ?? 0)"
                lblRatingSecond.text = "\(scoreCardInfo.rating_two ?? 0)"
                imgPlayerFirst.loadImageFromUrl(scoreCardInfo.image_one, isPlaceHolderUser: true)
                imgPlayerSecond.loadImageFromUrl(scoreCardInfo.image_two, isPlaceHolderUser: true)
                
                self.setUserWinLostStatus(userFirstStatus: scoreCardInfo.user_id_one_status, userSecondStatus: scoreCardInfo.user_id_two_status, userFirstID: scoreCardInfo.user_id_one ?? 0, userSecondID: scoreCardInfo.user_id_two ?? 0)
            }
        case .FromMyTournamentDetail:
            if let completedRoundInfo = matchInfo as? RoundDetailModel {
                
                lblTable.text = "\(CTable) \(completedRoundInfo.table_no ?? 0)"
                lblNamePlayerFirst.text = completedRoundInfo.full_name_one
                lblNamePlayerSecond.text = completedRoundInfo.full_name_two
                lblSOSFirst.text = "\(completedRoundInfo.sos_one ?? 0)"
                lblSOSSecond.text = "\(completedRoundInfo.sos_two ?? 0)"
                lblRatingFirst.text = "\(completedRoundInfo.rating_two ?? 0)"
                lblRatingSecond.text = "\(completedRoundInfo.rating_two ?? 0)"
                imgPlayerFirst.loadImageFromUrl(completedRoundInfo.image_one, isPlaceHolderUser: true)
                imgPlayerSecond.loadImageFromUrl(completedRoundInfo.image_two, isPlaceHolderUser: true)
                
                self.setUserWinLostStatus(userFirstStatus: completedRoundInfo.user_id_one_status, userSecondStatus: completedRoundInfo.user_id_two_status, userFirstID: completedRoundInfo.user_id_one ?? 0, userSecondID: completedRoundInfo.user_id_two ?? 0)
            }
            
        case .FromCurrentlyRunningTournamentDetail:
            if let runningRoundInfo = matchInfo as? RoundDetailModel {
                cellRoundInformation = runningRoundInfo
                lblTable.text = "\(CTable) \(runningRoundInfo.table_no ?? 0)"
                lblNamePlayerFirst.text = runningRoundInfo.full_name_one
                lblNamePlayerSecond.text = runningRoundInfo.full_name_two
                lblSOSFirst.text = "\(runningRoundInfo.sos_one ?? 0)"
                lblSOSSecond.text = "\(runningRoundInfo.sos_two ?? 0)"
                lblRatingFirst.text = "\(runningRoundInfo.rating_two ?? 0)"
                lblRatingSecond.text = "\(runningRoundInfo.rating_two ?? 0)"
                imgPlayerFirst.loadImageFromUrl(runningRoundInfo.image_one, isPlaceHolderUser: true)
                imgPlayerSecond.loadImageFromUrl(runningRoundInfo.image_two, isPlaceHolderUser: true)
                
                
                // Show or Hide Timer when based on Live or Completed
                if runningRoundInfo.user_id_one_status == CNA && runningRoundInfo.user_id_two_status == CNA {
                    lblTimer.isHidden = false
                    lblTimer.text = runningRoundInfo.timeToShow
                    btnWinLostFirst.isHidden = true
                    _ = btnWinLostFirst.setConstraintConstant(-(btnWinLostFirst.frame.height), edge: .top, ancestor: true)
                    btnWinLostSecond.isHidden = true
                    _ = btnWinLostSecond.setConstraintConstant(-(btnWinLostSecond.frame.height), edge: .top, ancestor: true)
                    
                }else {
                    lblTimer.isHidden = true
                    btnWinLostFirst.isHidden = false
                    _ = btnWinLostFirst.setConstraintConstant(14, edge: .top, ancestor: true)
                    btnWinLostSecond.isHidden = false
                    _ = btnWinLostSecond.setConstraintConstant(14, edge: .top, ancestor: true)
                    
                    self.setUserWinLostStatus(userFirstStatus: runningRoundInfo.user_id_one_status, userSecondStatus: runningRoundInfo.user_id_two_status, userFirstID: runningRoundInfo.user_id_one ?? 0, userSecondID: runningRoundInfo.user_id_two ?? 0)
                }
            }
        }
    }
    
    func setUserWinLostStatus(userFirstStatus: String?, userSecondStatus: String?, userFirstID: Int, userSecondID: Int) {
        
        let loginUserID = Int(appDelegate.loginUser?.id ?? 0)
        
        // If both user result status is Win
        if (userFirstStatus == CWinMatchStatus && userSecondStatus == CWinMatchStatus)  {
            
            // When First User is Login User or not
            if loginUserID == userFirstID {
                // First user win
                self.setWinLostTieButton(1)
            }else {
                // Second user win
                self.setWinLostTieButton(2)
            }
          // If Both user result status is Lost or not
        } else if (userFirstStatus == CLostMatchStatus && userSecondStatus == CLostMatchStatus) {
            // when first user is login User
            if loginUserID == userFirstID {
                // First user lost
                self.setWinLostTieButton(2)
            }else {
                // Secong user lost
                self.setWinLostTieButton(1)
            }
        }else if (userFirstStatus == CWinMatchStatus && userSecondStatus == CLostMatchStatus) || (userFirstStatus == CWinMatchStatus && userSecondStatus == CNA) || (userFirstStatus == CNA && userSecondStatus == CLostMatchStatus) {
            /*
                - If first user result status Win & second user result status Lost
                - If first user result status Win & second user result status NA
                - If first user result status NA & second user result status Lost
             
                // In above all cases First User Win
             */
            self.setWinLostTieButton(1)
            
        }else if (userSecondStatus == CWinMatchStatus && userFirstStatus == CLostMatchStatus) || (userSecondStatus == CWinMatchStatus && userFirstStatus == CNA) || (userSecondStatus == CNA && userFirstStatus == CLostMatchStatus) {
            /*
                - If second user result status Win & first user result status Lost
                - If second user result status Win & second user result status NA
                - If second user result status NA & first user result status Win
             
                // In above all cases Second User Win
             */
            self.setWinLostTieButton(2)
            
            // if Any user result status Tie
        }else if userFirstStatus == CTieMatchStatus || userSecondStatus == CTieMatchStatus {
            
            if (userFirstStatus == CTieMatchStatus && userSecondStatus == CTieMatchStatus) || (userFirstStatus == CTieMatchStatus && userSecondStatus == CNA) || (userFirstStatus == CNA && userSecondStatus == CTieMatchStatus) || (loginUserID == userFirstID && userFirstStatus == CTieMatchStatus) || (loginUserID == userSecondID && userSecondStatus == CTieMatchStatus) {
                
                /*
                    - If both user result status Tie
                    - If first user result status Tie & second user result status NA
                    - If first user result status NA & second user result status Tie
                    - If login user is First User and its result status is Tie
                    - If login user is Second User and its result status is Tie
                 
                    // In above all cases Tournament is Tie(Show both side Tie)
                 */
                
                self.setWinLostTieButton(3)
            }else {
                if (loginUserID == userFirstID && userFirstStatus == CWinMatchStatus) || (loginUserID == userSecondID && userSecondStatus == CLostMatchStatus) {
                    
                    /*
                        - If login User is First User and its status is Win
                        - If login user is Second user and its status is Lost
                     
                        // for above both cases First User Win
                     */
                    self.setWinLostTieButton(1)
                    
                }else if (loginUserID == userFirstID && userFirstStatus == CLostMatchStatus) || (loginUserID == userSecondID && userSecondStatus == CWinMatchStatus) {
                    
                    /*
                     - If login User is First User and its status is Lost
                     - If login user is Second user and its status is Win
                     
                     // for above both cases Second User Win
                     */
                    
                    self.setWinLostTieButton(2)
                }
                
            }
        } else {
            // Tie match
            self.setWinLostTieButton(3)
        }
    }
    
    fileprivate func setWinLostTieButton(_ status: Int) {
        switch status {
        case 1:
            // First Win
            btnWinLostFirst.setImage(UIImage(named: "ic_win"), for: .normal)
            btnWinLostFirst.setTitle(CWinTitle, for: .normal)
            btnWinLostSecond.setImage(UIImage(named: "ic_lose"), for: .normal)
            btnWinLostSecond.setTitle(CLostTitle, for: .normal)
        case 2:
            // second Win
            btnWinLostFirst.setImage(UIImage(named: "ic_lose"), for: .normal)
            btnWinLostFirst.setTitle(CLostTitle, for: .normal)
            btnWinLostSecond.setImage(UIImage(named: "ic_win"), for: .normal)
            btnWinLostSecond.setTitle(CWinTitle, for: .normal)
        default:
            // Tie match
            btnWinLostFirst.setImage(UIImage(named: "ic_tie"), for: .normal)
            btnWinLostFirst.setTitle(CTieTitle, for: .normal)
            btnWinLostSecond.setImage(UIImage(named: "ic_tie"), for: .normal)
            btnWinLostSecond.setTitle(CTieTitle, for: .normal)
        }
    }
}


