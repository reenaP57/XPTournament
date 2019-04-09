//
//  RegisterTournamentViewController.swift
//  XPTournament
//
//  Created by mac-0005 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RegisterTournamentViewController: ParentViewController {

    @IBOutlet var scrollVw : UIScrollView!
    @IBOutlet var imgTournament : UIImageView!
    @IBOutlet var lblTournamentTitle  : UILabel!
    @IBOutlet var lblTournamentType  : UILabel!
    @IBOutlet var lblDesc  : UILabel!
    @IBOutlet var lblDate  : UILabel!
    @IBOutlet var lblTime  : UILabel!
    @IBOutlet var lblDuration  : UILabel!
    @IBOutlet var lblEntryFee  : UILabel!
    @IBOutlet var lblTotalPlayer  : UILabel!
    @IBOutlet var lblLocation  : UILabel!
    @IBOutlet var btnRegister : UIButton!
    
    var viewModelTournamentDetail = TournamentDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    // MARK:- --------Initialization
    func Initialization(){
        if viewModelTournamentDetail.tournamentInfo?.isRegister == 0 {
            self.title = COpenForRegistration
        } else {
            self.title = CMyTournament
        }
        
        //...Load tournament detail from server
        self.loadTournamentDetail(isShowLoader: true)
    }
    
    fileprivate func setTournamentDetail() {
        imgTournament.loadImageFromUrl(viewModelTournamentDetail.tournamentInfo?.image, isPlaceHolderUser: false)
        lblTournamentTitle.text = viewModelTournamentDetail.tournamentInfo?.title
        lblTournamentType.text = viewModelTournamentDetail.tournamentInfo?.tournamentType == CSwissType ? CSwissTournamentType : CEliminationTournamentType
        lblDesc.text = viewModelTournamentDetail.tournamentInfo?.description
        lblTotalPlayer.text = "\(viewModelTournamentDetail.tournamentInfo?.registeredPlayers ?? 0)"
        lblLocation.text = viewModelTournamentDetail.tournamentInfo?.venue
        lblDuration.text = "\(viewModelTournamentDetail.tournamentInfo?.duration ?? 0) mins"
        lblEntryFee.text = viewModelTournamentDetail.tournamentInfo?.entryType == CPaidEntry ? "$\(viewModelTournamentDetail.tournamentInfo?.entryFees ?? 0)" : CFree
        lblDate.text =  DateFormatter.dateStringFrom(timestamp: viewModelTournamentDetail.tournamentInfo?.startDate, withFormate: "dd MMM, yyyy")
        lblTime.text = DateFormatter.dateStringFrom(timestamp: viewModelTournamentDetail.tournamentInfo?.startDate, withFormate: "hh:mm a")
        
        // btnRegister Enable disable
        if viewModelTournamentDetail.tournamentInfo?.isRegister == CRegisterZero {
            
            // btnRegister Enable .. Btn Title Will Be Register
            btnRegister.isUserInteractionEnabled = true
            btnRegister.alpha = 1.0
            btnRegister.isSelected = false
        } else {
            
             //...If already registered tournament that time Check-in button will be disabled and it will get enable before 24 hours for tournament time ... Btn title will be Checkin
            
            btnRegister.isSelected = true
            if viewModelTournamentDetail.tournamentInfo?.checkInStatus == 0 && viewModelTournamentDetail.tournamentInfo?.isCheckIn == CCheckInZero {
                // BtnCheckIn Enable
                btnRegister.isUserInteractionEnabled = true
                btnRegister.alpha = 1.0
            } else {
                //Btn CheckIn Disable
                btnRegister.isUserInteractionEnabled = false
                btnRegister.alpha = 0.5
            }
        }
    }
}

//MARK:-
//MARK:- Action Event

extension RegisterTournamentViewController{
    @IBAction func btnZoomImageCLK(_ sender : UIButton){
        self.zoomGSImageViewer(self.imgTournament)
    }
    
    @IBAction func btnRegisterCLK(_ sender : UIButton){
        if !sender.isSelected {
            self.registerTournament()
        } else {
            self.checkInTournament()
        }
        
    }
}

//MARK:-
//MARK:- API Method

extension RegisterTournamentViewController {
    
    // Get Tournament Detail
    fileprivate func loadTournamentDetail(isShowLoader: Bool) {
        scrollVw.isHidden = true
        viewModelTournamentDetail.getTournamentDetail(tournamentID: viewModelTournamentDetail.tournamentID, isShowLoader: isShowLoader) {
            self.scrollVw.isHidden = false
            self.setTournamentDetail()
        }
    }
    
    // Register Tournament
    fileprivate func registerTournament() {

        viewModelTournamentDetail.registeredTournament(tournamentID: viewModelTournamentDetail.tournamentID) {
            if self.viewModelTournamentDetail.registerUserModel?.status == CStatusOne {
                self.showAlertView(self.viewModelTournamentDetail.registerUserModel?.message, completion: nil)
                
                self.btnRegister.isSelected = true
                
                if self.viewModelTournamentDetail.registerUserModel?.checkInStatus == 0 && self.viewModelTournamentDetail.registerUserModel?.isCheckIn == CCheckInZero  {
                    
                    // BtnCheckIn Enable
                    self.btnRegister.isUserInteractionEnabled = true
                    self.btnRegister.alpha = 1.0
                    
                } else {
                    // btnCheckIn Disable
                    self.btnRegister.isUserInteractionEnabled = false
                    self.btnRegister.alpha = 0.5
                }
            }
            
        }
    }
    
    // Check-In Tournament
    fileprivate func checkInTournament() {

        viewModelTournamentDetail.checkedInTournament(tournamentID: viewModelTournamentDetail.tournamentID) { (response, status, message) in
            if (status == CStatusOne) {
                self.btnRegister.alpha = 0.5
                self.btnRegister.isUserInteractionEnabled = false
                self.showAlertView(message, completion: nil)
            }
        }
    }
}
