//
//  TournamentSearchViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

class TournamentSearchViewModel {
    //Global Variable
    var arrTournament = [TournamentDetailModel]()
    var currentPage = 1
    var tournamentType = 1
    var apiTask: URLSessionTask?
}

//MARK:-
//MARK:- API Methods

extension TournamentSearchViewModel {
    
    //Get all tournament List
    func getTournamentList(type: Int?, search: String?, page: Int?, isShowLoader: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        apiTask = APIRequest.shared().getTournamentList(type: type, search: search, page: page, isShowLoader: isShowLoader, completion: { (response, error) in
            
            if (response != nil && error == nil) {
          
                if self.currentPage == 1 {
                    self.arrTournament.removeAll()
                    successCompletion?()
                }
                
                //...Data added here
                if let responseDict = response as? TournamentListModel, let tournamentList = responseDict.data, tournamentList.count > 0 {
                    self.arrTournament = self.arrTournament + tournamentList
                    self.currentPage += 1
                    successCompletion?()
                }
                
            }
        })
    }
}
