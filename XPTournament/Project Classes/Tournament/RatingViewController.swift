//
//  RatingViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: ParentViewController {

    @IBOutlet weak var imgVBlur: UIImageView!
    @IBOutlet weak var imgVTournament: UIImageView!
    @IBOutlet weak var lblTournamentType : UILabel!
    @IBOutlet weak var lblTournamentTitle : UILabel!
    @IBOutlet weak var vwPlayingRate : CosmosView!
    @IBOutlet weak var vwRecommPlayingRate : CosmosView!

    var tournamentInfo: TournamentDetailModel?
    var viewModelTournament = TournamentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CRateYourExperience
        
        imgVBlur.loadImageFromUrl(tournamentInfo?.image, isPlaceHolderUser: false)
        imgVTournament.loadImageFromUrl(tournamentInfo?.image, isPlaceHolderUser: false)
        lblTournamentTitle.text = tournamentInfo?.title
        lblTournamentType.text = tournamentInfo?.tournamentType == CSwissType ? CSwissTournamentType : CEliminationTournamentType
        GCDMainThread.async {
            self.imgVTournament.layer.cornerRadius = self.imgVTournament.CViewHeight / 2
        }
    }

}

//MARK:-
//MARK:- Action Events

extension RatingViewController {
    
    // Click on Submit Button
    @IBAction func btnSubmitClicked(_ sender: MIGenericButton) {
        let tournamentID: Int64 = tournamentInfo?.id ?? 0
        viewModelTournament.rateExperience(tournamentID: Int(tournamentID), playingRate: vwPlayingRate.rating, recommPlayingRate: vwRecommPlayingRate.rating, successCompletion: { (response, status, message) in
            
            if message != nil {
                self.navigationController?.popViewController(animated: true)
                self.showAlertView(message, completion: nil)
            }
        })
    }
    
    // Click on Skip Button
    @IBAction func btnSkipClicked(_ sender: MIGenericButton) {
        let tournamentID : Int64 = tournamentInfo?.id ?? 0
        viewModelTournament.rateExperience(tournamentID: Int(tournamentID), playingRate: 0, recommPlayingRate: 0, successCompletion: { (response, status, message) in
             self.navigationController?.popViewController(animated: true)
        })
    }
}
