//
//  TournamentViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/01/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper


typealias tournamentSuccessCompletion = (() -> ())?

class TournamentViewModel {
    
    var arrOpenTournamentList = [TournamentDetailModel]()
    var arrRunningTournamentList = [TournamentDetailModel]()
    var arrMyTournamentList = [TournamentDetailModel]()
    var arrSection = [String]()
    var refreshControl = UIRefreshControl()
    var apiTask: URLSessionTask?
}

extension TournamentViewModel {
    
    //Home
    func getHomeList(isShowLoader: Bool?, isRefresh: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getHomeList(isShowLoader: isShowLoader, completion: { (response, error) in
            self.refreshControl.endRefreshing()
            if (response != nil && error == nil) {

                if isRefresh! {
                    self.arrRunningTournamentList.removeAll()
                    self.arrMyTournamentList.removeAll()
                    self.arrOpenTournamentList.removeAll()
                    self.arrSection.removeAll()
                }
                
                if let responseDic = response as? TournamentModel {
                    
                    //...Check here data is available and add here
                    if responseDic.myTournament?.count ?? 0 > 0 {
                        self.arrMyTournamentList.removeAll()
                        self.arrMyTournamentList = (responseDic.myTournament)!
                        self.arrSection.append(CMyTournament)
                    }
                    if responseDic.openRegistration?.count ?? 0 > 0 {
                        self.arrOpenTournamentList.removeAll()
                        self.arrOpenTournamentList = (responseDic.openRegistration)!
                        self.arrSection.append(COpenForRegistration)
                    }
                    if responseDic.currentlyRunning?.count ?? 0 > 0 {
                        self.arrRunningTournamentList.removeAll()
                        self.arrRunningTournamentList = (responseDic.currentlyRunning)!
                        self.arrSection.append(CCurrentlyRunning)
                    }
                }
                
                successCompletion?()
            }
        })
    }
    
    

    
    //Rate Your Experience
    func rateExperience(tournamentID: Int?, playingRate: Double?, recommPlayingRate: Double?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().rateYourExperience(tournamentId: tournamentID, playingRating: playingRate, recommPlayingRating: recommPlayingRate, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let responseDic = response as? [String: Any] {
                    if let meta = responseDic.valueForJSON(key: CJsonMeta) as? [String: Any] {
                        successCompletion?(nil, meta.valueForInt(key: CJsonStatus), meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        })
    }
}
