//
//  ResetPasswordViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ResetPasswordViewController: ParentViewController {

    @IBOutlet weak var txtVerificationCode: MIGenericTextFiled!
    @IBOutlet weak var txtNewPassword: MIGenericTextFiled!
    @IBOutlet weak var txtConfirmPassword: MIGenericTextFiled!
    
    var userEmail: String?
    var viewModelUser = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CResetPasswordTitle
    }
    
    func showVerificationPopup() {
        
        if let verifyView = VerifyView.initVerifyView() as? VerifyView {
            
            //...For Resend Verification code
            verifyView.imgVLogo.image = UIImage(named: "ic_resendcode_bg")
            verifyView.lblVerify.text = CMessageVerifyCodeSendForResetPWD
            
            _ =  verifyView.vwAlertVerify.setConstraintConstant(CScreenHeight - verifyView.vwAlertVerify.CViewHeight, edge: .top, ancestor: true)
            appDelegate.window.addSubview(verifyView)
        }
    }
}

//MARK:-
//MARK:- Action Events

extension ResetPasswordViewController {
    
    @IBAction func btnSubmitClicked(_ sender: MIGenericButton) {
        
        guard let verificationCode = txtVerificationCode.text, !verificationCode.isBlank else {
            self.showAlertView(CBlankVerificationCode, completion: nil)
            return
        }
        
        guard let newPassword = txtNewPassword.text, !newPassword.isBlank else {
            self.showAlertView(CBlankNewPassword, completion: nil)
            return
        }
        guard newPassword.isValidPassword && newPassword.count >= 6 && newPassword.isPasswordAlphaNumericValid else {
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
        
        if let email = self.userEmail {
            viewModelUser.resetPassword(email: email, verifyCode: txtVerificationCode.text, password: txtConfirmPassword.text, successCompletion: { (response, statusCode, message) in
                appDelegate.initLoginViewController()
                self.showAlertView(message, completion: nil)
            })
        }
    }
    
    @IBAction func btnResendCodeClicked(_ sender: MIGenericButton) {
        if let email = self.userEmail {
            viewModelUser.resendVerification(email: email, successCompletion: { (response, status, message) in
                if message != nil {
                    self.showVerificationPopup()
                }
            })
        }
    }
    
}


