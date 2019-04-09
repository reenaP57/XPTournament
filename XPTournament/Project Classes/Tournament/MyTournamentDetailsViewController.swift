//
//  MyTournamentDetailsViewController.swift
//  XPTournament
//
//  Created by mac-0005 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MyTournamentDetailsViewController: ParentViewController {
    
    @IBOutlet var btnPauseCallJudge : UIButton!
    @IBOutlet var tblTournamentDetail : UITableView! {
        didSet {
            tblTournamentDetail.register(UINib(nibName: "MyMatchNotesTblCell", bundle: nil), forCellReuseIdentifier: "MyMatchNotesTblCell")
            tblTournamentDetail.register(UINib(nibName: "MyMatchRoundRunningTblCell", bundle: nil), forCellReuseIdentifier: "MyMatchRoundRunningTblCell")
            tblTournamentDetail.register(UINib(nibName: "MyMatchRoundCompletedTblCell", bundle: nil), forCellReuseIdentifier: "MyMatchRoundCompletedTblCell")
            tblTournamentDetail.register(UINib(nibName: "RoundTblCell", bundle: nil), forCellReuseIdentifier: "RoundTblCell")
            tblTournamentDetail.register(UINib(nibName: "RunningRoundTblCell", bundle: nil), forCellReuseIdentifier: "RunningRoundTblCell")
            tblTournamentDetail.register(UINib(nibName: "ByRoundCompletedTblCell", bundle: nil), forCellReuseIdentifier: "ByRoundCompletedTblCell")
            
            tblTournamentDetail.estimatedRowHeight = 100
            tblTournamentDetail.rowHeight = UITableView.automaticDimension
        }
    }
    
    var viewModelTournamentDetail = TournamentDetailViewModel()
    var runningRound = 0
    var selecetdTournamentType = 1
    var isContinueTimer = false
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isContinueTimer = false
        appDelegate.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //NOTE:- Stop All Timer when user move on back screen then only..
        if !isContinueTimer {
            viewModelTournamentDetail.stopAllTimer()
            MIMQTT.shared().mqttDelegate = nil
            MIMQTT.shared().objMQTTClient?.disconnect()
            self.showHideConnectionEstablishView(false)
        }
    }
    
    // MARK:- --------- Initialization
    fileprivate func Initialization() {
        
        MIMQTT.shared().mqttDelegate = self
        switch viewModelTournamentDetail.tournamentStatus {
        case .LiveMyTournament?, .TournamentCompleted?:
            self.title = CMyTournament
        default:
            self.title = CCurrentlyRunning
        }
        
        refreshControl.tintColor = ColorBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblTournamentDetail.pullToRefreshControl = refreshControl
        
        //...Load tournament detail from server
        
        viewModelTournamentDetail.tournamentDetailViewModelDelegate = self
        self.loadTournamentDetail(isShowLoader: true)
    }
}

//MARK:- MQTTDelegate
//MARK:-
extension MyTournamentDetailsViewController: MQTTDelegate {
    func configurationMQTT() {
        MIMQTT.shared().MQTTInitialSetup()
    }
    
    func subcribeMQTTChannel()  {
        if let tournamentInfo = viewModelTournamentDetail.tournamentInfo {
            // Subscribe for start round
            MIMQTT.shared().MQTTSubscribeWithTopic("\(tournamentInfo.id ?? 0)/#", topicPrefix: CMQTTUSERTOPICSTARTTOURNAMENT)
            MIMQTT.shared().MQTTSubscribeWithTopic("\(tournamentInfo.id ?? 0)/#", topicPrefix: CMQTTUSERTOPICSEEDINGTOURNAMENT)
            
            if viewModelTournamentDetail.tournamentStatus == .LiveOtherTournament{
                MIMQTT.shared().MQTTSubscribeWithTopic("\(tournamentInfo.id ?? 0)/#", topicPrefix: CMQTTUSERTOPIC)
            }
            
            if viewModelTournamentDetail.tournamentStatus == .LiveMyTournament {
                if let runningRound = viewModelTournamentDetail.arrRoundModelForTimer.first {
                    MIMQTT.shared().MQTTSubscribeWithTopic("\(tournamentInfo.id ?? 0)/\(runningRound.id ?? 0)", topicPrefix: CMQTTUSERTOPIC)
                }
            }
        }
    }
    
