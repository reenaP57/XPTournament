//
//  SignUpViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 14/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SignUpViewController: ParentViewController {

    @IBOutlet weak var imgVProfile: UIImageView!{
        didSet{
            imgVProfile.layer.cornerRadius = 15
            imgVProfile.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var txtFullName: MIGenericTextFiled!
    @IBOutlet weak var txtEmail: MIGenericTextFiled!
    @IBOutlet weak var txtPhoneNumber: MIGenericTextFiled!
    @IBOutlet weak var txtUserName: MIGenericTextFiled!
    @IBOutlet weak var txtPassword: MIGenericTextFiled!
    @IBOutlet weak var txtConfirmPassword: MIGenericTextFiled!
    @IBOutlet weak var btnTermsCondition: UIButton!

    var viewModelUser = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
    }

}

//MARK:-
//MARK:- Action Events

extension SignUpViewController {
    
    @IBAction func btnProfileClicked(_ sender: UIButton) {
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            if image != nil {
                self.imgVProfile.image = image
            }
        }
    }
    
    @IBAction func btnAgreeClicked(_ sender: UIButton) {
        btnTermsCondition.isSelected = !sender.isSelected
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        
        guard let fullName = txtFullName.text, !fullName.isBlank else {
            self.showAlertView(CBlankFullName, completion: nil)
            return
        }
        guard let email = txtEmail.text, !email.isBlank else {
            self.showAlertView(CBlankEmail, completion: nil)
            return
        }
        guard email.isValidEmail else {
            self.showAlertView(CInvalidEmail, completion: nil)
            return
        }
        guard let phonenumber = txtPhoneNumber.text, !phonenumber.isBlank else {
            self.showAlertView(CBlankPhoneNumber, completion: nil)
            return
        }
        guard phonenumber.count == 10 else {
            self.showAlertView(CInvalidPhoneNumberFormat, completion: nil)
            return
        }
        guard let userName = txtUserName.text, !userName.isBlank else {
            self.showAlertView(CBlankUserName, completion: nil)
            return
        }
        guard let password = txtPassword.text, !password.isBlank else {
            self.showAlertView(CBlankPassword, completion: nil)
            return
        }
        guard password.isValidPassword && password.count >= 6 && password.isPasswordAlphaNumericValid else {
            self.showAlertView(CInvalidPasswordFormat, completion: nil)
            return
        }
        guard let confirmPassword = txtConfirmPassword.text, !confirmPassword.isBlank else {
            self.showAlertView(CBlankConfirmPassword, completion: nil)
            return
        }
        guard confirmPassword == password else {
            self.showAlertView(CPasswordConfirmPasswordMisMatch, completion: nil)
            return
        }
        guard btnTermsCondition.isSelected else {
            self.showAlertView(CAcceptTermsCondition, completion: nil)
            return
        }
        
        self.showAlertConfirmationView("\(CConfirmEmailAndMobile)\n\(self.txtEmail.text ?? ""),\n\(self.txtPhoneNumber.text ?? "")", okTitle: CBtnConfirm, cancleTitle: CBtnCancel, type: .confirmationView) { (result) in
            if result {
                self.signUp()
            }
        }
    }
    
    @IBAction func btnLoginHereClicked(_ sender: MIGenericButton) {
        navigationController?.popViewController(animated: true)
    }
}


//MARK:- API function
//MARK:-

extension SignUpViewController {
    
    func redirectToVerificationScreen() {
        if let verifyEmailVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
            verifyEmailVC.userEmail = self.txtEmail.text
            self.navigationController?.pushViewController(verifyEmailVC, animated: false)
        }
    }
    
    func signUp() {
        self.viewModelUser.signUp(fullName: self.txtFullName.text, email: self.txtEmail.text, mobileNo: self.txtPhoneNumber.text, userName: self.txtUserName.text, password: self.txtPassword.text, successCompletion: { (userInfo, status, message) in
            
            if self.imgVProfile.image != nil {
                self.uploadUserProfilePicture(userId: (userInfo?.data?.id)!)
            }else {
                self.redirectToVerificationScreen()
            }
        })
    }
    
    func uploadUserProfilePicture(userId : Int64) {
        self.viewModelUser.saveProfileImage(userId: "\(userId)", image: imgVProfile.image, successCompletion: { (response, statusCode, message) in
            self.redirectToVerificationScreen()
        })
    }
}

