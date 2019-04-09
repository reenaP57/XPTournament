//
//  BracketViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class BracketViewController: ParentViewController {
    
    @IBOutlet weak var tblRound : UITableView!
    
    var refreshControl = UIRefreshControl()
    var viewModelTournamentBracket = TournamentBracketViewModel()
    var isElimination: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CBracket
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorBlue
        tblRound.pullToRefreshControl = refreshControl
        
        tblRound.estimatedRowHeight = 206.0
        tblRound.rowHeight = UITableView.automaticDimension
        
        self.loadTournamentBracketList(isShowLoader: true)
    }
}

//MARK:-
//MARK:- API Related Methods

extension BracketViewController {
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadTournamentBracketList(isShowLoader: false)
    }
    
    fileprivate func loadTournamentBracketList(isShowLoader: Bool) {
        
        viewModelTournamentBracket.getTournamentBracketList(tournamentID: viewModelTournamentBracket.tournamentID, type: 1, isShowLoader: isShowLoader) {
            self.refreshControl.endRefreshing()
            self.viewModelTournamentBracket.getLiveRoundTable()
            self.tblRound.reloadData()
            self.viewModelTournamentBracket.getRoundInfo(false)
            UIView.performWithoutAnimation {
                self.tblRound.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
}

//MARK:-
//MARK:- Bracket Header Delegate
extension BracketViewController: BracketHeaderDelegate {
    
    func bracketRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath) {
        viewModelTournamentBracket.getParticularRoundTable(round: round, isElimantionRound: isElimantionRound)
        viewModelTournamentBracket.selectedRoundIndexPath = indexpath
        UIView.performWithoutAnimation {
            self.tblRound.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource
extension BracketViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return isElimination ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isElimination ? 2 : 1
        } else {
            return viewModelTournamentBracket.arrSelectedRound.first?.round?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            if viewModelTournamentBracket.totalRound > 0 {
                let headerView = BracketHeader.viewFromXib as? BracketHeader
                headerView?.loadHeaderViewData(bracketViewModel: viewModelTournamentBracket)
                headerView?.bracketHeaderDelegate = self
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 110.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                // Show Breacket Header Data
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BracketHeaderTblCell") as? BracketHeaderTblCell {
                    // pass breaket header info to cell
                    cell.setBracketInfo(bracketInfo: viewModelTournamentBracket)
                    cell.bracketSwissEliminationDelegate = self
                    if isElimination {
                        tblRound.separatorColor = UIColor.clear
                    }
                    return cell
                }
            }else {
                //Show Web View Data for Elimination
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BracketEliminationTblCell") as? BracketEliminationTblCell {
                    tblRound.isScrollEnabled = false
                    //pass webView Url String to Cell
                    if let eliminationUrl = viewModelTournamentBracket.url {
                        cell.loadEliminationInfo(eliminationUrl)
                        
                    }
                    
                    return cell
                }
            }
        } else {
            //Show Round Data
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BracketTblCell") as? BracketTblCell {
                //pass round Info to cell
                if let roundInfo = viewModelTournamentBracket.arrSelectedRound.first?.round{
                    cell.setRoundInfo(roundInfo: roundInfo[indexPath.row])
                }
                return cell
            }
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row != 0 {
            //webView Section dynamic Height
            return CScreenHeight - UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}

//MARK:- BracketSwissEliminationDelegate for Swiss and Elimination Selected
//MARK:-
extension BracketViewController: BracketSwissEliminationDelegate {
    
    func bracketSwissEliminationSelected(_ isEliminationMatch: Bool) {
        if isEliminationMatch {
            
            // Elimination Selected
            isElimination = isEliminationMatch
            tblRound.reloadData()
        } else {
            
            // Swiss Selected
            isElimination = isEliminationMatch
            self.viewModelTournamentBracket.getRoundInfo(false)
            tblRound.reloadData()
        }
    }
}