    func didReceiveAcknowledgment(_ payload: [String: Any]?) {
        viewModelTournamentDetail.tournamentReceiveAcknowledgment(payload)
        
        // For specific round in my tournament
        if payload?.valueForInt(key: CPublishType) == CPublishPauseResumeTable || payload?.valueForInt(key: CPublishType) == CPublishPauseResumeTournament {
            self.hidePauseAndCallBtn()
        }
        if payload?.valueForInt(key: CPublishType) == CPublishPlayerResult || payload?.valueForInt(key: CPublishType) == CPublishJudgeResult || payload?.valueForInt(key: CPublishType) == CPublishStartTournament {
            UIView.performWithoutAnimation {
                self.tblTournamentDetail.reloadData()
            }
            self.hidePauseAndCallBtn()
        }
        
    }
    
    func mqttConnection(_ connected: Bool) {
        if connected {
            // MQTT is Connected with server
            self.showHideConnectionEstablishView(false)
            self.subcribeMQTTChannel()
        }else {
            // MQTT is not Connected with server
            self.showHideConnectionEstablishView(true)
            GCDMainThread.asyncAfter(deadline: .now() + 2) {
                self.configurationMQTT()
            }
        }
    }
    
}


//MARK:- API Related Methods
//MARK:-
extension MyTournamentDetailsViewController {
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadTournamentDetail(isShowLoader: false)
    }
    
    fileprivate func loadTournamentDetail(isShowLoader: Bool) {
  
        self.btnPauseCallJudge.hide(byHeight: true)
        MIMQTT.shared().objMQTTClient?.disconnect()
        
        GCDMainThread.asyncAfter(deadline: .now() + 0.5, execute: {
            self.showHideConnectionEstablishView(false)
        })
        
        
        //...Block call after get tournament details
        viewModelTournamentDetail.getTournamentDetail(tournamentID: viewModelTournamentDetail.tournamentID, isShowLoader: isShowLoader) {
            self.refreshControl.endRefreshing()
            
            if self.viewModelTournamentDetail.tournamentInfo?.ratingStatus == CStatusZero && self.viewModelTournamentDetail.tournamentInfo?.isRegister == CStatusOne {
                
                // When completed Live tournament in My Tournament then open rating screen.
                if let ratingVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "RatingViewController") as? RatingViewController{
                    ratingVC.tournamentInfo = self.viewModelTournamentDetail.tournamentInfo
                    self.navigationController?.pushViewController(ratingVC, animated: true)
                }
            }
            
            let roundInfo = self.viewModelTournamentDetail.arrRoundSelected.first
            self.tblTournamentDetail.isHidden = false
            //...Show Pause & Call Judge button if match is mine....
            if self.viewModelTournamentDetail.tournamentStatus == .LiveMyTournament && roundInfo?.user_id_one_status == CNA && roundInfo?.user_id_one_status == CNA {
                // Live Tournament
                
                self.btnPauseCallJudge.hide(byHeight: false)
                _ = self.btnPauseCallJudge.setConstraintConstant(20, edge: .top, ancestor: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(20, edge: .bottom, ancestor: true)
                GCDMainThread.async {
                    self.btnPauseCallJudge.layer.cornerRadius = self.btnPauseCallJudge.frame.size.height / 2
                }
            } else {
                self.btnPauseCallJudge.hide(byHeight: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .top, ancestor: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .bottom, ancestor: true)
            }
            
            UIView.performWithoutAnimation {
                self.tblTournamentDetail.reloadData()
            }
            
            if self.viewModelTournamentDetail.tournamentStatus == .LiveOtherTournament {
                //...Load Complted-Live Round Info for Currently Running Other Player from server
                self.loadAllRoundForCurrentlyRunning()
            } else {
                //...Load Completed-Live Round Info for My Tournament from server
                self.loadCompletedAndLiveRoundInfo()
            }
        }
    }
    
    fileprivate func loadCompletedAndLiveRoundInfo() {
        
        /* 0 => All List ,
         1 => Completed List
         */
        
        //...Load Completed - Live Round
        viewModelTournamentDetail.getCompletedAndLiveTournamentRound(tournamentID: viewModelTournamentDetail.tournamentID, type: 0) {
            
            switch self.viewModelTournamentDetail.tournamentStatus {
            case .TournamentCompleted?:
                self.showHideConnectionEstablishView(false)
                self.viewModelTournamentDetail.selectedRoundIndexPath = IndexPath(item: 0, section: 0)
            case .LiveMyTournament?:
                self.showHideConnectionEstablishView(false)
                self.configurationMQTT()
            default:
                break
            }
            
            self.hidePauseAndCallBtn()
            UIView.performWithoutAnimation {
                self.tblTournamentDetail.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
    
    // Get Currently Running data for other user.
    fileprivate func loadAllRoundForCurrentlyRunning() {
        
        viewModelTournamentDetail.getTournamentRoundForCurrentRunning(tournamentID: viewModelTournamentDetail.tournamentID) {
            UIView.performWithoutAnimation {
                self.tblTournamentDetail.reloadSections(IndexSet(integer: 1), with: .none)
                self.configurationMQTT()
            }
        }
    }
}

//MARK:- Helper function
//MARK:-
extension MyTournamentDetailsViewController {
    
    fileprivate func hidePauseAndCallBtn() {
        
        if (viewModelTournamentDetail.arrRoundModelForTimer.count > 0) && viewModelTournamentDetail.tournamentStatus == .LiveMyTournament {
            
            //...Hide Pause and call button If round is completed round
            let roundInfo = viewModelTournamentDetail.arrRoundModelForTimer.first
            
            if (roundInfo?.user_id_one_status == CNA && roundInfo?.user_id_two_status == CNA) && !(roundInfo?.toHidePauseAndCallJudge)! {
                self.btnPauseCallJudge.hide(byHeight: false)
                _ = self.btnPauseCallJudge.setConstraintConstant(20, edge: .top, ancestor: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(20, edge: .bottom, ancestor: true)
                GCDMainThread.async {
                    self.btnPauseCallJudge.layer.cornerRadius = self.btnPauseCallJudge.frame.size.height / 2
                }
                
                if roundInfo?.status == 1 {
                    self.btnPauseCallJudge.isUserInteractionEnabled = true
                    self.btnPauseCallJudge.alpha = 1.0
                }else {
                    self.btnPauseCallJudge.isUserInteractionEnabled = false
                    self.btnPauseCallJudge.alpha = 0.5
                }
                
            } else {
                self.btnPauseCallJudge.hide(byHeight: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .top, ancestor: true)
                _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .bottom, ancestor: true)
            }
        } else {
            self.btnPauseCallJudge.hide(byHeight: true)
            _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .top, ancestor: true)
            _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .bottom, ancestor: true)
            
        }
        
        // If select previous round which is completed in My Live Tournament  then Hide Pause and Call Judge Button
        let selectedRoundInfo = viewModelTournamentDetail.arrRoundSelected.first
        if selectedRoundInfo?.user_id_one_status != CNA && selectedRoundInfo?.user_id_two_status != CNA {
            self.btnPauseCallJudge.hide(byHeight: true)
            _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .top, ancestor: true)
            _ = self.btnPauseCallJudge.setConstraintConstant(0, edge: .bottom, ancestor: true)
        }
    }
    
    fileprivate func showHideConnectionEstablishView(_ isShow: Bool) {
        
        if isShow {
            // show view here
            var isAlreadyThere = false
            for objView in self.view.subviews where objView.isKind(of: ConnectionAlertView.classForCoder()){
                isAlreadyThere = true
            }
            if !isAlreadyThere {
                if let connectionAlertView = ConnectionAlertView.initConnectionAlertView() as? ConnectionAlertView {
                    self.view.addSubview(connectionAlertView)
                    connectionAlertView.bringSubviewToFront(self.view)
                }
            }
        }else {
            // hide view here
            for objView in self.view.subviews where objView.isKind(of: ConnectionAlertView.classForCoder()){
                objView.removeFromSuperview()
            }
        }
    }
}

