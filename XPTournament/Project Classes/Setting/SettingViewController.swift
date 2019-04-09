//
//  SettingViewController.swift
//  XPTournament
//
//  Created by Mac-00016 on 16/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SettingViewController: ParentViewController {

    @IBOutlet weak var tblVSetting: UITableView!
    
    var arrSettingTitle = [CEditProfileNavTitle,
                           CChangePassword,
                           CAboutUs,
                           CTermsAndConditions,
                           CPrivacyPolicy,
                           CContactUs,
                           CLogout]
    var arrSettingImage = ["ic_setting_user",
                           "ic_setting_change_password",
                           "ic_info",
                           "ic_setting_tc",
                           "ic_setting_pp",
                           "ic_info",
                           "ic_setting_logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods

    func initailize() {
        self.title = CSettings
        self.tblVSetting.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK:-
//MARK:- UITableView Delegate and Datasource Methods

extension SettingViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTblCell") as? SettingTblCell {
            cell.lblSettingTitle.text = "\(arrSettingTitle[indexPath.row])"
            cell.imgvSetting.image = UIImage(named: "\(arrSettingImage[indexPath.row])")
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch "\(arrSettingTitle[indexPath.row])"{
        case CEditProfileNavTitle:
            if let EditProfileVc = CStoryboardSetting.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
                navigationController?.pushViewController(EditProfileVc, animated: true)
            }
        case CChangePassword:
            if let changePasswordVc = CStoryboardSetting.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                navigationController?.pushViewController(changePasswordVc, animated: true)
            }
        case CAboutUs:
            if let cmsVc = CStoryboardSetting.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                cmsVc.cmsType = .aboutUs
                navigationController?.pushViewController(cmsVc, animated: true)
            }
        case CTermsAndConditions:
            if let cmsVc = CStoryboardSetting.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                cmsVc.cmsType = .termsAndConditions
                navigationController?.pushViewController(cmsVc, animated: true)
            }
        case CPrivacyPolicy:
            if let cmsVc = CStoryboardSetting.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                cmsVc.cmsType = .privacyPolicy
                navigationController?.pushViewController(cmsVc, animated: true)
            }
        case CContactUs:
            if let cmsVc = CStoryboardSetting.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                cmsVc.cmsType = .contactUs
                navigationController?.pushViewController(cmsVc, animated: true)
            }
        default:
            showAlertConfirmationView(CMessageLogout, okTitle: CBtnOk, cancleTitle: CBtnCancel, type: .confirmationView) { (result) in

                if result {
                    let token = CUserDefaults.string(forKey: UserDefaultNotificationToken)
                    if token != nil {
                        appDelegate.deviceToken(type: CLogoutType, successCompletion: {
                            appDelegate.logOut()
                        })
                    }else {
                        appDelegate.logOut()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CScreenWidth * 86)/375
    }
    
}
