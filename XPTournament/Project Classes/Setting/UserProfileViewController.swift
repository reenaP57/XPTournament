//
//  UserProfileViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 22/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class UserProfileViewController: ParentViewController {

    @IBOutlet weak var imgVUserProfile: UIImageView! {
        didSet {
            GCDMainThread.async {
                 self.imgVUserProfile.layer.cornerRadius = self.imgVUserProfile.CViewHeight / 2
            }
        }
    }
    @IBOutlet weak var txtUserFullName: MIGenericTextFiled!
    @IBOutlet weak var txtUserName: MIGenericTextFiled!
    @IBOutlet weak var txtUserEmail: MIGenericTextFiled!
    @IBOutlet weak var lblTotalTournament: UILabel!
    @IBOutlet weak var lblAvgRating: UILabel!
    @IBOutlet weak var imgVQRCode: UIImageView!

    var viewModelUser = UserViewModel()
    var userId: Int?
    var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initailize() {
        let name = userName + "'s Profile"
        self.title = name
        
        //...Load other user detail from server
        self.loadUserProfile()
    }
    
    fileprivate func loadUserProfile() {
        
        self.view.isHidden = true
        
        _ = viewModelUser.otherUserProfile(userID: userId, successCompletion: { (response, status, message) in
            self.view.isHidden = false
           
            if let userInfo = response?.data  {
               
                //...Set User detail
                self.imgVUserProfile.loadImageFromUrl(userInfo.image, isPlaceHolderUser: true)
                self.imgVQRCode.loadImageFromUrl(userInfo.qrCode, isPlaceHolderUser: false)
                self.txtUserName.text = userInfo.userName
                self.txtUserFullName.text = userInfo.fullName
                self.txtUserEmail.text = userInfo.email
                self.lblTotalTournament.text = "\(userInfo.totalTournament ?? 0)"
                self.lblAvgRating.text = "\(userInfo.avgRating ?? 0)"
            }
            
        })
    }

}
