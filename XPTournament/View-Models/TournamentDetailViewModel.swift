//
//  TournamentDetailViewModel.swift
//  XPTournament
//
//  Created by mac-00010 on 16/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

typealias tournamentDetailSuccessCompletion = (() -> ())?

protocol TournamentDetailViewModelDelegate: class {
    func roundDidUpdateTime(roundInfo: RoundDetailModel)
    func didFinishTournament(_ tournament: [String: Any]?)
    func dropUserFromTournament()
}

enum TournamentStatus: Int {
    case TournamentCompleted = 0
    case LiveMyTournament = 1
    case LiveOtherTournament = 2
}

class TournamentDetailViewModel {
    
    var tournamentStatus: TournamentStatus!
    var tournamentID: Int?
    var tournamentType: Int?
    var isOtherUserMatchLive = true
    var isElimanitaionForOtherUserMatchLive = false
    
    var tournamentInfo: TournamentDetailModel?
    var registerUserModel: RegisterUserModel?
    
    // This Array contain MyLive and MyCompleted Torunament round objects
    var arrRoundMatches = [RoundDetailModel]()
    
    // This Array contain OtherLive Torunament round objects
    var arrRoundCurrentlyRunningMatches = [CurrentlyRunningRoundDetailModel]()
    
    // This Array contain Both MYLive and OtherLive Torunament round objects and this is using for to show data in table view..
    var arrRoundSelected = [RoundDetailModel]()
    
    // This Array contain timer object for all runnig round (Both MyLive and OtherLive)
    var arrRoundTimer = [Timer]()
    
    // This Array contain all running round object which is Constantly updating with timer
    var arrRoundModelForTimer = [RoundDetailModel]()
    
    var tournamentDetailViewModelDelegate: TournamentDetailViewModelDelegate!
    
    var totalRound = 0
    var eliminationRoundCounts = 0
    var swissRoundCounts = 0
    var selectedRoundIndexPath = IndexPath(item: 0, section: 0)
    var apiTask: URLSessionTask?
    var roundNumber = 1
}


//MARK:- API Methods
//MARK:-
extension TournamentDetailViewModel {
    
