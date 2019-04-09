//
//  ProfileViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 20/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ProfileViewController: ParentViewController {

    @IBOutlet weak var txtFullName: MIGenericTextFiled!
    @IBOutlet weak var txtEmail: MIGenericTextFiled!
    @IBOutlet weak var txtMobileNumber: MIGenericTextFiled!
    @IBOutlet weak var txtUserName: MIGenericTextFiled!
    @IBOutlet weak var lblTournament: UILabel!
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var imgVProfile: UIImageView! {
        didSet {
            GCDMainThread.async {
                self.imgVProfile.layer.cornerRadius = self.imgVProfile.CViewHeight / 2
            }
        }
    }
    
    @IBOutlet weak var imgQrCode: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.filledUserDetails()
        appDelegate.showTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initailize() {
        self.title = CProfile
    }

    fileprivate func filledUserDetails() {
        self.imgVProfile.loadImageFromUrl(appDelegate.loginUser?.image, isPlaceHolderUser: true)
        self.imgQrCode.loadImageFromUrl(appDelegate.loginUser?.qrCode, isPlaceHolderUser: false)
        self.txtEmail.text = appDelegate.loginUser?.email
        self.txtFullName.text = appDelegate.loginUser?.fullName
        self.txtMobileNumber.text = appDelegate.loginUser?.mobileNo
        self.txtUserName.text = appDelegate.loginUser?.userName
        self.lblTournament.text = "\(appDelegate.loginUser?.totalTournament ?? 0)"
        self.lblAvgRating.text = "\(Float((appDelegate.loginUser?.avgRating) ?? 0.0) )"
    }
}

//MARK:-
//MARK:- Action Events

extension ProfileViewController {
    
    @IBAction func btnEditClicked(_ sender: MIGenericButton) {
        if let editProfileVc = CStoryboardSetting.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            navigationController?.pushViewController(editProfileVc, animated: true)
        }
    }
    
}
