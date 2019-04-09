//
//  TournamentScoreCardViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

class TournamentScoreCardViewModel {
   //Global Variable
    var scoreCardModel : ScoreCardModel?
    
    var tournamentID: Int = 0
    var apiTask: URLSessionTask?
}

//MARK:-
//MARK:- API Methods

extension TournamentScoreCardViewModel {
    
    //Score Card List
    func getScoreCardList(tournamentID: Int?, isShowLoader: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        apiTask = APIRequest.shared().getScoreCardList(tournamentID: tournamentID, isShowLoader: isShowLoader, completion: { (response, error) in
            if (response != nil && error == nil) {
                if let scoreCardListModel = response as? ScoreCardModel {
                    self.scoreCardModel = scoreCardListModel
                    successCompletion?()
                }
            }
        })
    }
}
