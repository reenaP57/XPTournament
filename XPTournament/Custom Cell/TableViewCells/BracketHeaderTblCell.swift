//
//  BracketHeaderTblCell.swift
//  XPTournament
//
//  Created by Mac-00016 on 22/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

@objc protocol BracketSwissEliminationDelegate: class {
    @objc optional func bracketSwissEliminationSelected(_ isEliminationMatch: Bool)
}

class BracketHeaderTblCell: UITableViewCell {

    @IBOutlet weak var lblTotalRound : UILabel!
    @IBOutlet weak var lblTotalPlayer : UILabel!
    @IBOutlet weak var btnSwiss : UIButton!
    @IBOutlet weak var btnElimination : UIButton!
    
    var bracketSwissEliminationDelegate: BracketSwissEliminationDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setBracketInfo(bracketInfo: TournamentBracketViewModel) {
        btnElimination.isUserInteractionEnabled = bracketInfo.isEliminationMatch ?? false
        lblTotalRound.text = "\(bracketInfo.totalRound )"
        lblTotalPlayer.text = "\(bracketInfo.totalPlayer ?? 0)"
        
        //...Action
        self.btnSwiss.touchUpInside { (sender) in
            self.btnElimination.isSelected = false
            self.btnSwiss.isSelected = true
            if self.bracketSwissEliminationDelegate != nil {
                self.bracketSwissEliminationDelegate.bracketSwissEliminationSelected?(false)
            }
        }
        
        self.btnElimination.touchUpInside { (sender) in
            self.btnElimination.isSelected = true
            self.btnSwiss.isSelected = false
            if self.bracketSwissEliminationDelegate != nil {
                self.bracketSwissEliminationDelegate.bracketSwissEliminationSelected?(true)
            }
        }

    }

}
