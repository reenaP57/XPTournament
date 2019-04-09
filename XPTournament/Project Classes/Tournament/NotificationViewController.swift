//
//  NotificationViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class NotificationViewController: ParentViewController {
    
    //MARK:- UI Outlets
    //MARK:-

    @IBOutlet weak var tblNotification : UITableView!
    
    var refreshControl = UIRefreshControl()
    var viewModelNotification = NotificationViewModel()
    var isReadNotification = false
    
    //MARK:- View Life Cycle
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CNotificationsTitle
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorBlue
        tblNotification.pullToRefreshControl = refreshControl
       
        tblNotification.estimatedRowHeight = 80
        tblNotification.rowHeight = UITableView.automaticDimension
        
        self.loadNotificationList(isShowLoader: true)
    }
}

//MARK:- API Related Methods
//MARK:-

extension NotificationViewController {
    
    @objc fileprivate func pullToRefresh() {
        self.viewModelNotification.pageNumber = 0
        refreshControl.beginRefreshing()
        self.loadNotificationList(isShowLoader: false)
    }
    
    fileprivate func loadNotificationList(isShowLoader: Bool) {
        
        viewModelNotification.notificationList(isShowLoader: isShowLoader) { (isRefreshScreen) in
            self.refreshControl.endRefreshing()
            
            // Remove all data when user calling api for 1 page
            if self.viewModelNotification.pageNumber == 0 {
                
                GCDMainThread.asyncAfter(deadline: .now() + 3, execute: {
                    self.viewModelNotification.notificationReadList(successCompletion: { (isRefreshScreen) in
                    
                    })
                })
            }
            
            GCDMainThread.asyncAfter(deadline: .now() + 3, execute: {
                self.isReadNotification = true
                for index in self.viewModelNotification.arrNotification.indices {
                    self.viewModelNotification.arrNotification[index].isRead = 1
                    self.tblNotification.reloadData()
                    
                    if index == self.viewModelNotification.arrNotification.count - 1 {
                        GCDMainThread.asyncAfter(deadline: .now() + 1, execute: {
                            self.isReadNotification = false
                        })
                    }
                }
            })
            
            if isRefreshScreen {
                self.tblNotification.reloadData()
            }
        }
    }
}

//MARK:- UITableView Delegate and Datasource Methods
//MARK:-

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelNotification.arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTblCell") as? NotificationTblCell {
            
            if tblNotification.lastIndexPath() == indexPath && !isReadNotification {
                self.loadNotificationList(isShowLoader: false)
            }
            
            
            // pass Notification Info to cell
            cell.loadNotificationInfo(arrNotificationList: viewModelNotification.arrNotification[indexPath.row])
            return cell
        }
        return tableView.tableViewDummyCell()
    }
}
