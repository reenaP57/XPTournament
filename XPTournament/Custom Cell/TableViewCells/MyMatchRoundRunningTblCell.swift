//
//  MyMatchRoundRunningTblCell.swift
//  XPTournament
//
//  Created by mac-0005 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

protocol MyMatchRoundRunningTblCellDelegate: class {
     func matchWinLostTieSelected(resultStatus: TournamentResultStatus)
}

enum TournamentResultStatus : String {
    case winTournament = "W"
    case lostTournament = "L"
    case tieTournament = "T"
}

class MyMatchRoundRunningTblCell: UITableViewCell {
    
    @IBOutlet var viewWinLostTieFirst : UIView!
    @IBOutlet var viewWinLostTieSecond : UIView!
    @IBOutlet var lblNamePlayerFirst : UILabel!
    @IBOutlet var lblNamePlayerSecond : UILabel!
    @IBOutlet var lblSOSFirst : UILabel!
    @IBOutlet var lblSOSSecond : UILabel!
    @IBOutlet var lblRatingFirst : UILabel!
    @IBOutlet var lblRatingSecond : UILabel!
    @IBOutlet var imgPlayerFirst : UIImageView!
    @IBOutlet var btnWinFirst : UIButton!
    @IBOutlet var btnLostFirst : UIButton!
    @IBOutlet var btnTieFirst : UIButton!
    @IBOutlet var imgPlayerSecond : UIImageView!
    @IBOutlet var btnWinSecond : UIButton!
    @IBOutlet var btnLostSecond : UIButton!
    @IBOutlet var btnTieSecond : UIButton!
    @IBOutlet var lblVS : UILabel!
    @IBOutlet var lblTable : UILabel!
    @IBOutlet weak var lblMyMatchTimer: MIGenericLabel!
    
    var cellRoundInformation: RoundDetailModel!
    var myMatchRoundRunningTblCellDelegate : MyMatchRoundRunningTblCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.winLostButtonUI(self.btnWinFirst)
            self.winLostButtonUI(self.btnLostFirst)
            self.winLostButtonUI(self.btnTieFirst)
            self.winLostButtonUI(self.btnWinSecond)
            self.winLostButtonUI(self.btnLostSecond)
            self.winLostButtonUI(self.btnTieSecond)
            
            self.lblVS.layer.borderWidth = 1
            self.lblVS.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.imgPlayerFirst.layer.cornerRadius = self.imgPlayerFirst.frame.height/2
            self.imgPlayerSecond.layer.cornerRadius = self.imgPlayerSecond.frame.height/2
        }
    }
}

// MARK:- Helper Functions
// MARK:-
extension MyMatchRoundRunningTblCell {
    fileprivate func winLostButtonUI(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 1
        button.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
    }
}

// MARK:- Configuration
// MARK:-
extension MyMatchRoundRunningTblCell {
    func cellConfigureMyMatchRoundRunning(roundInfo: RoundDetailModel) {
        
        cellRoundInformation = roundInfo
        
        lblTable.text = "\(CTable) \(roundInfo.table_no ?? 0)"
        lblNamePlayerFirst.text = roundInfo.full_name_one
        lblNamePlayerSecond.text = roundInfo.full_name_two
        lblSOSFirst.text = "\(roundInfo.sos_one ?? 0)"
        lblSOSSecond.text = "\(roundInfo.sos_two ?? 0)"
        lblRatingFirst.text = "\(roundInfo.rating_two ?? 0)"
        lblRatingSecond.text = "\(roundInfo.rating_two ?? 0)"
        imgPlayerFirst.loadImageFromUrl(roundInfo.image_one, isPlaceHolderUser: true)
        imgPlayerSecond.loadImageFromUrl(roundInfo.image_two, isPlaceHolderUser: true)
        lblMyMatchTimer.text = roundInfo.timeToShow
        
        if roundInfo.is_start == CStatusZero {
            btnTieFirst.isUserInteractionEnabled = false
            btnTieFirst.alpha = 0.5
            btnTieSecond.isUserInteractionEnabled = false
            btnTieSecond.alpha = 0.5
            btnWinFirst.isUserInteractionEnabled = false
            btnWinFirst.alpha = 0.5
            btnWinSecond.isUserInteractionEnabled = false
            btnWinSecond.alpha = 0.5
            btnLostFirst.isUserInteractionEnabled = false
            btnLostFirst.alpha = 0.5
            btnLostSecond.isUserInteractionEnabled = false
            btnLostSecond.alpha = 0.5
        } else {
            btnTieFirst.isUserInteractionEnabled = true
            btnTieFirst.alpha = 1
            btnTieSecond.isUserInteractionEnabled = true
            btnTieSecond.alpha = 1
            btnWinFirst.isUserInteractionEnabled = true
            btnWinFirst.alpha = 1
            btnWinSecond.isUserInteractionEnabled = true
            btnWinSecond.alpha = 1
            btnLostFirst.isUserInteractionEnabled = true
            btnLostFirst.alpha = 1
            btnLostSecond.isUserInteractionEnabled = true
            btnLostSecond.alpha = 1
        }
        
        if (Int64(roundInfo.user_id_one ?? 0) == appDelegate.loginUser?.id) {
            viewWinLostTieFirst.isHidden = false
            viewWinLostTieSecond.isHidden = true
        } else {
            viewWinLostTieFirst.isHidden = true
            viewWinLostTieSecond.isHidden = false
        }
       
        self.btnTieFirst.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CTieTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                    self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .tieTournament)
                    }
                }
            })
        }
        
        self.btnTieSecond.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CTieTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                    self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .tieTournament)
                    }
                }
            })
        }
        
        self.btnWinFirst.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CWinTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                        self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .winTournament)
                    }
                }
            })
        }
        
        self.btnWinSecond.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CWinTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                         self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .winTournament)
                    }
                }
            })
        }
        
        self.btnLostFirst.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CLostTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                    self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .lostTournament)
                    }
                }
            })
        }
        
        self.btnLostSecond.touchUpInside { (sender) in
            self.viewController?.showAlertConfirmationView(CLostTheMatch, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (result) in
                if result {
                    if self.myMatchRoundRunningTblCellDelegate != nil {
                        self.myMatchRoundRunningTblCellDelegate.matchWinLostTieSelected(resultStatus: .lostTournament)
                    }
                }
            })
        }
    }
    
}
