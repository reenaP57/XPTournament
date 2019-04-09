//
//  ChangePasswordViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController {

    @IBOutlet weak var txtCurrentPassword: MIGenericTextFiled!
    @IBOutlet weak var txtNewPassword: MIGenericTextFiled!
    @IBOutlet weak var txtConfirmPassword: MIGenericTextFiled!
    
    var viewModelUser = UserViewModel()
    
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
        self.title = CChangePasswordNavTitle
    }
    
}

//MARK:-
//MARK:- Action Events

extension ChangePasswordViewController {
    
    @IBAction func btnSubmitClicked(_ sender: MIGenericButton) {
        
        guard let password = txtCurrentPassword.text, !password.isBlank else {
             self.showAlertView(CBlankCurrentPassword, completion: nil)
            return
        }
        
        guard password.count >= 6 else {
            self.showAlertView(CInvalidPasswordFormat, completion: nil)
            return
        }
        
        guard let newPassword = txtNewPassword.text, !newPassword.isBlank else {
             self.showAlertView(CBlankNewPassword, completion: nil)
            return
        }
        
        guard  newPassword.isValidPassword && newPassword.count >= 6 && newPassword.isPasswordAlphaNumericValid else{
            self.showAlertView(CInvalidPasswordFormat, completion: nil)
            return
        }
        
        guard let confirmPassword = txtConfirmPassword.text, !confirmPassword.isBlank else {
             self.showAlertView(CBlankConfirmPassword, completion: nil)
            return
        }
        
        guard confirmPassword == newPassword else {
             self.showAlertView(CNewPasswordConfirmPasswordMisMatch, completion: nil)
            return
        }
        
        self.changePassword()
    }
}

//MARK:-
//MARK:- API Method

extension ChangePasswordViewController {
    
    fileprivate func changePassword() {
       
        self.viewModelUser.changePassword(oldPwd: txtCurrentPassword.text, newPwd: txtNewPassword.text, successCompletion: { (response, status, message) in
            self.showAlertView(message, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }) 
    }
}
