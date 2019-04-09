//
//  ForgotPasswordViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 14/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: ParentViewController {

    @IBOutlet weak var txtEmail: MIGenericTextFiled!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CForgotPasswordTitle
    }
   
}

//MARK:-
//MARK:- Action Events

extension ForgotPasswordViewController {
    
    @IBAction func btnSubmitClicked(_ sender: MIGenericButton) {
        
        guard let email = txtEmail.text, !email.isBlank else {
            self.showAlertView(CBlankEmail, completion: nil)
            return
        }
        guard email.isValidEmail else {
            self.showAlertView(CInvalidEmail, completion: nil)
            return
        }
        
        self.forgotPassword()
    }
}


//MARK:-
//MARK:- API Function

extension ForgotPasswordViewController {
    
    func forgotPassword() {
        
        let viewModelUser = UserViewModel()
        viewModelUser.forgotPassword(email: txtEmail.text, successCompletion: { (response, statusCode, message) in
            
            self.showAlertView(message, completion: nil)
            
            if let resetPasswordVc = CStoryboardLRF.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
                resetPasswordVc.userEmail = self.txtEmail.text
                self.navigationController?.pushViewController(resetPasswordVc, animated: true)
            }
        })
    }
}
