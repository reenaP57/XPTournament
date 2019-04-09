//
//  TournamentSearchViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 16/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TournamentSearchViewController: ParentViewController {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblTournamentSearch: UITableView!
    @IBOutlet weak var cnSearchViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var viewSearchBar: MIGenericView!
    
    var refreshControl = UIRefreshControl()
    var viewModelTournamentSearch = TournamentSearchViewModel()
    var isSearchView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }

    //MARK:-
    //MARK:- General Methods
    
    fileprivate func initialize() {
        
        switch viewModelTournamentSearch.tournamentType {
        case CTypeMyTournament:
            self.title = CMyTournament
        case CTypeCurrentlyRunning:
            self.title = CCurrentlyRunning
        default:
            self.title = COpenForRegistration
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        self.navigationController?.navigationBar.isTranslucent = true
       
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorBlue
        tblTournamentSearch.pullToRefreshControl = refreshControl
        
        //...Searchbar Configure
        GCDMainThread.async {
            self.viewSearch.layer.borderWidth = 1
            self.viewSearch.layer.borderColor = CRGB(r: 239, g: 242, b: 249).cgColor
            self.viewSearch.layer.cornerRadius = 3
            self.viewSearchBar.shadow(color: ColorShadow, shadowOffset: CGSize(width: 0, height: 15), shadowRadius: 8, shadowOpacity: 4)
            self.cnSearchViewTopSpace.constant = CNavigationHeight

            if self.isSearchView {
                self.viewSearchBar.hide(byHeight: false)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                GCDMainThread.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.txtSearch.becomeFirstResponder()
                })
            }else{
                self.viewSearchBar.hide(byHeight: true)
                self.navigationController?.navigationBar.shadowImage = UIImage(named: "ic_nav_shadow")
            }
        }
        
        //...Load tournament list from server
        self.loadTournamentList(isShowLoader: true, page: viewModelTournamentSearch.currentPage)
    }
}


//MARK:-
//MARK:- TextField Action

extension TournamentSearchViewController {
    
    @IBAction func didChangedText(_ sender: Any) {
        if (txtSearch.text?.count)! >= 2 || (txtSearch.text?.isBlank)! {
            self.callTournamentListAPI()
        }
    }
}


//MARK:-
//MARK:- API Related Method

extension TournamentSearchViewController {

    fileprivate func callTournamentListAPI() {
        viewModelTournamentSearch.currentPage = 1
        self.loadTournamentList(isShowLoader: false, page: viewModelTournamentSearch.currentPage)
    }
    
    @objc fileprivate func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.callTournamentListAPI()
    }
    
    fileprivate func loadTournamentList(isShowLoader: Bool?, page: Int?) {
        
        self.viewModelTournamentSearch.getTournamentList(type: viewModelTournamentSearch.tournamentType, search: txtSearch.text, page: viewModelTournamentSearch.currentPage, isShowLoader: isShowLoader) {
            self.refreshControl.endRefreshing()
            GCDMainThread.async {
                self.tblTournamentSearch.reloadData()
                self.tblTournamentSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
        }
    }
}

//MARK:-
//MARK:- Action Events

extension TournamentSearchViewController {
    @objc func btnSearchClicked() {
        UIView.animate(withDuration: 0.5) {
            self.viewSearchBar.hide(byHeight: false)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
        GCDMainThread.asyncAfter(deadline: .now() + 0.5, execute: {
            self.txtSearch.becomeFirstResponder()
        })
    }
    
    @IBAction func btnSearchCancelCLK(_ sender : UIButton){
        txtSearch.resignFirstResponder()
        txtSearch.text = nil
        self.callTournamentListAPI()
        UIView.animate(withDuration: 0.5) {
            self.viewSearchBar.hide(byHeight: true)
            self.navigationController?.navigationBar.shadowImage = UIImage(named: "ic_nav_shadow")
        }
    }
}


//MARK:-
//MARK:- TableView Methods

extension TournamentSearchViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelTournamentSearch.arrTournament.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentSearchTblCell") as? TournamentSearchTblCell {
            
            //...Pass tournamentInfo in cell
            cell.setTournamentDetail(tournamentInfo: viewModelTournamentSearch.arrTournament[indexPath.row])
   
            //...Load More
            if indexPath == tblTournamentSearch.lastIndexPath() {
                self.loadTournamentList(isShowLoader: false, page: viewModelTournamentSearch.currentPage)
            }
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CScreenWidth * 170)/375
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tournamentInfo = viewModelTournamentSearch.arrTournament[indexPath.row]
        let tournamentID: Int64 = tournamentInfo.id ?? 0
        
        switch viewModelTournamentSearch.tournamentType {
        case CTypeMyTournament:
            
            switch tournamentInfo.tournamentStatus {
            case CLive, CCompleted:
                if let detailsVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "MyTournamentDetailsViewController") as? MyTournamentDetailsViewController {
                    
                    // Refresh screen after completed the tournament
                    detailsVC.setBlock { (object, message) in
                        self.viewModelTournamentSearch.currentPage = 1
                        self.loadTournamentList(isShowLoader: false, page: self.viewModelTournamentSearch.currentPage)
                    }
                    
                    if (tournamentInfo.tournamentStatus == CLive) {
                        detailsVC.viewModelTournamentDetail.tournamentStatus = .LiveMyTournament
                    } else {
                        detailsVC.viewModelTournamentDetail.tournamentStatus = .TournamentCompleted
                    }
                    detailsVC.viewModelTournamentDetail.tournamentType = viewModelTournamentSearch.tournamentType
                    detailsVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                    self.navigationController?.pushViewController(detailsVC, animated: true)
                }
                
            case CUpcoming:
                if let resgiterTournamentVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "RegisterTournamentViewController") as? RegisterTournamentViewController{
                    resgiterTournamentVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                    self.navigationController?.pushViewController(resgiterTournamentVC, animated: true)
                }
                
            default:
                break
            }
            
        case CTypeOpenForRegistration:
            if let resgiterTournamentVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "RegisterTournamentViewController") as? RegisterTournamentViewController{
                resgiterTournamentVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                self.navigationController?.pushViewController(resgiterTournamentVC, animated: true)
            }
            
        case CTypeCurrentlyRunning:
            if let detailsVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "MyTournamentDetailsViewController") as? MyTournamentDetailsViewController {
                
                // Refresh screen after completed the tournament
                detailsVC.setBlock { (object, message) in
                    self.viewModelTournamentSearch.currentPage = 1
                    self.loadTournamentList(isShowLoader: false, page: self.viewModelTournamentSearch.currentPage)
                }
                
                detailsVC.viewModelTournamentDetail.tournamentStatus = .LiveOtherTournament
                detailsVC.viewModelTournamentDetail.tournamentType = viewModelTournamentSearch.tournamentType
                detailsVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
            
        default:
            break
        }
    }
}