    //Tournament Detail
    func getTournamentDetail(tournamentID: Int?, isShowLoader: Bool?, successCompletion: tournamentSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        apiTask = APIRequest.shared().getTournamentDetail(tournamentID: tournamentID, isShowLoader: isShowLoader, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                
                // clear all data
                self.stopAllTimer()
                self.arrRoundSelected.removeAll()
                self.arrRoundTimer.removeAll()
                self.arrRoundMatches.removeAll()
                self.arrRoundModelForTimer.removeAll()
                self.arrRoundCurrentlyRunningMatches.removeAll()
                
                if let responseDict = response {
                    self.tournamentInfo = responseDict as? TournamentDetailModel
                }
                successCompletion?()
            }
        })
    }
    
    //Get Completed-Live round of particular Tournament
    func getCompletedAndLiveTournamentRound(tournamentID: Int?, type: Int?, successCompletion: tournamentSuccessCompletion) {
        
        _ = APIRequest.shared().getCompletedAndLiveRoundDetail(tournamentID: tournamentID, type: type, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let responseDict = response {
                    
                    if let completedLiveInfo = responseDict as? CompletedAndLiveRoundModel {
                        
                        if let arrRound = completedLiveInfo.data {
                            self.arrRoundMatches = arrRound
                        }
                        
                        if let eliminationRoundCounts = completedLiveInfo.eliminationRoundCounts {
                            self.totalRound = eliminationRoundCounts
                            self.eliminationRoundCounts = eliminationRoundCounts
                        }
                        
                        if let swissRoundCounts = completedLiveInfo.swissRoundCounts {
                            self.totalRound = self.totalRound + swissRoundCounts
                            self.swissRoundCounts = swissRoundCounts
                        }
                        
                        switch self.tournamentStatus {
                        case .TournamentCompleted?:
                            self.selectedRoundIndexPath  = IndexPath(item: 0, section: 0)
                            self.getCompletedRoundInfo(round: 1, isElimantionRound: false)
                        case .LiveMyTournament?:
                            self.getLiveRoundInfo()
                            
                            // To get all round data in single array.
                            self.getAllRoundOfTournament()
                            
                            // Configure timer for all Round
                            self.configureTimerForRound()
                        default:
                            break
                        }
                       
                    }
                    successCompletion?()
                }
            }
        })
    }
    
    //Get Round Info for Currently Running Other Player Tournament
    func getTournamentRoundForCurrentRunning(tournamentID: Int?, successCompletion: tournamentSuccessCompletion) {
        
        _ = APIRequest.shared().getCompletedAndLiveRoundForCurrentlyRunning(tournamentID: tournamentID, completion: { (response, error) in
            
            if response != nil && error == nil {
                if let runningLiveInfo = response as? CurrentlyRunningDetailModel{
                    
                    self.arrRoundCurrentlyRunningMatches.removeAll()
                    if let roundList = runningLiveInfo.data {
                        self.arrRoundCurrentlyRunningMatches = roundList
                    }
                    
                    if let eliminationRoundCounts = runningLiveInfo.eliminationRoundCounts {
                        self.totalRound = eliminationRoundCounts
                        self.eliminationRoundCounts = eliminationRoundCounts
                    }
                    
                    if let swissRoundCounts = runningLiveInfo.swissRoundCounts {
                        self.totalRound = self.totalRound + swissRoundCounts
                        self.swissRoundCounts = swissRoundCounts
                    }
                    
                    if (self.arrRoundCurrentlyRunningMatches.count - 1 >= self.selectedRoundIndexPath.item) {
                        if self.selectedRoundIndexPath.item > self.swissRoundCounts - 1 {
                            // It is elimanation Round
                            self.roundNumber = self.selectedRoundIndexPath.item - (self.swissRoundCounts - 1)
                        }else {
                            // It is normal Round
                            self.roundNumber = self.selectedRoundIndexPath.item+1
                        }
                        
                    }
                    
                    // Get Other user round data ar initial level...
                    self.getCurrentlyRunningLiveRound(round: self.roundNumber, isLiveMatch: self.isOtherUserMatchLive, isElimantionRound: self.isElimanitaionForOtherUserMatchLive)
                    
                    // To get all round data in single array.
                    self.getAllRoundOfTournament()
                    // Configure timer for all Round
                    self.configureTimerForRound()
                    
                    successCompletion?()
                }
            }
        })
    }
    
    //Registered Tournament
    func registeredTournament(tournamentID: Int?, successCompletion: tournamentSuccessCompletion) {
        
        _ = APIRequest.shared().registerTournament(tournamentID: tournamentID, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let registerModel = response as? RegisterUserModel {
                    self.registerUserModel = registerModel
                    successCompletion?()
                }
            }
        })
    }
    
    //CheckIn Tournament
    func checkedInTournament(tournamentID: Int?, successCompletion: successCompletion) {
        _ = APIRequest.shared().checkInTournament(tournamentID: tournamentID, completion: { (response, error) in
            if (response != nil && error == nil) {
                if let responseDic = response as? [String: AnyObject] {
                    if let meta = responseDic.valueForJSON(key: CJsonMeta) as? [String: AnyObject]{
                        successCompletion?(nil, meta.valueForInt(key: CJsonStatus), meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        })
    }
    
    //Match Win, Loss and Tie status
    func updateMatchStatus(tournamentID: Int?, status: Int?, successCompletion: tournamentSuccessCompletion) {
        
        _ = APIRequest.shared().updateTournamentWinLossTieStatus(tournamentID: tournamentID, status: status, completion: { (response, error) in
            if response != nil && error == nil {
                
            }
        })
    }
}


//MARK:- Round Related Functions
//MARK:-
extension TournamentDetailViewModel {
    
    func getCompletedRoundInfo(round: Int?, isElimantionRound: Bool) {
        //...Get completed round info for particular round
        
        arrRoundSelected.removeAll()
        // NOTE:- isElimantionRound = true => to Get elimation round
        arrRoundSelected = self.arrRoundMatches.filter({($0).round_no == round && ($0).tournament_type == (isElimantionRound ? 2 : 1)})
    }
    
    func getLiveRoundInfo() {
        arrRoundSelected.removeAll()
        
        //Get Live round info
        arrRoundSelected = self.arrRoundMatches.filter({ ($0).user_id_one_status == CNA || ($0).user_id_two_status == CNA})
        
        //Get completed round Info IF Live round not available
        if arrRoundSelected.count == 0 {
            // Pic first round data only ignor elimantion round..
            arrRoundSelected = self.arrRoundMatches.filter({($0).round_no == 1 && ($0).tournament_type != 2})
            selectedRoundIndexPath  = IndexPath(item: 0, section: 0)
        } else {
            let roundInfo = arrRoundSelected.first
            if roundInfo?.tournament_type == 2 {
                // For Eliminaton Round
                selectedRoundIndexPath = IndexPath(item: arrRoundMatches.count - 1, section: 0)
            } else {
                // For normal Round
                selectedRoundIndexPath = IndexPath(item: arrRoundSelected[0].round_no!-1, section: 0)
            }
        }
    }
    
    func getCurrentlyRunningLiveRound(round: Int?, isLiveMatch: Bool, isElimantionRound: Bool) {
        // Get Live round info for currently running
        arrRoundSelected.removeAll()
        
        var arrCur = [CurrentlyRunningRoundDetailModel]()
        
        if isElimantionRound {
            // For get round data for Elimination round
            arrCur = self.arrRoundCurrentlyRunningMatches.filter({$0.round_no == round && $0.tournamentType == 2}) as [CurrentlyRunningRoundDetailModel]
        }else {
            // For get round data for Swiss round
            arrCur = self.arrRoundCurrentlyRunningMatches.filter({$0.round_no == round && $0.tournamentType == 1}) as [CurrentlyRunningRoundDetailModel]
        }
        if arrCur.count > 0 {
            let roundInfo = arrCur.first
            if isLiveMatch {
                // TO GET LIVE ROUND DATA..
                // NOTE:- isElimantionRound = true => to Get elimation round
                arrRoundSelected = roundInfo?.round?.filter({$0.user_id_one_status == CNA && $0.user_id_two_status == CNA && ($0).tournament_type == (isElimantionRound ? 2 : 1)}) ?? []
                
            } else {
                // TO GET COMPLETED ROUND DATA..
                // NOTE:- isElimantionRound = true => to Get elimation round
                arrRoundSelected = roundInfo?.round?.filter({$0.user_id_one_status != CNA && $0.user_id_two_status != CNA && ($0).tournament_type == (isElimantionRound ? 2 : 1)}) ?? []
            }
        }
        
    }
    
    func getAllRoundOfTournament() {
        
        if self.tournamentStatus == .LiveMyTournament {
            //Get My Live round
            arrRoundModelForTimer = self.arrRoundMatches.filter({ (($0).user_id_one_status == CNA && ($0).user_id_two_status == CNA) || ($0).is_editable == 1})
        
        } else {
            //Get Other Live round
            for roundInfo in self.arrRoundCurrentlyRunningMatches {
                let arrRound = roundInfo.round?.filter({$0.user_id_one_status == CNA && $0.user_id_two_status == CNA}) ?? []
                arrRoundModelForTimer = arrRound + arrRoundModelForTimer
            }
        }
    }
    
    // Update main array localy to get updated data.
    func updateRoundInformationInMainArray(_ roundInfo: RoundDetailModel) {
        if self.tournamentStatus == .LiveMyTournament {
            // Need to update my live data
            if let index = arrRoundMatches.index(where: {$0.id == roundInfo.id}) {
                arrRoundMatches[index] = roundInfo
            }
            
            // Update selected round data
            if let index = arrRoundSelected.index(where: {$0.id == roundInfo.id}) {
                arrRoundSelected[index] = roundInfo
            }
            
            // Update timer array
            if let index = arrRoundModelForTimer.index(where: {$0.id == roundInfo.id}) {
                arrRoundModelForTimer[index] = roundInfo
            }
        }
        
        if self.tournamentStatus == .LiveOtherTournament {
            // Need to update Other live data
            
            if let mainIndex = arrRoundCurrentlyRunningMatches.index(where: {$0.round_no == roundInfo.round_no && $0.tournamentType == roundInfo.tournament_type }) {
                
                var mainRoundInfo = arrRoundCurrentlyRunningMatches[mainIndex]
                
                // Update round info array..
                if let index = mainRoundInfo.round?.index(where: {$0.id == roundInfo.id}) {
                    mainRoundInfo.round?.remove(at: index)
                    mainRoundInfo.round?.insert(roundInfo, at: index)
                    
                    // Update timer array
                    if let index = arrRoundModelForTimer.index(where: {$0.id == roundInfo.id}) {
                        arrRoundModelForTimer[index] = roundInfo
                    }    
                    
                    // Update Main info array..
                    arrRoundCurrentlyRunningMatches.remove(at: mainIndex)
                    arrRoundCurrentlyRunningMatches.insert(mainRoundInfo, at: mainIndex)
                }
            }
            
        }
        
        // Update Array round selected for all tournament..
        if let index = arrRoundSelected.index(where: {$0.id == roundInfo.id}) {
            arrRoundSelected[index] = roundInfo
        }
        
    }
}


//MARK:- MQTT Functions
//MARK:-
extension TournamentDetailViewModel {
    
    func tournamentReceiveAcknowledgment(_ payload: [String: Any]?) {
        
        if let publishStatus = payload?.valueForInt(key: CPublishType) {
            
            switch publishStatus {
            case CPublishJudgeResult:
                // When Judge declare the result
                self.updateJudgeResultFromMQTT(payload)
                break
            case CPublishPlayerResult:
                // When Player declare the result
                self.updateWinLostTieStatus(payload)
                break
            case CPublishPauseResumeTable:
                /*
                 Play/Pause Specific Table
                 1 = Start Timer(Resume)
                 2 = Stop Timer(Pause)
                 */
                if let status = payload?.valueForInt(key: CJsonStatus) {
                    if let tblID = payload?.valueForInt(key: "table_id") {
                        // First stop Existing timer
                        self.stopSpecificRoundTimer(tblID, isCompletedRound: false)
                        if status == CStatusOne {
                            // Start timer here..
                            self.startSpecificRoundTimer(tblID)
                        } else {
                            // Update timer for All round based on Table Id.
                            self.updateAllRoundTimerStatusFromMQTT(isStop: true, payload)
                        }
                    }
                }
                
                break
            case CPublishPauseResumeTournament:
                /*
                 Play/Pause All Table in torunament
                 1 = Start Timer
                 2 = Stop Timer
                 */
                
                if let status = payload?.valueForInt(key: CJsonStatus) {
                    if status == CStatusOne {
                        // Update all timer status to Start Status
                        self.updateAllRoundTimerStatusFromMQTT(isStop: false, payload)
                        self.stopAllTimer()
                        self.configureTimerForRound()
                    }else {
                        // Update all timer status to Stop Status
                        self.updateAllRoundTimerStatusFromMQTT(isStop: true, payload)
                        self.stopAllTimer()
                    }
                }
                break
            case CPublishStartTournament:
                // To start Tournament
                
                if let startStatus = payload?.valueForInt(key: "start_timer") {
                    self.startTournamentStatus(payload)
                    if startStatus == CStatusOne {
                        self.stopAllTimer()
                        // Update all timer status to Start Status
                        self.updateAllRoundTimerStatusFromMQTT(isStop: false, payload)
                        self.configureTimerForRound()
                    }
                }
                break
            case CPublishFinishTournament:
                //Finish Tournament
                
                if tournamentDetailViewModelDelegate != nil {
                    tournamentDetailViewModelDelegate.didFinishTournament(payload)
                }
                break
            case CPublishDropUserFromTournament:
                //Drop User from Tournament
                
                if tournamentDetailViewModelDelegate != nil {
                    tournamentDetailViewModelDelegate.dropUserFromTournament()
                }
                
                break
            default:
                break
            }
            
        }
    }
    
    func updateAllRoundTimerStatusFromMQTT(isStop: Bool, _ payload: [String: Any]?) {
        
        for index in arrRoundModelForTimer.indices {
            var roundInfo = arrRoundModelForTimer[index]
            roundInfo.status = isStop ? 2 : 1
            if isStop {
                // Updated duration for show in timer label
                if roundInfo.id == payload?.valueForInt(key: "table_id") {
                    let duration = payload?.valueForString(key: "duration")
                    roundInfo.duration = duration
                    roundInfo.timeToShow = duration ?? ""
                    roundInfo.timerIncrementSeconds = 0
                }
            }
            
            arrRoundModelForTimer.remove(at: index)
            arrRoundModelForTimer.insert(roundInfo, at: index)
        }
    }
    
    func startTournamentStatus(_ payload: [String: Any]?) {
        // Update start status in selected array
        if let index = arrRoundSelected.index(where: {$0.round_no == payload?.valueForInt(key: "round_no")}){
            arrRoundSelected[index].is_start = CStatusOne
            self.updateRoundInformationInMainArray(arrRoundSelected[index])
        }
    }
    
    func updateWinLostTieStatus(_ payload: [String: Any]?) {
        
        if let roundId = payload?.valueForInt(key: "table_id") {
            var isCompletedRound = false
            
            if let index = arrRoundSelected.index(where: {$0.id == roundId}) {
                
                let userStatusOne = payload?.valueForString(key: "user_id_one_status")
                let userStatusTwo = payload?.valueForString(key: "user_id_two_status")
                let loginUserId = Int(appDelegate.loginUser?.id ?? 0)
                
                var roundInfo = arrRoundSelected[index]
                roundInfo.toHidePauseAndCallJudge = true
                
                if let userIdOne = payload?.valueForInt(key: "user_id_one"), userIdOne == loginUserId {
                    if userStatusOne != CNA {
                        roundInfo.user_id_one_status = userStatusOne
                    }
                } else if let userIdTwo = payload?.valueForInt(key: "user_id_two"), userIdTwo == loginUserId {
                    if userStatusTwo != CNA {
                        roundInfo.user_id_two_status = userStatusTwo
                    }
                }
                
                // If both user has match status then complete the round
                isCompletedRound = roundInfo.user_id_one_status != CNA && roundInfo.user_id_two_status != CNA
                
                // Update data in main array
                arrRoundSelected[index] = roundInfo
                self.updateRoundInformationInMainArray(arrRoundSelected[index])
                self.stopSpecificRoundTimer(roundId, isCompletedRound: isCompletedRound)
            }
        }
    }
    
    func updateJudgeResultFromMQTT(_ payload: [String: Any]?) {
        if let roundId = payload?.valueForInt(key: "table_id") {
            if tournamentStatus == .LiveMyTournament {
                //For my live tournament when update judge result
                if let index = arrRoundMatches.index(where: {$0.id == roundId}) {
                    self.stopSpecificRoundTimer(roundId, isCompletedRound: true)
                    arrRoundMatches[index].user_id_one_status = payload?.valueForString(key: "user_id_one_status")
                    arrRoundMatches[index].user_id_two_status = payload?.valueForString(key: "user_id_two_status")
                    self.updateRoundInformationInMainArray(arrRoundMatches[index])
                }
            } else {
                //For other user live tournament when update judge result
                
                if let mainIndex = arrRoundCurrentlyRunningMatches.index(where: {$0.round_no == payload?.valueForInt(key: "round_no") && $0.tournamentType == payload?.valueForInt(key: "tournament_type") }) {
                    var mainRoundInfo = arrRoundCurrentlyRunningMatches[mainIndex]
                    
                    // Update round info array..
                    if let index = mainRoundInfo.round?.index(where: {$0.id == roundId}) {
                        self.stopSpecificRoundTimer(roundId, isCompletedRound: true)
                        
                        var roundInfo = mainRoundInfo.round?[index]
                        roundInfo?.user_id_one_status = payload?.valueForString(key: "user_id_one_status")
                        roundInfo?.user_id_two_status = payload?.valueForString(key: "user_id_two_status")
                        self.updateRoundInformationInMainArray(roundInfo!)
                        
                    }
                }
                
                self.getCurrentlyRunningLiveRound(round: self.roundNumber, isLiveMatch: isOtherUserMatchLive, isElimantionRound: isElimanitaionForOtherUserMatchLive)
            }
        }
    }
}

//MARK:- Timer Functions
//MARK:-
extension TournamentDetailViewModel {
    
    func configureTimerForRound() {
        arrRoundTimer.removeAll()
        for roundInfo in arrRoundModelForTimer {
            if roundInfo.status == 1 {
                let timerId = roundInfo.id
                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeTick), userInfo: timerId, repeats: true)
                arrRoundTimer.append(timer)
            }
        }
    }
    
    func stopAllTimer() {
        for timer in arrRoundTimer {
            timer.invalidate()
        }
        arrRoundTimer.removeAll()
    }
    
    // To Stop Specific round timer
    func stopSpecificRoundTimer(_ roundId: Int, isCompletedRound: Bool) {
        
        for timer in arrRoundTimer {
            if let userTimerInfo = timer.userInfo {
                if let timerID = userTimerInfo as? Int, timerID == roundId {
                    
                    // Update round timer status = 2
                    if let index = arrRoundModelForTimer.index(where: {$0.id == timerID}) {
                        var roundInfo = arrRoundModelForTimer[index]
                        roundInfo.status = 2
                        arrRoundModelForTimer[index] = roundInfo
                        
                        // When round is completed then remove from array
                        if isCompletedRound {
                            arrRoundModelForTimer.remove(at: index)
                        }
                    }
                    
                    if let index = arrRoundTimer.index(where: {$0.userInfo as? Int == roundId}) {
                        arrRoundTimer.remove(at: index)
                    }
                    
                    timer.invalidate()
                    break
                }
            }
            
        }
    }
    
    func startSpecificRoundTimer(_ roundId: Int) {
        
        if let index = arrRoundModelForTimer.index(where: {$0.id == roundId}) {
            var roundInfo = arrRoundModelForTimer[index]
            roundInfo.status = 1// Update status to start
            arrRoundModelForTimer[index] = roundInfo
            
            // Create timer object here
            let timerId = roundInfo.id
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeTick), userInfo: timerId, repeats: true)
            arrRoundTimer.append(timer)
        }
        
    }
    
    @objc func timeTick(timer: Timer) {
        if let roundId = timer.userInfo as? Int {
            if let index = arrRoundModelForTimer.index(where: {$0.id == roundId}) {
                var roundInfo = arrRoundModelForTimer[index]
                
                roundInfo.timerIncrementSeconds = roundInfo.timerIncrementSeconds + 1
                
                // Get Remaining Time for round
                var remainingTime = roundInfo.durationInSeconds - roundInfo.timerIncrementSeconds
                
                if remainingTime <= 0 {
                    remainingTime = 0
                }
                
                let hour = Int(remainingTime / 3600)
                let minute = Int((remainingTime % 3600) / 60)
                let second = Int((remainingTime % 3600) % 60)
                roundInfo.timeToShow = String(format: "%02d:%02d:%02d ", arguments: [hour,minute,second])
                
                arrRoundModelForTimer.remove(at: index)
                arrRoundModelForTimer.insert(roundInfo, at: index)
                
                // To update time duration in main array..
                self.updateRoundInformationInMainArray(roundInfo)
                
                // If match Timer is over...
                if roundInfo.timerIncrementSeconds >= roundInfo.durationInSeconds {
                    self.stopSpecificRoundTimer(roundId, isCompletedRound: false)
                }
                
                // Pass data to viewcontroller.
                if tournamentDetailViewModelDelegate != nil {
                    tournamentDetailViewModelDelegate.roundDidUpdateTime(roundInfo: roundInfo)
                }
            }
        }
    }
}

//MARK:- Helper Functions
//MARK:-
extension TournamentDetailViewModel {
    func setAttributedRoundTitleForCompleted(selectedRound: String?, player: String?) -> NSMutableAttributedString {
        
        let round = [NSAttributedString.Key.foregroundColor: ColorBlack, NSAttributedString.Key.font: CFontPoppins(size: (CScreenWidth * 20)/375, type: .semibold).setUpAppropriateFont()!]
        let user = [NSAttributedString.Key.foregroundColor: ColorBlack, NSAttributedString.Key.font: CFontPoppins(size: (CScreenWidth * 11)/375, type: .regular).setUpAppropriateFont()!]
        let lblRoundNo = NSMutableAttributedString(string: selectedRound ?? "", attributes: round)
        let lblUser = NSMutableAttributedString(string: "  (\(player ?? "0") Users)", attributes: user)
        let roundTitle = NSMutableAttributedString()
        roundTitle.append(lblRoundNo)
        roundTitle.append(lblUser)
        return roundTitle
    }
}
