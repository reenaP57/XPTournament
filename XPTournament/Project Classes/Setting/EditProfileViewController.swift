//
//  EditProfileViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class EditProfileViewController: ParentViewController {

    @IBOutlet weak var imgVProfile: UIImageView! {
        didSet {
            GCDMainThread.async {
                self.imgVProfile.layer.cornerRadius = self.imgVProfile.CViewHeight/2
            }
        }
    }
    
    @IBOutlet weak var txtFullName: MIGenericTextFiled!
    @IBOutlet weak var txtEmail: MIGenericTextFiled!
    @IBOutlet weak var txtMobileNumber: MIGenericTextFiled!
    @IBOutlet weak var txtUserName: MIGenericTextFiled!
    
    var viewUserModel = UserViewModel()
    var isEditProfilePic = false
    
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
        self.title = CEditProfileNavTitle
        self.filledUserDetails()
    }

    fileprivate func filledUserDetails() {
        self.imgVProfile.loadImageFromUrl(appDelegate.loginUser?.image, isPlaceHolderUser: true)
        self.txtEmail.text = appDelegate.loginUser?.email
        self.txtFullName.text = appDelegate.loginUser?.fullName
        self.txtMobileNumber.text = appDelegate.loginUser?.mobileNo
        self.txtUserName.text = appDelegate.loginUser?.userName
    }
    
}

//MARK:-
//MARK:- Action Events

extension EditProfileViewController {
    
    @IBAction func btnProfileClicked(_ sender: UIButton) {
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            if image != nil {
                self.isEditProfilePic = true
                self.imgVProfile.image = image
            }
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: MIGenericButton) {
        
        guard let fullName = txtFullName.text, !fullName.isBlank else {
             self.showAlertView(CBlankFullName, completion: nil)
            return
        }
        
        guard let mobileNumber = txtMobileNumber.text, !mobileNumber.isBlank else {
             self.showAlertView(CBlankPhoneNumber, completion: nil)
            return
        }
        
        guard mobileNumber.isValidPhoneNo else {
             self.showAlertView(CInvalidPhoneNumber, completion: nil)
            return
        }
        
        guard mobileNumber.count == 10 else {
             self.showAlertView(CInvalidPhoneNumberFormat, completion: nil)
            return
        }
        
        guard let userName = txtUserName.text, !userName.isBlank else {
             self.showAlertView(CBlankUserName, completion: nil)
            return
        }
        
        var dict = [String: AnyObject]()
        dict["fullName"] = fullName as AnyObject
        dict["mobileNo"] = mobileNumber as AnyObject
        if userName != appDelegate.loginUser?.userName {
            dict["userName"] = userName as AnyObject
        }
        
        self.viewUserModel.editProfile(dict: dict,successCompletion: { (response, status, message) in
            
            if self.isEditProfilePic {
                
                self.viewUserModel.saveProfileImage(userId: "\(response?.data?.id ?? 0)", image: self.imgVProfile.image, successCompletion: { (response, status, message) in
                    self.showAlertView(CMessageEditedProfile, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                })
            } else {
                self.showAlertView(CMessageEditedProfile, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