// MARK:- UITableView Datasources and Delegate
// MARK:-
extension MyTournamentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelTournamentDetail.tournamentInfo == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            
            switch viewModelTournamentDetail.tournamentStatus {
            
            case .LiveMyTournament?:
                
                // MY LIVE MATCH
                if viewModelTournamentDetail.arrRoundSelected.count > 0 {
                    let selectedInfo = viewModelTournamentDetail.arrRoundSelected.first
                    let loginUserId = Int(appDelegate.loginUser?.id ?? 0)
                    if (selectedInfo?.user_id_one == loginUserId && selectedInfo?.user_id_one_status == CNA) || selectedInfo?.user_id_two == loginUserId && selectedInfo?.user_id_two_status == CNA {
                        return viewModelTournamentDetail.arrRoundSelected.count + 2
                    } else {
                        return viewModelTournamentDetail.arrRoundSelected.count + 1
                    }
                }else {
                    return 0
                }
            case .LiveOtherTournament?:
                
                // FOR OTHER USER LIVE MATCH
                if viewModelTournamentDetail.arrRoundSelected.count > 0 {
                    return viewModelTournamentDetail.arrRoundSelected.count + 1
                } else {
                    return 1
                }
            
            case .TournamentCompleted?:
                // COMPLETED TOURNAMENT
                return viewModelTournamentDetail.arrRoundSelected.count + 1
            default:
                break
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // Tournament header cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyTournamentDetailsHeaderTblCell") as? MyTournamentDetailsHeaderTblCell {
                cell.myTournamentDetailsHeaderDelegate = self
                cell.setTournamentDetail(tournamentInfo: viewModelTournamentDetail.tournamentInfo!, tournamentStatus: viewModelTournamentDetail.tournamentStatus!.rawValue)
                return cell
            }
        } else {
            switch viewModelTournamentDetail.tournamentStatus {
                
            case .LiveMyTournament?:
                
                // MY Live MATCH
                let roundInfo = viewModelTournamentDetail.arrRoundSelected.first
                switch indexPath.row {
                case 0:
                    //...Round Title Cell
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "RoundTblCell") as? RoundTblCell {
                        
                        // To show currenlty selected Round..
                        GCDMainThread.async {
                        cell.lblRound.text = self.viewModelTournamentDetail.selectedRoundIndexPath.item > self.viewModelTournamentDetail.swissRoundCounts - 1 ? "\(kElimantionText) \(self.viewModelTournamentDetail.selectedRoundIndexPath.item - (self.viewModelTournamentDetail.swissRoundCounts - 1))" : "\(kRoundText) \(self.viewModelTournamentDetail.selectedRoundIndexPath.item+1)"
                        }
                        
                        return cell
                    }
                case 1:
                    
                    let loginUserID = Int(appDelegate.loginUser?.id ?? 0)
                    let firstUserID = roundInfo?.user_id_one
                    let secondUserID = roundInfo?.user_id_two
                    
                    var toShowRunningCell = false
                    
                    // If first User is login user
                    if firstUserID == loginUserID && roundInfo?.user_id_one_status == CNA {
                        toShowRunningCell = true
                    }
                    
                    // If second User is login user
                    if secondUserID == loginUserID && roundInfo?.user_id_two_status == CNA {
                        toShowRunningCell = true
                    }
                    
                    if toShowRunningCell {
                        //...Running Round Cell
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundRunningTblCell") as? MyMatchRoundRunningTblCell {
                            cell.myMatchRoundRunningTblCellDelegate = self
                            cell.cellConfigureMyMatchRoundRunning(roundInfo: roundInfo!)
                            return cell
                        }
                    } else {
                        //...Completed Round Cell
                        if roundInfo?.user_id_one == 1 || roundInfo?.user_id_two == 1 {
                            if let cell = tableView.dequeueReusableCell(withIdentifier: "ByRoundCompletedTblCell") as? ByRoundCompletedTblCell {
                                //...Passed round Info to cell
                                cell.cellConfigureByRoundCompleted(roundInfo: roundInfo!, cellType: .fromTournamentDetail)
                                return cell
                            }
                        } else {
                            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundCompletedTblCell") as? MyMatchRoundCompletedTblCell {
                                cell.lblTimer.isHidden = true
                                //...Pass Complted Match Info to cell
                                cell.cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: roundInfo as Any, cellType: .FromMyTournamentDetail)
                                return cell
                            }
                        }
                    }
                case 2:
                    //...Manual Note Score Cell
                    let loginUserId = Int(appDelegate.loginUser?.id ?? 0)
                    if (roundInfo?.user_id_one == loginUserId && roundInfo?.user_id_one_status == CNA) || roundInfo?.user_id_two == loginUserId && roundInfo?.user_id_two_status == CNA {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchNotesTblCell") as? MyMatchNotesTblCell{
                            // Pass round info to cell
                            cell.setMatchRoundDetail(roundInfo: roundInfo!)
                            return cell
                        }
                    }
                    
                default:
                    break
                }
                
            case .TournamentCompleted?:
                
                // MY COMPLETED MATCH
                let roundInfo = viewModelTournamentDetail.arrRoundSelected.first
                if indexPath.row == 0 {
                    //...Round Title Cell
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "RoundTblCell") as? RoundTblCell {
                        if viewModelTournamentDetail.arrRoundSelected.count > 0 {
                            cell.lblRound.text = "\(kRoundText) \(roundInfo?.round_no ?? 0)"
                        } else {
                            // If Tournament Data is nil
                            cell.lblRound.text = CNotInTournament
                        }
                        
                        return cell
                    }
                    
                } else {
                    if roundInfo?.user_id_one == 1 || roundInfo?.user_id_two == 1 {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ByRoundCompletedTblCell") as? ByRoundCompletedTblCell {
                            
                            //...Passed round Info to cell
                            cell.cellConfigureByRoundCompleted(roundInfo: roundInfo!, cellType: .fromTournamentDetail)
                            return cell
                        }
                    } else {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundCompletedTblCell") as? MyMatchRoundCompletedTblCell {
                            cell.lblTimer.isHidden = true
                            
                            //...Passed round Info to cell
                            cell.cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: roundInfo as Any, cellType: .FromMyTournamentDetail)
                            return cell
                        }
                    }
                }
                
            default:
                // OTHER USER RUNNING MATCH
                if indexPath.row == 0 {
                    //...Round Title Cell
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "RunningRoundTblCell") as? RunningRoundTblCell {
                        cell.runningRoundTblCellDelegate = self
                        cell.cellConfigureRunningRound(tournamentInfo: viewModelTournamentDetail)
                        return cell
                    }
                } else {
                    //...
                    let roundInfo = viewModelTournamentDetail.arrRoundSelected[indexPath.row - 1]
                    
                    if roundInfo.user_id_one == 1 || roundInfo.user_id_two == 1 {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ByRoundCompletedTblCell") as? ByRoundCompletedTblCell {
                            
                            //...Passed round Info to cell
                            cell.cellConfigureByRoundCompleted(roundInfo: roundInfo, cellType: .fromTournamentDetail)
                            return cell
                        }
                    } else {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundCompletedTblCell") as? MyMatchRoundCompletedTblCell {
                            cell.cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: roundInfo as Any, cellType: .FromCurrentlyRunningTournamentDetail)
                            return cell
                        }
                    }
                }
            }
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return 0
        }
        
        switch viewModelTournamentDetail.tournamentStatus {
        case .TournamentCompleted?:
            return 56
        case .LiveMyTournament?:
            return 90
        default:
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        
        switch viewModelTournamentDetail.tournamentStatus {
        case .TournamentCompleted?:
            // Completed round
            if let completedHeaderView = TournamentDetailCompletedHeader.viewFromXib as? TournamentDetailCompletedHeader {
                completedHeaderView.isCompletedTournament = true
                completedHeaderView.tournamentDetailCompletedHeaderDelegate = self
                completedHeaderView.configureCurrentlyRunningAndCompletedHeader(tournament: viewModelTournamentDetail)
                return completedHeaderView
            }
            
        case .LiveMyTournament?:
            // Login user live round
            if let liveHeaderView = TournamentDetailMyLiveHeader.viewFromXib as? TournamentDetailMyLiveHeader {
                
                liveHeaderView.tournamentDetailMyLiveHeaderDelegate = self
                
                if (viewModelTournamentDetail.arrRoundSelected.first?.user_id_one_status == CNA && viewModelTournamentDetail.arrRoundSelected.first?.user_id_two_status == CNA) {
                    if let round = viewModelTournamentDetail.arrRoundSelected.first?.round_no {
                        runningRound = round
                    }
                    if let selectedType = viewModelTournamentDetail.arrRoundSelected.first?.tournament_type {
                         selecetdTournamentType = selectedType
                    }
                } else {
                    runningRound = 0
                }

                liveHeaderView.configureMyLiveHeader(tournament: viewModelTournamentDetail, runningRound: runningRound, selectedTournamentType: selecetdTournamentType)
                return liveHeaderView
            }
        default:
            // Other user live round
            if let completedHeaderView = TournamentDetailCompletedHeader.viewFromXib as? TournamentDetailCompletedHeader {
                completedHeaderView.isCompletedTournament = false
                completedHeaderView.tournamentDetailCompletedHeaderDelegate = self
                completedHeaderView.configureCurrentlyRunningAndCompletedHeader(tournament: viewModelTournamentDetail)
                return completedHeaderView
            }
        }
        
        return UIView()
    }
    
}

