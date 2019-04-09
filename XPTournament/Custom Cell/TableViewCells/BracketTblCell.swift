//
//  BracketTblCell.swift
//  XPTournament
//
//  Created by Mac-00016 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class BracketTblCell: UITableViewCell {

    @IBOutlet weak var lblTableName : UILabel!
    @IBOutlet weak var lblMatchStatus : UILabel!
    @IBOutlet weak var lblPlayer1Name : UILabel!
    @IBOutlet weak var lblPlayer1SOS : UILabel!
    @IBOutlet weak var lblPlayer1Rating : UILabel!
    @IBOutlet weak var lblPlayer2Name : UILabel!
    @IBOutlet weak var lblPlayer2SOS : UILabel!
    @IBOutlet weak var lblPlayer2Rating : UILabel!
    @IBOutlet weak var btnWin : UIButton!
    @IBOutlet weak var btnLost : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setRoundInfo(roundInfo: TournamentBracketDetailModel) {
        
        lblTableName.text = "\(CTable) \(roundInfo.table_no ?? 0)"
        lblPlayer1Name.text = roundInfo.full_name_one
        lblPlayer2Name.text = roundInfo.full_name_two
        lblPlayer1SOS.text = "\(roundInfo.sos_one ?? 0)"
        lblPlayer1SOS.text = "\(roundInfo.sos_two  ?? 0)"
        lblPlayer1Rating.text = "\(roundInfo.rating_one ?? 0)"
        lblPlayer2Rating.text = "\(roundInfo.rating_two ?? 0)"

        //TODO:- checked round status and show status text
        if (roundInfo.user_id_one_status == CNA && roundInfo.user_id_two_status == CNA) {
            lblMatchStatus.text = COngoing
            lblMatchStatus.textColor = ColorBlue
            btnWin.isHidden = true
            btnLost.isHidden = true
        } else {
            lblMatchStatus.text = CCompleted
            lblMatchStatus.textColor = CRGB(r: 210, g: 210, b: 210)
            btnWin.isHidden = false
            btnLost.isHidden = false
        }
        
        if roundInfo.user_id_one_status == CWinMatchStatus {
            btnWin.setImage(UIImage(named: "ic_win"), for: .normal)
            btnWin.setTitle(CWinTitle, for: .normal)
            btnLost.setImage(UIImage(named: "ic_lose"), for: .normal)
            btnLost.setTitle(CLostTitle, for: .normal)
            
        } else if roundInfo.user_id_one_status == CLostMatchStatus {
            btnWin.setImage(UIImage(named: "ic_lose"), for: .normal)
            btnWin.setTitle(CLostTitle, for: .normal)
            btnLost.setImage(UIImage(named: "ic_win"), for: .normal)
            btnLost.setTitle(CWinTitle, for: .normal)
            
        } else {
            //Tournament Tie
            btnWin.setImage(UIImage(named: "ic_tie"), for: .normal)
            btnWin.setTitle(CTieTitle, for: .normal)
            btnLost.setImage(UIImage(named: "ic_tie"), for: .normal)
            btnLost.setTitle(CTieTitle, for: .normal)
        }
    }
}
