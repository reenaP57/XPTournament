//
//  APIRequest.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage
import ObjectMapper


//MARK:- ---------BASEURL __ TAG

var BASEURL = "https://itrainacademy.in/xpto-api/api/v1" // ...LIVE
//var BASEURL = "http://192.168.1.155/xpto-api/api/v1/" //...Local


let CAPIVesrion                  = "v1"

let CSignUp = "sign-up"
let CLogin = "login"
let CResendVerification = "resend-verification"
let CVerifyCode = "verifyCode"
let CVerifyUser = "verify-user"
let CForgotPassword = "forgot-password"
let CResetPassword = "reset-password"
let CSaveProfileImage = "save-profile-image"
let CCMS = "cms/"
let CChangePassword = "change-password"
let CEditProfile = "user/edit/profile"
let CUserProfile = "user/view/profile"
let COtherUserProfile = "other/user/view/profile"
let CHome = "home"
let CTournamentList = "tournament/list"
let CTournamentDetail = "tournament/detail"
let CRegisteredTournament = "tournament/register"
let CCheckedInTournament = "tournament/checkedin"
let CViewAllUser = "tournament/user/list"
let CRateExperience = "tournament/rating/save"
let CUpcomingMatches = "tournament/upcoming/matches"
let CScoreCardList = "tournament/score-card"
let CNotification = "notifications"
let CNotificationsRead = "notifications/read"
let CInnerTournamentDetail = "tournament/inner-tournament/detail"
let CUpdateTournamentMatchStatus = "tournament/round/table/win"
let CTournamentBracket     = "tournament/bracket"
let CInnerCurrentlyRunningTournamentDetail  = "tournament/currently-running-tournament/detail"
let CAddRemoveToken = "add/remove/token"

let CJsonResponse           = "response"
let CJsonMessage            = "message"
let CJsonStatus             = "status"
let CStatusCode             = "status_code"
let CJsonTitle              = "title"
let CJsonData               = "data"
let CJsonMeta               = "meta"
let CJsonMessages           = "messages"

let CLimit                  = 7

let CStatusZero             = 0
let CStatusOne              = 1
let CStatusTwo              = 2
let CStatusThree            = 3
let CStatusFour             = 4
let CStatusFive             = 5
let CStatusEight            = 8
let CStatusNine             = 9
let CStatusTen              = 10
let CStatusEleven           = 11

let CStatus200              = 200 // Success
let CStatus400              = 400
let CStatus401              = 401 // Unauthorized
let CStatus500              = 500
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request
let CStatus1009             = -1009 // No Internet
let CStatus1005             = -1005 //Network connection lost


//MARK:- ---------Networking
//MARK:-
typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void

class Networking: NSObject
{
    var BASEURL:String?
    
    var headers:[String: String]
    {
        if appDelegate.loginUser != nil {
            return ["Content-Type":"application/json", "Authorization": "Bearer \((appDelegate.loginUser?.token)!)"]
        }
        return ["Content-Type":"application/json" ]
    }
    
    var loggingEnabled = true
    var activityCount = 0
    
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    override init() {
        super.init()
    }
    
