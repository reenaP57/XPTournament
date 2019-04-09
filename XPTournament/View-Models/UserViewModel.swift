//
//  UserViewModel.swift
//  XPTournament
//
//  Created by mac-0005 on 16/01/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

typealias successCompletion = ((_ response: UserModel? , _ status: Int?, _ message: String?) -> ())?
typealias failureCompletion = ((_ response: Any? , _ status: Int?, _ message: String) -> ())?

class UserViewModel {
    
    // MARK: - Global Variables.
    // MARK: -
    
}

// MARK: - Api Functions
// MARK: -
extension UserViewModel {
    // login
    func logIn(email_or_username: String?, password: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().logIn(email_or_username: email_or_username, password: password, completion: { (response, error) in
           
            if (response != nil && error == nil) {
                
                if let meta = response?[CJsonMeta] as? [String: Any] {
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusFour:
                        // Account is not verified yet.
                        if let userDetail = Mapper<UserModel>().map(JSON: (response as? [String: Any])!) {
                            successCompletion?(userDetail, meta.valueForInt(key: CJsonStatus), meta.valueForString(key: CJsonMessage))
                        }
                        
                    case CStatusZero:
                        CTopMostViewController.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        
                    case CStatusOne:
                        if let userInfo = response as? UserModel {
                            self.saveUserInfoToLocal(user: userInfo)
                            successCompletion?(userInfo, meta.valueForInt(key: CJsonStatus), "")
                        }
                        
                    default:
                        break
                    }
                } else {
                    if let userInfo = response as? UserModel {
                        self.saveUserInfoToLocal(user: userInfo)
                        successCompletion?(userInfo, 1, "")
                    }
                }
            }
        })
    }
    
    // SignUp
    func signUp(fullName: String?, email: String?, mobileNo: String?, userName: String?, password: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().signUp(fullName: fullName, email: email, mobileNo: mobileNo, userName: userName, password: password, completion: { (response, error) in
            if (response != nil && error == nil) {
                
                if let meta = response?[CJsonMeta] as? [String: Any] {
                    if let userInfo = response as? UserModel {
                        successCompletion?(userInfo, meta.valueForInt(key: CJsonStatus), "")
                    } else {
                        successCompletion?(nil, meta.valueForInt(key: CJsonStatus), "")
                    }
                }
            }
        })
    }
    
    // Upload Profile image
    func saveProfileImage(userId: String?, image: UIImage?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().saveProfileImage(userId: userId, image: image, completion: { (response, error) in
            if response != nil && error == nil {
                
                if let responseDict = response as? [String: Any] {
                    if let data = responseDict[CJsonData] as? [String: Any] {
                        appDelegate.loginUser?.image = data.valueForString(key: "image")
                    }
                }
                successCompletion?(nil, 0, "")
            }
        })
    }
    
    
    // Verify User
    func verifyUser(email: String?, verifyCode: String?, successCompletion: successCompletion) {
        _ = APIRequest.shared().verifyUser(email: email, verifyCode: verifyCode, completion: { (response, error) in
            if response != nil && error == nil {
                if let userInfo = response as? UserModel {
                    self.saveUserInfoToLocal(user: userInfo)
                    successCompletion?(userInfo, 0, "")
                }
            }
        })
    }
    
    // Resend Verification code
    func resendVerification(email: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().resendVerification(email: email, completion: { (response, error) in
            if let responseDic = response as? [String: Any] {
                if let meta = responseDic[CJsonMeta] as? [String: Any] {
                    successCompletion?(nil, 0, meta.valueForString(key: CJsonMessage))
                }
            }
        })
    }
    
    // Forgot Password
    func forgotPassword(email: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().forgotPassword(email: email, completion: { (response, error) in
            if response != nil && error == nil {
                if let responseDic = response as? [String: Any] {
                    if let meta = responseDic[CJsonMeta] as? [String: Any] {
                        successCompletion?(nil, 0, meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        })
    }
    
    // Reset Password
    func resetPassword(email: String?, verifyCode: String?, password: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().resetPassword(email: email, verifyCode: verifyCode, password: password, completion: { (response, error) in
            if response != nil {
                if let responseDic = response as? [String: Any] {
                    if let meta = responseDic[CJsonMeta] as? [String: Any] {
                        successCompletion?(nil, 0, meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        })
    }
    
    //Change Password
    func changePassword(oldPwd: String?, newPwd: String?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().changePassword(oldPwd: oldPwd, newPwd: newPwd, completion: { (response, error) in
            if response != nil && error == nil {
                if let responseDic = response as? [String: Any] {
                    if let meta = responseDic[CJsonMeta] as? [String: Any] {
                        successCompletion?(nil, 0, meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        })
    }
    
    //Edit Profile
    func editProfile(dict: [String: AnyObject], successCompletion: successCompletion) {
        
        _ = APIRequest.shared().editProfile(dict: dict
            , completion: { (response, error) in
                if response != nil && error == nil {
                    
                    if let userInfo = response as? UserModel {
                        self.saveUserInfoToLocal(user: userInfo)
                        successCompletion?(userInfo, 0, "")
                    }
                }
        })
    }
    
    //User Profile
    func userProfile(successCompletion: successCompletion) {
        
        _ = APIRequest.shared().userProfile(completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let userInfo = response as? UserModel {
                    self.saveUserInfoToLocal(user: userInfo)
                    successCompletion?(userInfo, 0, "")
                }
            }
        })
    }
    
    //Other User Profile
    func otherUserProfile(userID: Int?, successCompletion: successCompletion) {
        
        _ = APIRequest.shared().otherUserProfile(userID: userID, completion: { (response, error) in
            
            if (response != nil && error == nil) {
                if let userDetail = response as? UserModel {
                    successCompletion?(userDetail, 0, "")
                }
            }
        })
    }
}

// MARK: - Core Data
// MARK: -
extension UserViewModel {
    func saveUserInfoToLocal(user: UserModel?) {
        
        if let userInfo = user {
            
            let tblUser  = TblUser.findOrCreate(dictionary: ["id": (userInfo.data?.id)!]) as! TblUser
            tblUser.fullName = userInfo.data?.fullName
            tblUser.email = userInfo.data?.email
            tblUser.userName = userInfo.data?.userName
            tblUser.mobileNo = userInfo.data?.mobileNo
            tblUser.isNotify = (userInfo.data?.isNotify)!
            tblUser.image = userInfo.data?.image
            tblUser.qrCode = userInfo.data?.qrCode
            tblUser.totalTournament = (userInfo.data?.totalTournament)!
            tblUser.avgRating = (userInfo.data?.avgRating)!
            
            if let token = userInfo.meta?.token {
                tblUser.token = token
            }
            
            
            CUserDefaults.setValue(userInfo.data!.id, forKey: UserDefaultUserID)
            CUserDefaults.synchronize()
            
            appDelegate.loginUser = tblUser
            CoreData.saveContext()
        }
        
    }
}
