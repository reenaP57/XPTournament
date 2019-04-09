//
//  ApplicationConstants.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit


//MARK:- Fonts
enum CPoppinsFontType:Int {
    case black
    case blackItalic
    case bold
    case boldItalic
    case light
    case extraLight
    case extraLightItalic
    case italic
    case lightItalic
    case thin
    case thinItalic
    case extraBold
    case extraBoldItalic
    case semibold
    case semiboldItalic
    case meduim
    case meduimItalic
    case regular
}

enum CRubikFontType:Int {
    case black
    case bold
    case light
    case meduim
    case regular
}

func CFontRubik(size: CGFloat, type: CRubikFontType) -> UIFont {
    
    switch type {
    case .black:
         return UIFont.init(name: "Rubik-Black", size: size)!
    case .bold:
        return UIFont.init(name: "Rubik-Bold", size: size)!
    case .light:
        return UIFont.init(name: "Rubik-Light", size: size)!
    case .meduim:
        return UIFont.init(name: "Rubik-Medium", size: size)!
    case .regular:
        return UIFont.init(name: "Rubik-Regular", size: size)!
    }
}

func CFontPoppins(size: CGFloat, type: CPoppinsFontType) -> UIFont {
    switch type {
    case .black:
        return UIFont.init(name: "Poppins-Black", size: size)!
        
    case .blackItalic:
        return UIFont.init(name: "Poppins-BlackItalic", size: size)!
        
    case .bold:
        return UIFont.init(name: "Poppins-Bold", size: size)!
        
    case .boldItalic:
        return UIFont.init(name: "Poppins-BoldItalic", size: size)!
        
    case .extraBold:
        return UIFont.init(name: "Poppins-ExtraBold", size: size)!
        
    case .extraBoldItalic:
        return UIFont.init(name: "Poppins-ExtraBoldItalic", size: size)!
        
    case .extraLight:
        return UIFont.init(name: "Poppins-ExtraLight", size: size)!
        
    case .extraLightItalic:
        return UIFont.init(name: "Poppins-ExtraLightItalic", size: size)!
        
    case .italic:
        return UIFont.init(name: "Poppins-Italic", size: size)!
        
    case .light:
        return UIFont.init(name: "Poppins-Light", size: size)!
        
    case .lightItalic:
        return UIFont.init(name: "Poppins-LightItalic", size: size)!
        
    case .meduim:
        return UIFont.init(name: "Poppins-Medium", size: size)!
        
    case .meduimItalic:
        return UIFont.init(name: "Poppins-MediumItalic", size: size)!
        
    case .regular:
        return UIFont.init(name: "Poppins-Regular", size: size)!
        
    case .semibold:
        return UIFont.init(name: "Poppins-SemiBold", size: size)!
        
    case .semiboldItalic:
        return UIFont.init(name: "Poppins-SemiBoldItalic", size: size)!
        
    case .thin:
        return UIFont.init(name: "Poppins-Thin", size: size)!
        
    case .thinItalic:
        return UIFont.init(name: "Poppins-ThinItalic", size: size)!
    }
}


let PASSWORDALLOWCHAR = "!@#$%ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

//MARK:- Notification Constants
let NotificationDidUpdateUserDetail     = "NotificationDidUpdateUserDetail"

//MARK:- UserDefaults
let UserDefaultiPadAuthCode               = "UserDefaultiPadAuthCode"
let UserDefaultGeneralDataLoaded          = "UserDefaultGeneralDataLoaded"
let UserDefaultUserID                     = "UserDefaultUserID"
let UserDefaultRememberMe                     = "UserDefaultRememberMe"
let UserDefaultNotificationToken           = "UserDefaultNotificationToken"

//MARK:- Color
let ColorShadow         = CRGBA(r: 0, g: 0, b: 0, a: 0.09)
let ColorBlack          = CRGB(r: 0, g: 0, b: 0)
let ColorWhite          = CRGB(r: 255, g: 255, b: 255)
let ColorGray           = CRGB(r: 235, g: 235, b: 235)
let ColorBlue           = CRGB(r: 59, g: 104, b: 252)
let ColorLightBlack     = CRGB(r: 51, g: 51, b: 51)
let ColorDarkGray       = CRGB(r: 82, g: 82, b: 82)

//MARK:- UIStoryboard
let CStoryboardLRF = UIStoryboard(name: "LRF", bundle: nil)
let CStoryboardTournament = UIStoryboard(name: "Tournament", bundle: nil)
let CStoryboardTournamentDetails = UIStoryboard(name: "TournamentDetails", bundle: nil)
let CStoryboardSetting = UIStoryboard(name: "Setting", bundle: nil)

//MARK:- Application Language
let CLanguageEnglish           = "en"
let CLanguageArabic            = "ar"

func CLocalize(text: String) -> String {
    return Localization.sharedInstance.localizedString(forKey: text , value: text)
}


//MARK:- Setting screeen
let CEditProfileNavTitle             = "Edit Profile"
let CChangePasswordNavTitle          = "Change Password"
let CAboutUs                 = "About Us"
let CTermsAndConditions      = "Terms & Conditions"
let CPrivacyPolicy           = "Privacy Policy"
let CContactUs               = "Contact Us"
let CLogout                  = "Logout"

let CPage                = "page"
let CPerPage             = "per_page"

let CSwissType  = 1
let CEliminationType  = 2

let CFreeEntry  = 1
let CPaidEntry  = 2

let CTypeMyTournament  = 1
let CTypeOpenForRegistration  = 2
let CTypeCurrentlyRunning  = 3

let CWin   = 1
let CLoss  = 2
let CTie   = 3

let CLoginType  = 1
let CLogoutType = 2

let CCheckInZero = 0
let CCheckInOne = 1

let CRegisterZero = 0
let CRegisterOne = 1
