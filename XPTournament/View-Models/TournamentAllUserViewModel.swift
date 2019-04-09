//
//  TournamentAllUserViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

class TournamentAllUserViewModel {
    //Global Variable
    var arrUserList: [TournamentAllUserDetailModel]?
    var tournamentID: Int?
    var apiTask: URLSessionTask?
}

//MARK:-
//MARK:- API Methods

extension TournamentAllUserViewModel {
    
    //Tournament All User
    func getAllUserOfParticularTournament(tournamentID: Int?, search: String?, isShowLoader: Bool?, isRefresh: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        apiTask = APIRequest.shared().viewAllUser(tournamentID: tournamentID, search: search, isShowLoader: isShowLoader, completion: { (response, error) in
            
            if (response != nil && error == nil) {

                if isRefresh! {
                    self.arrUserList?.removeAll()
                }
                
                if let responseData = response as? TournamentAllUserModel {
                    
                    if let userList = responseData.data {
                        self.arrUserList?.removeAll()
                        self.arrUserList = userList
                    }
                }
                successCompletion?()
            }
        })
    }
}
