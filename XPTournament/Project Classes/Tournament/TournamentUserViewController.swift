//
//  TournamentUserViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TournamentUserViewController: ParentViewController {

    @IBOutlet weak var txtSearch: MIGenericTextFiled!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var tblVTournamentUser: UITableView!
    
    var refreshControl = UIRefreshControl()
    var viewModelTournamentUser = TournamentAllUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = CTournamentUser
        self.viewSearchBar.layer.borderWidth = 1
        self.viewSearchBar.layer.borderColor = CRGB(r: 239, g: 242, b: 249).cgColor
        self.viewSearchBar.layer.cornerRadius = 5
        tblVTournamentUser.contentInset = UIEdgeInsets(top: (CScreenWidth * 26)/375, left: 0, bottom: 0, right: 0)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorBlue
        tblVTournamentUser.pullToRefreshControl = refreshControl
        
        //...Load tournament user list from server
        self.loadTournamentUserList(isShowLoader: true, isRefresh: false)

    }
}

//MARK:-
//MARK:- TextField Action

extension TournamentUserViewController {
    
    @IBAction func didChangedText(_ sender: Any) {
        self.loadTournamentUserList(isShowLoader: false, isRefresh: false)
    }
}

//MARK:-
//MARK:- API Methods

extension TournamentUserViewController {
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadTournamentUserList(isShowLoader: false, isRefresh: true)
    }
    
    fileprivate func loadTournamentUserList(isShowLoader: Bool, isRefresh: Bool) {
        
        viewModelTournamentUser.getAllUserOfParticularTournament(tournamentID: viewModelTournamentUser.tournamentID, search: txtSearch.text, isShowLoader: isShowLoader, isRefresh: isRefresh) {
            self.refreshControl.endRefreshing()
            self.tblVTournamentUser.reloadData()
        }
    }
}

//MARK:-
//MARK:- UITableview Delegate and Datasource Methods

extension TournamentUserViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelTournamentUser.arrUserList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentUserTblCell") as? TournamentUserTblCell {
            
            //...Pass tournament user Info in cell
            cell.setTournamentUserDetail(userInfo: viewModelTournamentUser.arrUserList?[indexPath.row])
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = viewModelTournamentUser.arrUserList?[indexPath.row]
        
        if let userProfileVc = CStoryboardSetting.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
            userProfileVc.userId = Int(userInfo?.id ?? 0)
            
            let components = userInfo?.fullName?.components(separatedBy: " ")
            if(components?.count ?? 0 > 0) {
                userProfileVc.userName = components?.first ?? ""
            }
            
            self.navigationController?.pushViewController(userProfileVc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CScreenWidth * 116)/375
    }
   
}
