//
//  TournamentUpcomingMatchViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

class TournamentUpcomingMatchViewModel {
    //Global Variable
    var apiTask: URLSessionTask?
    var arrUpcomingMatches = [UpcomingMatchesDetailModel]()
}

extension TournamentUpcomingMatchViewModel {
    
    //Upcoming Matches
    func getUpcomingMatches(isShowLoader: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getUpcomingMatches(isShowLoader: isShowLoader, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let responseData = response as? UpcomingMatchesModel {
                    
                    //...data will be add
                    if let arrMatchInfo = responseData.data {
                        self.arrUpcomingMatches.removeAll()
                        self.arrUpcomingMatches = arrMatchInfo
                    }
                    successCompletion?()
                }
            }
        })
    }
}
