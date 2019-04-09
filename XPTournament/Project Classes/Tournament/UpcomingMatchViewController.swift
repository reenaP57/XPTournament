//
//  UpcomingMatchViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class UpcomingMatchViewController: ParentViewController {

    @IBOutlet weak var tblMatch : UITableView! {
        didSet {
            tblMatch.register(UINib(nibName: "MyMatchRoundCompletedTblCell", bundle: nil), forCellReuseIdentifier: "MyMatchRoundCompletedTblCell")
        }
    }
    var refreshControl = UIRefreshControl()
    var viewModelUpcomingMatches = TournamentUpcomingMatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize(){
        self.title = CUpcomingMatchesTitle

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorBlue
        tblMatch.pullToRefreshControl = refreshControl

        //TODO:- Load upcoming matches list from server
        self.loadUpcomingMatches(isShowLoader: true)
    }
}

//MARK:-
//MARK:- API Related Method

extension UpcomingMatchViewController {
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadUpcomingMatches(isShowLoader: false)
    }
    
    fileprivate func loadUpcomingMatches(isShowLoader: Bool) {
        
        viewModelUpcomingMatches.getUpcomingMatches(isShowLoader: isShowLoader) {
            self.refreshControl.endRefreshing()
            self.tblMatch.reloadData()
        }
//
//        viewModelUpcomingMatches.getUpcomingMatches(isShowLoader: isShowLoader, successCompletion: { (response, status) in
//
//            self.refreshControl.endRefreshing()
//
//            if let responseData = response as? UpcomingMatchesModel {
//
//                //...data will be add
//                if let arrMatchInfo = responseData.data {
//                    self.arrUpcomingMatches?.removeAll()
//                    self.arrUpcomingMatches = arrMatchInfo
//                }
//                self.tblMatch.reloadData()
//            }
//        })
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension UpcomingMatchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelUpcomingMatches.arrUpcomingMatches.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UpcomingMatchHeader.viewFromXib as? UpcomingMatchHeader
        let upcomingMatchInfo = viewModelUpcomingMatches.arrUpcomingMatches[section]
        headerView?.lblTournamentName.text = upcomingMatchInfo.title
        headerView?.lblRoundName.text = "Round \(upcomingMatchInfo.round_no ?? 0)"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchRoundCompletedTblCell") as? MyMatchRoundCompletedTblCell {

            //...Pass Upcoming Match Info to cell
            cell.cellConfigurationCompletedAndOtherUserRunningRound(matchInfo: viewModelUpcomingMatches.arrUpcomingMatches[indexPath.section], cellType: .FromUpcomingMatches)
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
}

