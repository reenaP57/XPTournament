//
//  LoginViewController.swift
//  XPTournament
//
//  Created by mac-0005 on 13/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {

    @IBOutlet weak var txtUserName: MIGenericTextFiled!
    @IBOutlet weak var txtPassword: MIGenericTextFiled!
    @IBOutlet weak var btnRemember: UIButton!
    
    var viewModelUser = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_SIMULATOR {
            txtPassword.text = "Mind@123"
            txtUserName.text = "rushi.patel.mi@gmail.com"
        }
    }
}


//MARK:- Action Events
//MARK:-

extension LoginViewController {
    
    @IBAction fileprivate func btnRememberMeClicked(_ sender: MIGenericButton) {
        btnRemember.isSelected = !btnRemember.isSelected
    }
    
    @IBAction fileprivate func btnForgotPasswordClicked(_ sender: MIGenericButton) {
        if let forgotPasswordVc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            navigationController?.pushViewController(forgotPasswordVc, animated: true)
        }
    }
    
    @IBAction fileprivate func btnLoginClicked(_ sender: MIGenericButton) {
        
        guard let userName = txtUserName.text, !userName.isBlank else {
            self.showAlertView(CBlankEmailOrUserName, completion: nil)
            return
        }

        if userName.range(of:"@") != nil {

            guard userName.isValidEmail else {
                self.showAlertView(CInvalidEmail, completion: nil)
                return
            }
        }
        
        guard let password = txtPassword.text, !password.isBlank else {
            self.showAlertView(CBlankPassword, completion: nil)
            return
        }
        
        guard password.isValidPassword && password.count >= 6 && password.isPasswordAlphaNumericValid else {
            self.showAlertView(CInvalidPasswordFormat, completion: nil)
            return
        }
  
        self.viewModelUser.logIn(email_or_username: txtUserName.text, password: txtPassword.text, successCompletion: { (userInfo, statusCode, message) in
            
            if statusCode == 4 {
            // show alert to move user on Verify screen
                self.showAlertConfirmationView(message, okTitle: CBtnResend, cancleTitle: CBtnCancel, type: .confirmationView, completion: { (isResendCLK) in
                    if isResendCLK {
                        
                        //...Resend Verification code
                        self.viewModelUser.resendVerification(email: userInfo?.data?.email, successCompletion: { (response, status, message) in
                            if message != nil {
                                if let verifyEmailVc = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                                    verifyEmailVc.userEmail = userInfo?.data?.email
                                    self.navigationController?.pushViewController(verifyEmailVc, animated: false)
                                }
                            }
                        })
                    }
                })
            }else {
                if userInfo != nil {
                    
                    if self.btnRemember.isSelected {
                        // Store remember me status for auto login...
                        CUserDefaults.setValue("true", forKey: UserDefaultRememberMe)
                        CUserDefaults.synchronize()
                    }
                    
                    appDelegate.deviceToken(type: CLoginType, successCompletion: {
                        
                    })
                    appDelegate.initHomeViewController()
                }
            }
        })
    }
    
    @IBAction fileprivate func btnSignUpHereClicked(_ sender: MIGenericButton) {
        
        if let signUpVc = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpVc, animated: true)
        }
    }
    
}
