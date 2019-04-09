//
//  TournamentBracketViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

class TournamentBracketViewModel {
    
    //Global Variable
    var arrAllRound = [TournamentBracketRoundDetailModel]()
    var arrSelectedRound = [TournamentBracketRoundDetailModel]()
    var tournamentID: Int?
    var totalPlayer: Int?
    var totalRound = 0
    var totalOnGoingRound: Int?
    var totalCompletedRound: Int?
    var isEliminationMatch: Bool?
    var selectedRoundIndexPath = IndexPath(item: 0, section: 0)
    var apiTask: URLSessionTask?
    var url: String?
    var eliminationRoundCounts = 0
    var swissRoundCounts = 0
}

//MARK:- API Related Method
//MARK:-

extension TournamentBracketViewModel {
    
    //Bracket List
    func getTournamentBracketList(tournamentID: Int?, type: Int?, isShowLoader: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        apiTask = APIRequest.shared().getTournamentBracketList(tournamentID: tournamentID, type: type, isShowLoader: isShowLoader, completion: { (response, error) in
            
            if response != nil && error == nil {
                
                self.arrAllRound.removeAll()
                if let responseDic = response as? TournamentBracketModel {
            
                    if let roundList = responseDic.data {
                        self.arrAllRound = roundList
                    }
                    self.totalPlayer = responseDic.totalPlayer
                    self.totalRound = responseDic.totalRound!
                    if let eliminationRoundCount = responseDic.eliminationRoundCounts {
                        self.eliminationRoundCounts = eliminationRoundCount
                    }
                    if let swissRoundCount = responseDic.swissRoundCounts {
                        self.swissRoundCounts = swissRoundCount
                    }
                    
                    self.isEliminationMatch = responseDic.isEliminationMatch
                    self.url = responseDic.url
                }
                successCompletion?()
            }
        })
    }
}

//MARK:- Helper Methods
//MARK:-

extension TournamentBracketViewModel {

    func getLiveRoundTable() {
        
        self.arrSelectedRound.removeAll()
        
        //TODO:- Get Live round info
        arrSelectedRound = self.arrAllRound.filter({ ($0).isCompletedRound == true})
        
        //TODO:- Get completed round Info IF Live round not available
            if let roundInfo = arrSelectedRound.first {
                self.selectedRoundIndexPath = IndexPath(item: roundInfo.round_no!-1, section: 0)
                self.totalOnGoingRound = roundInfo.onGoingCount
                self.totalCompletedRound = roundInfo.completedCount
                
        } else {
            if let roundInfo = arrAllRound.first {
                self.selectedRoundIndexPath  = IndexPath(item: 0, section: 0)
                self.totalOnGoingRound = roundInfo.onGoingCount
                self.totalCompletedRound = roundInfo.completedCount
            }
            
        }
    }
    
    func getParticularRoundTable(round: Int?, isElimantionRound: Bool) {
        //TODO:- Get Match table for particular round
        self.arrSelectedRound.removeAll()
        self.arrSelectedRound = self.arrAllRound.filter({ ($0).round_no == round && ($0).tournamentType == (isElimantionRound ? 2 : 1)})
        
        if (self.arrSelectedRound.count > 0) {
            self.totalOnGoingRound = arrSelectedRound[0].onGoingCount
            self.totalCompletedRound = arrSelectedRound[0].completedCount
        }
    }
    
    func getRoundInfo(_ isUpdated: Bool) {
        arrSelectedRound.removeAll()
        if arrSelectedRound.count == 0 {
            arrSelectedRound = self.arrAllRound.filter({($0).round_no == 1})
            selectedRoundIndexPath  = IndexPath(item: 0, section: 0)
        } else {
            if let roundInfo = arrAllRound.first {
                selectedRoundIndexPath  = IndexPath(item: roundInfo.round_no!-1, section: 0)
            }
        }
    }
}
