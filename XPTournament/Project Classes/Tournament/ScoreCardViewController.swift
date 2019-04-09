//
//  ScoreCardViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ScoreCardViewController: ParentViewController {

    @IBOutlet weak var lblSOS : UILabel!
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var lblMessage: MIGenericLabel!
    @IBOutlet weak var tblScoreCard : UITableView! {
        didSet {
            tblScoreCard.register(UINib(nibName: "MyMatchRoundCompletedTblCell", bundle: nil), forCellReuseIdentifier: "MyMatchRoundCompletedTblCell")
            tblScoreCard.register(UINib(nibName: "ByRoundCompletedTblCell", bundle: nil), forCellReuseIdentifier: "ByRoundCompletedTblCell")
        }
    }
 
    var refreshControl = UIRefreshControl()
    var viewModelScoreCard = TournamentScoreCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CScoreCard

        refreshControl.tintColor = ColorBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblScoreCard.pullToRefreshControl = refreshControl

        //...Load scoreCard list from server
        self.loadScoreCardList(isShowLoader: true)
    }
}

//MARK:-
//MARK:- API Related Methods

extension ScoreCardViewController {
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadScoreCardList(isShowLoader: false)
    }
    
    fileprivate func loadScoreCardList(isShowLoader: Bool) {
        
        //TODO:- Load scorecard list
        self.viewModelScoreCard.getScoreCardList(tournamentID: viewModelScoreCard.tournamentID, isShowLoader: isShowLoader) {
            self.refreshControl.endRefreshing()
            self.lblSOS.text = "\(self.viewModelScoreCard.scoreCardModel?.total_sos ?? 0)"
            self.lblRating.text = "\(self.viewModelScoreCard.scoreCardModel?.total_rating ?? 0)"
            
            if (self.viewModelScoreCard.scoreCardModel?.score_card?.count)! > 0 {
                self.tblScoreCard.reloadData()
                self.tblScoreCard.isHidden = false
                self.lblMessage.isHidden = true
            } else {
                self.tblScoreCard.isHidden = true
                self.lblMessage.isHidden = false
            }
        }
    }
}


//MARK:-
//MARK:- UITableview Delegate and Datasource Methods

extension ScoreCardViewController: UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelScoreCard.scoreCardModel?.score_card?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let scoreCardInfo = viewModelScoreCard.scoreCardModel?.score_card?[section]
        if let headerView = ScoreCardHeader.viewFromXib as? ScoreCardHeader {
            headerView.lblTitle.text = "Round \(scoreCardInfo?.round_no ?? 0)"
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let arrScoreCard = viewModelScoreCard.scoreCardModel?.score_card {
            
            if arrScoreCard[indexPath.section].user_id_one == 1 || arrScoreCard[indexPath.section].user_id_two == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ByRoundCompletedTblCell") as? ByRoundCompletedTblCell {
                    cell.cellConfigureByRoundCompleted(roundInfo: arrScoreCard[indexPath.section], cellType: .fromScoreCard)
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundCompletedTblCell") as? MyMatchRoundCompletedTblCell {
                    
                    //...Pass score card detail in cell
                    cell.cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: arrScoreCard[indexPath.section], cellType: .FromScoreCard)
                    return cell
                }
            }
        }
        
        return tableView.tableViewDummyCell()
    }
}