// MARK:- ------- MyTournamentDetailsHeaderDelegate
// MARK:-
extension MyTournamentDetailsViewController: MyTournamentDetailsHeaderDelegate {
    func userMovingInNextScreen(){
        isContinueTimer = true
    }
}

// MARK:- ------- RunningRoundTblCellDelegate
// MARK:-
extension MyTournamentDetailsViewController: RunningRoundTblCellDelegate {
    // Other user Live/Completed delegate
    func tournamentMatchTypeSelected(isLive: Bool, roundIndex: Int) {
        viewModelTournamentDetail.isOtherUserMatchLive = isLive
        viewModelTournamentDetail.roundNumber = roundIndex
        viewModelTournamentDetail.getCurrentlyRunningLiveRound(round: roundIndex, isLiveMatch: isLive, isElimantionRound: viewModelTournamentDetail.isElimanitaionForOtherUserMatchLive)
        self.hidePauseAndCallBtn()
        UIView.performWithoutAnimation {
            self.tblTournamentDetail.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}

//MARK:- ------- MyMatchRoundRunningTblCellDelegate
//MARK:-

extension MyTournamentDetailsViewController: MyMatchRoundRunningTblCellDelegate {
    func matchWinLostTieSelected(resultStatus: TournamentResultStatus) {
        
        if let liveRoundInfo = viewModelTournamentDetail.arrRoundSelected.first {
            var liveResultInfo = [String: Any]()
            liveResultInfo["tournament_id"] = liveRoundInfo.tournament_id
            liveResultInfo["table_id"] = liveRoundInfo.id
            liveResultInfo["round_no"] = liveRoundInfo.round_no
            liveResultInfo["tournament_type"] = liveRoundInfo.tournament_type
            liveResultInfo["user_id_one"] = liveRoundInfo.user_id_one
            liveResultInfo["user_id_two"] = liveRoundInfo.user_id_two
            if (liveRoundInfo.user_id_one ?? 0) == Int(appDelegate.loginUser?.id ?? 0) {
                liveResultInfo["user_id_one_status"] = resultStatus.rawValue
                liveResultInfo["user_id_two_status"] = CNA
            } else {
                liveResultInfo["user_id_one_status"] = CNA
                liveResultInfo["user_id_two_status"] = resultStatus.rawValue
            }
            liveResultInfo["publish_type"] = CPublishPlayerResult
            let topic = CMQTTUSERTOPIC + "\(liveRoundInfo.tournament_id ?? 0)/\(liveRoundInfo.id ?? 0)"
            MIMQTT.shared().MQTTPublishWithTopic(liveResultInfo, topic)
        }
    }
}

// MARK:- ------- TournamentDetailCompletedHeaderDelegate
// MARK:-

extension MyTournamentDetailsViewController: TournamentDetailCompletedHeaderDelegate {
    func tournamentCompleteRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath) {
        
        viewModelTournamentDetail.selectedRoundIndexPath = indexpath
        
        switch viewModelTournamentDetail.tournamentStatus {
        case .TournamentCompleted?:
            // Completed Tournament
            viewModelTournamentDetail.getCompletedRoundInfo(round: round, isElimantionRound: isElimantionRound)
            if let cell = tblTournamentDetail.cellForRow(at: IndexPath(item:0 , section: 1)) as? RoundTblCell {
                cell.lblRound.text = "\(kRoundText) \(round)"
            }
        
        case .LiveOtherTournament?:
            // Other Live Tournament
            viewModelTournamentDetail.isElimanitaionForOtherUserMatchLive = isElimantionRound
            viewModelTournamentDetail.isOtherUserMatchLive = true
            viewModelTournamentDetail.roundNumber = round
            viewModelTournamentDetail.getCurrentlyRunningLiveRound(round: round, isLiveMatch: true, isElimantionRound: isElimantionRound)
            
            if let cell = tblTournamentDetail.cellForRow(at: IndexPath(item:0 , section: 1)) as? RunningRoundTblCell {
                let arrCur = viewModelTournamentDetail.arrRoundCurrentlyRunningMatches.filter({$0.round_no == round}) as [CurrentlyRunningRoundDetailModel]
                if arrCur.count > 0 {
                    cell.lblRoundNumber.attributedText = viewModelTournamentDetail.setAttributedRoundTitleForCompleted(selectedRound: "\(kRoundText) \(round)", player: arrCur.first?.totalPlayers?.toString)
                }
            }
        default :
            break
            
        }
        
        self.hidePauseAndCallBtn()
        UIView.performWithoutAnimation {
            self.tblTournamentDetail.reloadSections(IndexSet(integer: 1), with: .none)
        }
        
    }
}

// MARK:- ------- TournamentDetailMyLiveHeaderDelegate
// MARK:-

extension MyTournamentDetailsViewController: TournamentDetailMyLiveHeaderDelegate {
    func tournamentMyLiveRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath) {
        
        viewModelTournamentDetail.getCompletedRoundInfo(round: round, isElimantionRound: isElimantionRound)
        viewModelTournamentDetail.selectedRoundIndexPath = indexpath
        self.hidePauseAndCallBtn()
        
        UIView.performWithoutAnimation {
            self.tblTournamentDetail.reloadSections(IndexSet(integer: 1), with: .none)
        }
        
        if let cell = tblTournamentDetail.cellForRow(at: IndexPath(item:0 , section: 1)) as? RoundTblCell {
            cell.lblRound.text = "Round \(round)"
        }
    }
}

