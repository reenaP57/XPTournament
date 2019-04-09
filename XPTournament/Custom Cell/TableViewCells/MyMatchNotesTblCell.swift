//
//  MyMatchNotesTblCell.swift
//  XPTournament
//
//  Created by mac-0005 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

let CButtonCornerRadius : CGFloat = 3
let CButtonShadowRadius : CGFloat = 3
let CButtonShadowOpacity: Float = 3

class MyMatchNotesTblCell: UITableViewCell {

    @IBOutlet var imgPlayerFirst : UIImageView!
    @IBOutlet var btnFirstRedTop : UIButton!
    @IBOutlet var btnFirstRedBottom : UIButton!
    @IBOutlet var btnFirstGreenTop : UIButton!
    @IBOutlet var btnFirstGreenBottom : UIButton!
    
    @IBOutlet var imgPlayerSecond : UIImageView!
    @IBOutlet var btnSecondRedTop : UIButton!
    @IBOutlet var btnSecondRedBottom : UIButton!
    @IBOutlet var btnSecondGreenTop : UIButton!
    @IBOutlet var btnSecondGreenBottom : UIButton!
    @IBOutlet weak var lblPointFirstPlayer: MIGenericLabel!
    @IBOutlet weak var lblPointSecondPlayer: MIGenericLabel!
    
    
    @IBOutlet var lblVS: UILabel!
    var roundID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.btnFirstRedTop.layer.cornerRadius = CButtonCornerRadius
            self.btnFirstRedBottom.layer.cornerRadius = CButtonCornerRadius
            self.btnFirstGreenTop.layer.cornerRadius = CButtonCornerRadius
            self.btnFirstGreenBottom.layer.cornerRadius = CButtonCornerRadius
            
            self.btnSecondRedTop.layer.cornerRadius = CButtonCornerRadius
            self.btnSecondRedBottom.layer.cornerRadius = CButtonCornerRadius
            self.btnSecondGreenTop.layer.cornerRadius = CButtonCornerRadius
            self.btnSecondGreenBottom.layer.cornerRadius = CButtonCornerRadius
            
            self.lblVS.layer.borderWidth = 1
            self.lblVS.layer.borderColor = CRGB(r: 233, g: 233, b: 233).cgColor
            
            self.imgPlayerFirst.layer.cornerRadius = self.imgPlayerFirst.frame.height/2
            self.imgPlayerSecond.layer.cornerRadius = self.imgPlayerSecond.frame.height/2
            
            self.btnFirstRedTop.shadow(color: CRGB(r: 236, g: 23, b: 87), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnSecondRedTop.shadow(color: CRGB(r: 236, g: 23, b: 87), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnFirstRedBottom.shadow(color: CRGB(r: 236, g: 23, b: 87), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnSecondRedBottom.shadow(color: CRGB(r: 236, g: 23, b: 87), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnFirstGreenTop.shadow(color: CRGB(r: 11, g: 200, b: 93), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnSecondGreenTop.shadow(color: CRGB(r: 11, g: 200, b: 93), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnFirstGreenBottom.shadow(color: CRGB(r: 11, g: 200, b: 93), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)
            self.btnSecondGreenBottom.shadow(color: CRGB(r: 11, g: 200, b: 93), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: CButtonShadowRadius, shadowOpacity: CButtonShadowOpacity)

        }
        
    }
    
    func setMatchRoundDetail(roundInfo: RoundDetailModel) {
        imgPlayerFirst.loadImageFromUrl(roundInfo.image_one, isPlaceHolderUser: true)
        imgPlayerSecond.loadImageFromUrl(roundInfo.image_two, isPlaceHolderUser: true)
        
        roundID = roundInfo.id ?? 0
        let arrNotes = TblRoundNotes.fetch(predicate: NSPredicate(format: "round_id == %d", roundInfo.id ?? 0))
        if arrNotes?.count ?? 0 > 0 {
            if let roundInfo = arrNotes?.firstObject as? TblRoundNotes {
                lblPointFirstPlayer.text = "\(roundInfo.user_one_score)"
                lblPointSecondPlayer.text = "\(roundInfo.user_two_score)"
            }
        }else {
            lblPointFirstPlayer.text = "0"
            lblPointSecondPlayer.text = "0"
        }
    
        
    }
   
}

// Mark:-
// Mark:- Action Events

extension MyMatchNotesTblCell {
    
    @IBAction func btnRedMinusClicked(_ sender: MIGenericButton) {

        var lblPointFirstText = lblPointFirstPlayer.text?.toInt ?? 0
        var lblPointSecondText = lblPointSecondPlayer.text?.toInt ?? 0
        
        if let roundNotes = TblRoundNotes.findOrCreate(dictionary: ["round_id": roundID]) as? TblRoundNotes {
            
            if sender.tag == 1 || sender.tag == 2 {
                // Click on red button for first player point(If tag = 1 -> Decrement 1 else tag = 2 -> Decrement 5)
                lblPointFirstText = sender.tag == 1 ? lblPointFirstText - 1 : lblPointFirstText - 5
                lblPointFirstPlayer.text = "\(lblPointFirstText)"
                roundNotes.user_one_score = Int16(lblPointFirstText)
                
            } else if sender.tag == 3 || sender.tag == 4 {
                // Click on red button for second player point(If tag = 3 -> Decrement 1 else tag = 4 -> Decrement 5)
                lblPointSecondText = sender.tag == 3 ? lblPointSecondText - 1 : lblPointSecondText - 5
                lblPointSecondPlayer.text = "\(lblPointSecondText)"
                roundNotes.user_two_score = Int16(lblPointSecondText)
            }
             CoreData.saveContext()
        }
    }
    
    @IBAction func btnGreenPlusClicked(_ sender: MIGenericButton) {

        var lblPointFirstText = lblPointFirstPlayer.text?.toInt ?? 0
        var lblPointSecondText = lblPointSecondPlayer.text?.toInt ?? 0

        if let roundNotes = TblRoundNotes.findOrCreate(dictionary: ["round_id": roundID]) as? TblRoundNotes {
            
            if sender.tag == 1 || sender.tag == 2 {
                // Click on green button for first player point(If tag = 1 -> Increment 1 else tag = 2 -> Increment 5)
                lblPointFirstText = sender.tag == 1 ? lblPointFirstText + 1 : lblPointFirstText + 5
                lblPointFirstPlayer.text = "\(lblPointFirstText)"
                roundNotes.user_one_score = Int16(lblPointFirstText)
                
            } else if sender.tag == 3 || sender.tag == 4 {
                // Click on green button for second player point(If tag = 3 -> Increment 1 else tag = 4 -> Increment 5)
                lblPointSecondText = sender.tag == 3 ? lblPointSecondText + 1 : lblPointSecondText + 5
                lblPointSecondPlayer.text = "\(lblPointSecondText)"
                roundNotes.user_two_score = Int16(lblPointSecondText)
            }
            
            CoreData.saveContext()
        }
    }
}
