//
//  VerifyEmailViewController.swift
//  XPTournament
//
//  Created by Mind-00011 on 15/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class VerifyEmailViewController: ParentViewController {
    
    @IBOutlet weak var txtCodeOne: MIGenericTextFiled! {
        didSet{
            txtCodeOne.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var txtCodeTwo: MIGenericTextFiled! {
        didSet{
            txtCodeTwo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var txtCodeThree: MIGenericTextFiled! {
        didSet{
            txtCodeThree.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var txtCodeFour: MIGenericTextFiled! {
        didSet{
            txtCodeFour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    var userEmail: String?
    var viewModelUser = UserViewModel()
    var isSubmitCLK: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isSubmitCLK {
            appDelegate.initLoginViewController()
        }
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = CVerifyEmail
        self.showVerificationPopup(isSendCode: true)
    }
    
    func showVerificationPopup(isSendCode : Bool) {
        
        if let verifyView = VerifyView.initVerifyView() as? VerifyView {
            
            if isSendCode {
                //...For Resend Verification code
                verifyView.imgVLogo.image = UIImage(named: "ic_resendcode_bg")
                verifyView.lblVerify.text = CMessageVerificationCodeSend
                
                _ =  verifyView.vwAlertVerify.setConstraintConstant(CScreenHeight - verifyView.vwAlertVerify.CViewHeight, edge: .top, ancestor: true)
                appDelegate.window.addSubview(verifyView)
                
            } else {
                //...For Verified account
                verifyView.imgVLogo.image = UIImage(named: "ic_verify_email1")
                verifyView.lblVerify.text = CMessageVerifiedAccount
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    _ =  verifyView.vwAlertVerify.setConstraintConstant(CScreenHeight - verifyView.vwAlertVerify.CViewHeight, edge: .top, ancestor: true)
                    appDelegate.window.addSubview(verifyView)
                }, completion: { (completed) in
                })
                
                verifyView.btnOk.touchUpInside { (sender) in
                    appDelegate.deviceToken(type: CLoginType, successCompletion: {
                        
                    })
                    appDelegate.initHomeViewController()
                }
            }
        }
    }
}


//MARK:-
//MARK:- UITextField Delegate

extension VerifyEmailViewController : UITextFieldDelegate{
    
    @objc fileprivate func textFieldDidChange (_ textField : UITextField) {
        
        if textField.text != "" {
            textField.textColor = ColorWhite
            textField.backgroundColor = ColorBlue
            textField.tintColor = ColorWhite
        } else {
            textField.textColor = ColorBlue
            textField.backgroundColor = ColorWhite
            textField.tintColor = ColorBlue
        }
        
        switch textField {
        case txtCodeOne:
            if (textField.text?.isEmpty == false) {
                txtCodeTwo.becomeFirstResponder()
            }
        case txtCodeTwo:
            if (textField.text?.isEmpty == false) {
                txtCodeThree.becomeFirstResponder()
            }else {
               txtCodeOne.becomeFirstResponder()
            }
        case txtCodeThree:
            if (textField.text?.isEmpty == false) {
                txtCodeFour.becomeFirstResponder()
            }else {
                txtCodeTwo.becomeFirstResponder()
            }
        case txtCodeFour:
            if (textField.text?.isEmpty == false) {
                txtCodeFour.resignFirstResponder()
            }else {
                txtCodeThree.becomeFirstResponder()
            }
        default:
            break
        }
        
        if (textField.text?.count)! > 1 {
            //...Set last character of string
            textField.text = String((textField.text?.suffix((textField.text?.count)!-1))!)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //...Change cursor color as per background
        if (textField.text?.count)! > 0 {
            textField.tintColor = ColorWhite
        } else {
            textField.tintColor = ColorBlue
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtCodeFour:
            txtCodeThree.becomeFirstResponder()
        case txtCodeThree:
            txtCodeTwo.becomeFirstResponder()
        case txtCodeTwo:
            txtCodeOne.becomeFirstResponder()
        default:
            break
        }
        
        return true
    }
}

//MARK:-
//MARK:- Action Events

extension VerifyEmailViewController {
    
    @IBAction func btnVerifyClicked(_ sender: MIGenericButton) {
        
        if (txtCodeOne.text?.isBlank)! || ((txtCodeTwo.text?.isBlank)!) || ((txtCodeThree.text?.isBlank)!) || (txtCodeFour.text?.isBlank)! {
            self.showAlertView(CVerityCode, completion: nil)
            return
        }
        
        if let emailInfo = self.userEmail {
            
            let verifyCode = txtCodeOne.text! + txtCodeTwo.text! + txtCodeThree.text! + txtCodeFour.text!
            viewModelUser.verifyUser(email: emailInfo, verifyCode: verifyCode, successCompletion: { (userDetail, statusCode, message) in
                if userDetail != nil {
                    // Store remember me status for auto login...
                    CUserDefaults.setValue("true", forKey: UserDefaultRememberMe)
                    CUserDefaults.synchronize()
                    
                    self.isSubmitCLK = true
                    self.showAlertView(CMessageAccountVerified, completion: { (isOkCLK) in
                        appDelegate.deviceToken(type: CLoginType, successCompletion: {
                            
                        })
                        appDelegate.initHomeViewController()
                    })
                }
            })
        }
        
    }
    
    @IBAction func btnResendCodeClicked(_ sender: MIGenericButton) {
        
        if let emailInfo = self.userEmail {
            viewModelUser.resendVerification(email: emailInfo, successCompletion: { (response, status, message) in
                if message != nil {
                    self.showAlertView(message, completion: nil)
                }
            })
        }
    }
}