// MARK:- ------- TournamentDetailViewModelDelegate
// MARK:-

extension MyTournamentDetailsViewController: TournamentDetailViewModelDelegate {
    
    func roundDidUpdateTime(roundInfo: RoundDetailModel) {
        switch viewModelTournamentDetail.tournamentStatus {
        case .LiveMyTournament?:
            // Live Tournament
            self.updateMyMatchRunningCellTime(roundInfo)
            self.hidePauseAndCallBtn()
        case .LiveOtherTournament?:
            // Live Other Tournament
            self.updateOtherUserMatchRunningCellTime(roundInfo)
        default:
            // Completed match
            break
        }
    }

    // To update login user round time
    fileprivate func updateMyMatchRunningCellTime(_ roundInfo: RoundDetailModel) {
        for cell in tblTournamentDetail.visibleCells where cell.isKind(of: MyMatchRoundRunningTblCell.classForCoder()) {
            if let cellRound = cell as? MyMatchRoundRunningTblCell, cellRound.cellRoundInformation.id == roundInfo.id {
                cellRound.lblMyMatchTimer.text = roundInfo.timeToShow
            }
        }
    }
    
    // To update Other user round time
    fileprivate func updateOtherUserMatchRunningCellTime(_ roundInfo: RoundDetailModel) {
        for cell in tblTournamentDetail.visibleCells where cell.isKind(of: MyMatchRoundCompletedTblCell.classForCoder()) {
            if let cellRound = cell as? MyMatchRoundCompletedTblCell, cellRound.cellRoundInformation.id == roundInfo.id {
                cellRound.lblTimer.text = roundInfo.timeToShow
            }
        }
    }
    