    fileprivate func logging(request req:Request?) -> Void {
        if (loggingEnabled && req != nil) {
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
            
            print("API Request: \(printableString)")
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void {
        if (loggingEnabled && (res != nil))
        {
            if (res?.result.error != nil) {
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
}

//MARK:- ---------Networking Functions
//MARK:-
extension Networking {
    /// Uploading
    
    func upload( _ URLRequest: URLRequestConvertible, multipartFormData: (MultipartFormData) -> Void, encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) -> Void {
        
        let formData = MultipartFormData()
        multipartFormData(formData)
        
        
        var URLRequestWithContentType = try? URLRequest.asURLRequest()
        
        URLRequestWithContentType?.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
        
        let fileManager = FileManager.default
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileName = UUID().uuidString
        
        #if swift(>=2.3)
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #else
        
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #endif
        
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try formData.writeEncodedData(to: fileURL)
            
            DispatchQueue.main.async {
                
                let encodingResult = SessionManager.MultipartFormDataEncodingResult.success(request: SessionManager.default.upload(fileURL, with: URLRequestWithContentType!), streamingFromDisk: true, streamFileURL: fileURL)
                encodingCompletion?(encodingResult)
            }
        } catch {
            DispatchQueue.main.async {
                encodingCompletion?(.failure(error as NSError))
            }
        }
    }
    
    // HTTPs Methods
    func GET(param parameters:[String: AnyObject]?, success:ClosureSuccess?,  failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request(BASEURL!, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func GET(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POST(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POST(param parameters:[String: AnyObject]?, tag:String?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?) -> Void
    {
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            if parameters != nil {
                for (key, value) in parameters! {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
        },  to: (BASEURL! + (tag ?? "")), method: HTTPMethod.post , headers: headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let uRequest, _, _):
                
                self.logging(request: uRequest)
                uRequest.responseJSON { (response) in
                    self.logging(response: response)
                    if(response.result.error == nil) {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject)
                        }
                    } else {
                        if(failure != nil) {
                            failure!(uRequest.task!,nil, response.result.error as NSError?)
                        }
                    }
                }
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
    
    func HEAD(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        let uRequest = SessionManager.default.request(BASEURL!, method: .head, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func PATCH(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        let uRequest = SessionManager.default.request(BASEURL!, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func PUT(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let uRequest = SessionManager.default.request(BASEURL!+tag, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func PUT(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func DELETE(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        let uRequest = SessionManager.default.request(BASEURL!, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    fileprivate func handleResponseStatus(uRequest:DataRequest , success : ClosureSuccess?, failure:ClosureError?) {
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) ) {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            } else {
                if(failure != nil) {
                    
                    if response.result.error != nil {
                        failure!(uRequest.task!,nil, response.result.error as NSError?)
                    }
                    else {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: CJsonMessage) else {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        
                        failure!(uRequest.task!, message, nil)
                    }
                    
                }
            }
        }
        
    }
}



//MARK:- ---------General
//MARK:-
class APIRequest: NSObject {
    
    typealias ClosureCompletion = (_ response:AnyObject?, _ error:NSError?) -> Void
    typealias successCallBack = (([String:AnyObject]?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    private var isInvalidUserAlertDisplaying = false
    
    private override init() {
        super.init()
    }
    
    private static var apiRequest:APIRequest {
        let apiRequest = APIRequest()
        
        if (BASEURL.count > 0 && !BASEURL.hasSuffix("/")) {
            BASEURL = BASEURL + "/"
        }
        
        Networking.sharedInstance.BASEURL = BASEURL
        return apiRequest
    }
    
    static func shared() -> APIRequest {
        return apiRequest
    }
    
    func isJSONDataValid(withResponse response: AnyObject!) -> Bool
    {
        if (response == nil) {
            return false
        }
        
        let data = response.value(forKey: CJsonData)
        
        if !(data != nil) {
            return false
        }
        
        if (data is String) {
            if ((data as? String)?.count ?? 0) == 0 {
                return false
            }
        }
        
        if (data is [Any]) {
            if (data as? [Any])?.count == 0 {
                return false
            }
        }
        
        return self.isJSONStatusValid(withResponse: response)
    }
    
    func isJSONStatusValid(withResponse response: AnyObject!) -> Bool {
        
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            if meta.valueForString(key: CStatusCode).toInt == CStatus200  {
                return  true
            } else {
                return false
            }
        }
        
        if  responseObject?.valueForString(key: CStatusCode).toInt == CStatus200 {
            return  true
        } else {
            return false
        }
    }
    
    func checkResponseStatusAndShowAlert(showAlert:Bool, responseobject: AnyObject?, strApiTag:String) -> Bool
    {
        MILoader.shared.hideLoader()
      
        if let meta = responseobject?.value(forKey: CJsonMeta) as? [String : Any] {
            
            switch meta.valueForInt(key: CJsonStatus) {
            case CStatusOne:
                return true
                
            case CStatusFour:
                return true
                
            case CStatusTen : //register from admin
                return true
                
            case CStatus200 : //register from admin
                return true
                
            default:
                if showAlert {
                    if let message = meta.valueForString(key: CJsonMessage) as? String {
                        CTopMostViewController.showAlertView(message, completion: nil)
                    }
                }
            }
        } else {
            if let status = responseobject?.value(forKey: CJsonStatus) as? Int {
                if status == CStatus401 {
                    if let message = responseobject?.value(forKey: CJsonMessage) as? String {
                        CTopMostViewController.showAlertView(message) { (result) in
                            appDelegate.logOut()
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func actionOnAPIFailure(errorMessage: String?, showAlert: Bool, strApiTag: String,error: NSError?) -> Void {
        if showAlert && errorMessage != nil {
            CTopMostViewController.showAlertView(errorMessage!, completion: nil)
        }
        
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
}


// MARK: - APIs Methods.
// MARK: -
extension APIRequest {
    
    // MARK: - LRF APIs.
    // MARK: -
    
    
//    func propertyMapList(param: [String:Any?], completion : @escaping ClosureCompletion) -> URLSessionTask? {
//
//        return Networking.sharedInstance.POST(apiTag: CAPITagProperties, param: param as [String : AnyObject], successBlock: { (task, response) in
//            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CAPITagProperties) {
//                if let responseDict = response as? [String:Any] , responseDict.keys.count > 0 {
//                    // Create property map data model
//                    if let propertyLocation = Mapper<MapViewPropertyModel>().map(JSON: responseDict) {
//                        completion(propertyLocation as AnyObject, nil)
//                    }
//                }
//            }
//
//        }, failureBlock: { (task, message, error) in
//            MILoader.shared.hideLoader()
//            completion(nil, error)
//            if error?.code == CStatus1009 || error?.code == CStatus1005 {
//            } else {
//                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProperties, error: error)
//            }
//        })
//    }
    
    func logIn(email_or_username: String?, password : String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        return Networking.sharedInstance.POST(apiTag: CLogin, param: ["email_or_username" : email_or_username as AnyObject, "password" : password as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CLogin) {
                
                if let responseDict = response as? [String: Any] , responseDict.keys.count > 0 {
                    if let meta = responseDict[CJsonMeta] as? [String: Any] {
                        if meta.valueForInt(key: CJsonStatus) == CStatusFour || meta.valueForInt(key: CJsonStatus) == CStatusZero {
                            // Account is not verified yet..
                            completion(response, nil)
                        } else {
                            if let userDetail = Mapper<UserModel>().map(JSON: responseDict) {
                                completion(userDetail as AnyObject, nil)
                            }
                        }
                    }
                }
            }
   
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CLogin, error: error)
            }
        })
    }
    
    func signUp(fullName: String?, email: String?, mobileNo: String?, userName: String?, password: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        return Networking.sharedInstance.POST(apiTag: CSignUp, param: ["fullName": fullName as AnyObject, "email": email as AnyObject, "mobileNo": mobileNo as AnyObject, "userName": userName as AnyObject, "password": password as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CSignUp) {
                if let responseDict = response as? [String: Any] , responseDict.keys.count > 0 {
                    if let userDetail = Mapper<UserModel>().map(JSON: responseDict) {
                        completion(userDetail as AnyObject, nil)
                    }
                }
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CSignUp, error: error)
            }
        })
        
    }
    
    func saveProfileImage(userId: String?, image: UIImage? , completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        var imgData = Data()
        if image != nil{
            imgData = (image?.jpegData(compressionQuality: 0.9))!
        }
        
        _ = Networking.sharedInstance.POST(param: ["userId": userId as AnyObject], tag: CSaveProfileImage, multipartFormData: { (formData) in
            
            if imgData.count != 0 {
                formData.append(imgData, withName: "image", fileName:  String(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000), mimeType: "image/jpeg")
            }
        }, success: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: response as AnyObject, strApiTag: CSaveProfileImage) {
                if let responseDict = response as? [String: Any] , responseDict.keys.count > 0 {
                    completion(response, nil)
                }
            }
        }, failure: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CSaveProfileImage, error: error)
            }
        })
    }
    
    func verifyUser(email: String?, verifyCode: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        return Networking.sharedInstance.POST(apiTag: CVerifyUser, param:  ["email": email as AnyObject, "verifyCode": verifyCode as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CVerifyUser) {
                if let responseDict = response as? [String: Any] , responseDict.keys.count > 0 {
                    if let userDetail = Mapper<UserModel>().map(JSON: responseDict) {
                        completion(userDetail as AnyObject, nil)
                    }
                }
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CVerifyUser, error: error)
            }
        })
    }
    
    
    func resendVerification(email: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
    
        return Networking.sharedInstance.POST(apiTag: CResendVerification, param: ["email" : email as AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CResendVerification) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CResendVerification, error: error)
            }
        })
    }
    
    func forgotPassword(email: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        return Networking.sharedInstance.POST(apiTag: CForgotPassword, param: ["email": email as AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CForgotPassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CForgotPassword, error: error)
            }
        })
    }
    
    func resetPassword(email: String?, verifyCode: String?, password: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        return Networking.sharedInstance.POST(apiTag: CResetPassword, param: ["email": email as AnyObject, "verifyCode": verifyCode as AnyObject, "password": password as AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CResetPassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CResetPassword, error: error)
            }
        })
    }
    
    func changePassword(oldPwd: String?, newPwd: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        return Networking.sharedInstance.POST(apiTag: CChangePassword, param: ["oldPassword": oldPwd as AnyObject, "password": newPwd as AnyObject], successBlock: { (task, response) in
          
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CResetPassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CChangePassword, error: error)
            }
        })
    }
    
    
    // MARK: - USER APIs.
    // MARK: -
    func editProfile(dict: [String: AnyObject], completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        return Networking.sharedInstance.POST(apiTag: CEditProfile, param: dict, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CEditProfile) {
                if let responseDic = response as? [String : AnyObject], responseDic.keys.count > 0 {
                    if let userDetail = Mapper<UserModel>().map(JSON: responseDic) {
                        completion(userDetail as AnyObject, nil)
                    }
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CEditProfile, error: error)
            }
        })!
    }
    
    func userProfile(completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CUserProfile, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CUserProfile) {
                if let responseDic = response as? [String : AnyObject], responseDic.keys.count > 0 {
                    let userDetail = Mapper<UserModel>().map(JSON: responseDic)
                    completion(userDetail as AnyObject, nil)
                }
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CUserProfile, error: error)
            }
        })!
    }
    
    func otherUserProfile(userID: Int?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
       _ = Networking.sharedInstance.POST(apiTag: COtherUserProfile, param: ["id": userID as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: COtherUserProfile) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let userDetail = Mapper<UserModel>().map(JSON: responseDic)
                    completion(userDetail as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: COtherUserProfile, error: error)
            }
        })
    }
    
    // MARK: - CMS APIs.
    // MARK: -
    func loadCMS(cmsType: String?, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        return Networking.sharedInstance.POST(apiTag: CCMS + cmsType!, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CCMS) {
                if let responseDict = response as? [String: Any] , responseDict.keys.count > 0 {
                    if let cmsDetail = Mapper<CMSModel>().map(JSON: responseDict.valueForJSON(key: CJsonData) as! [String: Any]) {
                       completion(cmsDetail as AnyObject, nil)
                    }
                }
                completion(response as AnyObject, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CCMS, error: error)
            }
        })!
    }
    
    // MARK: - TOURNAMENT APIs.
    // MARK: -
    func getHomeList(isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CHome, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CHome) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0  {
                    let tournamentList = Mapper<TournamentModel>().map(JSON: responseDic.valueForJSON(key: CJsonData) as! [String: Any])
                    completion(tournamentList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CHome, error: error)
            }
        })!
    }
    
    func getTournamentList(type: Int?, search: String?, page: Int?, isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CTournamentList, param: ["type": type as AnyObject, "search": search as AnyObject, CPage: page as AnyObject, CPerPage: CLimit as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CTournamentList) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0  {
                    let tournamentList = Mapper<TournamentListModel>().map(JSON: responseDic)
                    completion(tournamentList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CTournamentList, error: error)
            }
        })!
    }
    
    func getTournamentDetail(tournamentID: Int?, isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CTournamentDetail, param: ["tournamentId": tournamentID as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CTournamentDetail) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let tournamentDetail = Mapper<TournamentDetailModel>().map(JSON: responseDic.valueForJSON(key: CJsonData) as! [String: Any])
                    completion(tournamentDetail as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CTournamentDetail, error: error)
            }
        })!
    }
    
    func getCompletedAndLiveRoundDetail(tournamentID: Int?, type: Int?, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CInnerTournamentDetail, param: ["tournamentId": tournamentID as AnyObject, "type": type as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CInnerTournamentDetail) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let roundInfo = Mapper<CompletedAndLiveRoundModel>().map(JSON: responseDic)
                    completion(roundInfo as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CInnerTournamentDetail, error: error)
            }
        })!
    }
    
    func getCompletedAndLiveRoundForCurrentlyRunning (tournamentID: Int?, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CInnerCurrentlyRunningTournamentDetail, param: ["tournamentId": tournamentID as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CInnerCurrentlyRunningTournamentDetail) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let roundInfo = Mapper<CurrentlyRunningDetailModel>().map(JSON: responseDic)
                    completion(roundInfo as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CInnerCurrentlyRunningTournamentDetail, error: error)
            }
        })!
    }
    
    func registerTournament(tournamentID: Int?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        _ = Networking.sharedInstance.POST(apiTag: CRegisteredTournament, param: ["tournamentId": tournamentID as AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CRegisteredTournament) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let registerInfo = Mapper<RegisterUserModel>().map(JSON: responseDic)
                    completion(registerInfo as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CRegisteredTournament, error: error)
            }
        })!
    }
    
    func checkInTournament(tournamentID: Int?,completion: @escaping ClosureCompletion) {
        _ = Networking.sharedInstance.POST(apiTag: CCheckedInTournament, param: ["tournamentId": tournamentID as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CCheckedInTournament) {
                
                if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CCheckedInTournament) {
                    completion(response as AnyObject, nil)
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CCheckedInTournament, error: error)
            }
        })
    }
    
    func getUpcomingMatches(isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CUpcomingMatches, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CUpcomingMatches) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let upcomingMatchesList = Mapper<UpcomingMatchesModel>().map(JSON: responseDic)
                    completion(upcomingMatchesList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CUpcomingMatches, error: error)
            }
        })!
    }
    
    func getScoreCardList(tournamentID: Int?, isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CScoreCardList, param: ["tournamentId": tournamentID as AnyObject, "userId": appDelegate.loginUser?.id as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CScoreCardList) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let scoreCardList = Mapper<ScoreCardModel>().map(JSON: responseDic.valueForJSON(key: CJsonData) as! [String: Any])
                    completion(scoreCardList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CScoreCardList, error: error)
            }
        })!
    }
    
    func getTournamentBracketList(tournamentID: Int?, type: Int?, isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CTournamentBracket, param: ["tournamentId": tournamentID as AnyObject, "tournamentType": type as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CTournamentBracket) {
                
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    if let bracketList = Mapper<TournamentBracketModel>().map(JSON: responseDic) {
                        completion(bracketList as AnyObject, nil)
                    }
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CTournamentBracket, error: error)
            }
        })!
    }
    
    func updateTournamentWinLossTieStatus(tournamentID: Int?, status:Int?, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CUpdateTournamentMatchStatus, param: ["id": tournamentID as AnyObject, "winStatus": status as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CUpdateTournamentMatchStatus) {
                completion(response as AnyObject, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CUpdateTournamentMatchStatus, error: error)
            }
        })
    }
    
    func viewAllUser(tournamentID: Int?, search: String?, isShowLoader: Bool?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CViewAllUser, param: ["tournamentId": tournamentID as AnyObject, "search": search as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CViewAllUser) {
                
                if let responseDic = response as? [String: AnyObject], responseDic.keys.count > 0 {
                    let userList = Mapper<TournamentAllUserModel>().map(JSON: responseDic)
                    completion(userList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CViewAllUser, error: error)
            }
        })!
    }
    
    func rateYourExperience(tournamentId: Int?, playingRating: Double?, recommPlayingRating: Double?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        
        _ = Networking.sharedInstance.POST(apiTag: CRateExperience, param: ["tournamentId": tournamentId as AnyObject, "playingRating": playingRating as AnyObject, "recommRating": recommPlayingRating as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CRateExperience) {
                
                if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CRateExperience) {
                    completion(response as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CRateExperience, error: error)
            }
        })!
    }
    
    func getNotificationList(isShowLoader: Bool?, page: Int?, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        if isShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CNotification, param: ["page": page as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CNotification) {
                if let responseDic = response as? [String: Any], responseDic.keys.count > 0 {
                    let notificationList = Mapper<NotificationListModel>().map(JSON: responseDic)
                    completion(notificationList as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CNotification, error: error)
            }
        })!
    }
    
    func readNotification(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CNotificationsRead, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CNotificationsRead) {
                
                if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CNotificationsRead) {
                    completion(response as AnyObject, nil)
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CNotificationsRead, error: error)
            }
        })
    }
    
    func addRemoveToken(type: Int, completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        var param = [String: Any]()
        param["type"] = type
        param["device_type"] = 2
        param["device_token"] = CUserDefaults.string(forKey: UserDefaultNotificationToken)
        param["user_id"] = appDelegate.loginUser?.id
        
        if type == 2 {
            MILoader.shared.showLoader(type: .circularRing, message: nil)
        }
        
        return Networking.sharedInstance.POST(apiTag: CAddRemoveToken, param: param as [String: AnyObject], successBlock: { (task, response) in

            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response as AnyObject, strApiTag: CAddRemoveToken) {

                if let responseDic = response as? [String: AnyObject], responseDic.keys.count > 0 {
                    completion(responseDic as AnyObject, nil)
                }
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAddRemoveToken, error: error)
            }
        })!
    }
}
