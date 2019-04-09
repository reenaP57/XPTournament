//
//  TournamentViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TournamentViewController: ParentViewController {
    
    @IBOutlet weak var tblVTournament: UITableView!
    var viewModelTournament = TournamentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CTournament
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        
        viewModelTournament.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        viewModelTournament.refreshControl.tintColor = ColorBlue
        self.tblVTournament.pullToRefreshControl = viewModelTournament.refreshControl
        
        //TODO:- Load tournamentList from server
        self.loadTournamentsList(isShowLoader: true, isRefresh: false)
    }
}

//MARK:-
//MARK:- API Related Methods

extension TournamentViewController {
    
    @objc fileprivate func pullToRefresh() {
        viewModelTournament.refreshControl.beginRefreshing()
        self.loadTournamentsList(isShowLoader: false, isRefresh: true)
    }
    
    fileprivate func loadTournamentsList(isShowLoader: Bool, isRefresh: Bool) {
        self.viewModelTournament.getHomeList(isShowLoader: isShowLoader, isRefresh: isRefresh) {
            self.tblVTournament.reloadData()
        }
    }
    
}


//MARK:-
//MARK:- TableView Methods

extension TournamentViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelTournament.arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentTblCell") as? TournamentTblCell {
            cell.tournamentTblCellDelegate = self
            cell.lblTitleName.text = viewModelTournament.arrSection[indexPath.section]
            cell.vwSperatorLine.isHidden = false
            
            switch viewModelTournament.arrSection[indexPath.section] {
            case CMyTournament:
                //cell.btnViewAll.isHidden = arrMyTournamentList.count <= 5
                cell.loadTournamentData(arrTournamentList: viewModelTournament.arrMyTournamentList, tournament: CTypeMyTournament)
                
            case COpenForRegistration:
                //cell.btnViewAll.isHidden = arrOpenTournamentList.count <= 5
                cell.loadTournamentData(arrTournamentList: viewModelTournament.arrOpenTournamentList, tournament: CTypeOpenForRegistration)
                
            case CCurrentlyRunning:
                //cell.btnViewAll.isHidden = arrRunningTournamentList.count <= 5
                cell.vwSperatorLine.isHidden = true
                cell.loadTournamentData(arrTournamentList: viewModelTournament.arrRunningTournamentList, tournament: CTypeCurrentlyRunning)
                
            default:
                break
            }
            
            cell.btnViewAll.touchUpInside { (sender) in
                if let tournamentVc = CStoryboardTournament.instantiateViewController(withIdentifier: "TournamentSearchViewController") as? TournamentSearchViewController {
                    
                    switch self.viewModelTournament.arrSection[indexPath.section] {
                    case CMyTournament:
                        tournamentVc.viewModelTournamentSearch.tournamentType = CTypeMyTournament
                    case COpenForRegistration:
                        tournamentVc.viewModelTournamentSearch.tournamentType = CTypeOpenForRegistration
                    default:
                        tournamentVc.viewModelTournamentSearch.tournamentType = CTypeCurrentlyRunning
                    }
                    
                    self.navigationController?.pushViewController(tournamentVc, animated: true)
                }
            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CScreenWidth * 415)/375
    }
}

// MARK:- ------- TournamentTblCellDelegate
// MARK:-
extension TournamentViewController: TournamentTblCellDelegate {
    func didRefreshTournamentList() {
        self.loadTournamentsList(isShowLoader: false, isRefresh: true)
    }
}

// MARK:-
// MARK:- Action Event
extension TournamentViewController{
    @objc func btnSearchClicked() {
        if let tournamentVc = CStoryboardTournament.instantiateViewController(withIdentifier: "TournamentSearchViewController") as? TournamentSearchViewController {
            tournamentVc.isSearchView = true
            self.navigationController?.pushViewController(tournamentVc, animated: true)
        }
    }
}