    func didFinishTournament(_ tournament: [String: Any]?) {
        
        // When new round start delete tblRoundNotes all object
        TblRoundNotes.deleteAllObjects()
        CoreData.saveContext()
        
        // Refresh previous screen when tournament get completed.
        if tournament?.valueForInt(key: "Type") == 3 {
            if self.viewModelTournamentDetail.tournamentStatus == .LiveMyTournament {
                // update previous screen type for my tournament
                if let block = self.block {
                    block(nil, "refresh")
                }
            }else if self.viewModelTournamentDetail.tournamentStatus == .LiveOtherTournament {
                // Remove tournament from list in previous screen
                if let block = self.block {
                    block(nil, "refresh")
                }
            }
        }
        
        // When my tournament get completed then all data will update according to completed type.
        if tournament?.valueForInt(key: "Type") == 3 && viewModelTournamentDetail.tournamentStatus == .LiveMyTournament {
            viewModelTournamentDetail.tournamentStatus = .TournamentCompleted
        }
        
        self.loadTournamentDetail(isShowLoader: true)
    }
    
    // when user drop from tournament
    func dropUserFromTournament() {
        if let block = self.block {
            block(nil, "refresh")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- ------- Action Event
// MARK:-

extension MyTournamentDetailsViewController {
    @IBAction func btnPauseCallJudgeCLK(_ sender : UIButton) {
        self.showAlertConfirmationView(CPauseMatchAndCallJudge, okTitle: CBtnSubmit, cancleTitle: CBtnCancel, type: .confirmationView) { (result) in
            
            //Publish Payload click on btnPause and Call judge
            if result {
                if let runningRound = self.viewModelTournamentDetail.arrRoundSelected.first {
                    var liveRoundInfo = [String: Any]()
                    liveRoundInfo["table_id"] = runningRound.id
                    liveRoundInfo["organizer_id"] = 0
                    liveRoundInfo["user_id"] = appDelegate.loginUser?.id
                    liveRoundInfo["tournament_id"] = runningRound.tournament_id
                    liveRoundInfo["round_no"] = runningRound.round_no
                    liveRoundInfo["table_no"] = runningRound.table_no
                    liveRoundInfo["status"] = "2"
                    liveRoundInfo["tournament_type"] = "\(runningRound.tournament_type ?? 0)"
                    liveRoundInfo["publish_type"] = CPublishPauseResumeTable
                    let topic = CMQTTUSERTOPICPAUSEMYTOURNAMENT + "\(runningRound.tournament_id ?? 0)/\(runningRound.id ?? 0)"
                    MIMQTT.shared().MQTTPublishWithTopic(liveRoundInfo, topic)
                }
            }
        
        }
    }
}
