//
//  ApplicationMessages.swift
//  NetRealty
//
//  Created by mac-0007 on 13/07/18.
//  Copyright © 2018 mac-0007. All rights reserved.
//

import Foundation

//MARK:- GENERAL

var CNA : String {return CLocalize(text: "NA")}
var CWinMatchStatus : String {return CLocalize(text: "W")}
var CLostMatchStatus : String {return CLocalize(text: "L")}
var CTieMatchStatus : String {return CLocalize(text: "T")}
var CBtnResend:     String{ return CLocalize(text: "Resend") }
var CBtnYes:        String{ return CLocalize(text: "Yes") }
var CBtnNo:         String{ return CLocalize(text: "No") }
var CBtnOk:         String{ return CLocalize(text: "Ok") }
var CBtnCancel:     String{ return CLocalize(text: "Cancel") }
var CBtnConfirm:    String{ return CLocalize(text: "Confirm") }
var CBtnRetry:      String{ return CLocalize(text: "Retry") }
var CBtnSave:       String{ return CLocalize(text: "Save") }
var CBtnDontSave:   String{ return CLocalize(text: "Don't Save") }
var CBtnSubmit:     String{ return CLocalize(text: "Submit")}
var CFree:   String{return CLocalize(text: "Free")}
var CTable:   String{return CLocalize(text: "Table")}

var CGenderMale:    String{ return CLocalize(text: "Male") }
var CGenderFemale:  String{ return CLocalize(text: "Female") }
var CViewAllPlayers:  String{ return CLocalize(text: "View All Players") }
var CViewScoreCard:  String{ return CLocalize(text: "View Score Card") }

var CMyTournament:  String{ return CLocalize(text: "My Tournament") }
var CTournament:  String{ return CLocalize(text: "Tournament") }
var COpenForRegistration:  String{ return CLocalize(text: "Open for Registration") }
var CCurrentlyRunning:  String{ return CLocalize(text: "Currently Running") }
var CSwissTournamentType:  String{ return CLocalize(text: "Swiss Type Tournament") }
var CEliminationTournamentType:  String{ return CLocalize(text: "Elimination Type Tournament") }
var CLive:  String{ return CLocalize(text: "Live") }
var CUpcoming:  String{ return CLocalize(text: "Upcoming") }
var CCompleted:  String{ return CLocalize(text: "Completed") }
var COngoing:  String{ return CLocalize(text: "Ongoing") }

var CWinTitle: String{ return CLocalize(text: "Win") }
var CLostTitle: String{ return CLocalize(text: "Lost") }
var CTieTitle: String{ return CLocalize(text: "Tie") }


var CError: String{ return CLocalize(text: "ERROR!") }
var CMessageNoInternet1: String{ return CLocalize(text: "An error has occured. Please check your network connection or try again.") }
var CMessageNoInternet2: String{ return CLocalize(text: "Please check your internet connection or tap anywhere to refresh the page.") }

var CMessageNoResultFound1: String{ return CLocalize(text: "You do not have any drafts.") }
var CMessageNoResultFound2: String{ return CLocalize(text: "Sorry, No results found") }
var CMessageNoResultFound3: String{ return CLocalize(text: "Sorry we couldn't find any result here!\ntap anywhere to refresh the page.") }

var CMessageOtherError: String{ return CLocalize(text: "Something wrong here...\ntap anywhere to refresh the page.") }

var CMessageDelete: String{ return CLocalize(text: "Are you sure want to delete?") }
var CMessageLogout: String{ return CLocalize(text: "Are you sure you want to sign out?") }


var CMessageVerificationCodeSend: String{ return CLocalize(text: "Verification Code has been sent on your email for verify your account.") }
var CMessageVerifiedAccount: String{ return CLocalize(text: "your account has been successfully verified.") }
var CMessageVerifyCodeSendForResetPWD: String{ return CLocalize(text: "Verification Code has been sent to your email to reset your password.") }



var CBlankUserName : String{ return CLocalize(text: "Please enter a unique Username.")}
var CBlankEmailOrUserName : String{ return CLocalize(text: "Please enter your Email or Username.")}
var CBlankEmail : String{ return CLocalize(text: "Please enter your Email.")}
var CBlankPassword : String{ return CLocalize(text: "Please enter your Password.")}
var CBlankCurrentPassword : String{ return CLocalize(text: "Please enter your Current Password.")}
var CBlankVerificationCode : String{ return CLocalize(text: "Please enter the Verification Code.")}
var CBlankNewPassword : String{ return CLocalize(text: "Please enter your New Password.")}
var CBlankConfirmPassword : String{ return CLocalize(text: "Please enter your Confirm Password.")}
var CBlankFullName : String{ return CLocalize(text: "Please enter your Full Name.")}
var CBlankPhoneNumber : String{ return CLocalize(text: "Please enter your Mobile Number.")}

var CInvalidPassword : String{ return CLocalize(text: "Please enter a valid Password.")}
var CInvalidPasswordFormat : String { return CLocalize(text: "Password should be minimum 6 character alphanumeric.")}
var CInvalidEmail : String { return CLocalize(text: "Please enter a valid Email.")}
var CInvalidVerificationCode : String { return CLocalize(text: "Please enter a valid Verification.")}
var CInvalidPhoneNumber : String{ return CLocalize(text: "Please enter a valid Phone Number.")}
var CInvalidPhoneNumberFormat : String{ return CLocalize(text: "Mobile number should only be in 10 digit numeric format.")}

var CPasswordConfirmPasswordMisMatch : String{ return CLocalize(text: "Password and Confirm Password must be same.")}
var CNewPasswordConfirmPasswordMisMatch : String{ return CLocalize(text: "New Password and Confirm Password must be same.")}

var CAcceptTermsCondition : String{ return CLocalize(text: "Please accept Terms & Conditions.")}
var CVerityCode : String{ return CLocalize(text: "Please enter the sent Verification Code.")}
var CConfirmEmailAndMobile : String{ return CLocalize(text: "Please confirm the entered email address and mobile number is correct:")}
var CMessageAccountVerified : String{ return CLocalize(text: "Your account has been successfully verified.")}
var CMessageEditedProfile : String{ return CLocalize(text: "Your Profile has been successfully updated.")} 

var CPauseMatchAndCallJudge : String {return CLocalize(text: "Are you sure you want to pause the match and call judge?")}
var CTieTheMatch : String {return CLocalize(text: "You have entered that Tie the match.Please make sure this is the correct result.")}
var CWinTheMatch : String {return CLocalize(text: "You have entered that you Win the match.Please make sure this is the correct result.")}
var CLostTheMatch : String {return CLocalize(text: "You have entered that you Lost the match.Please make sure this is the correct result.")}
var CNoInternetConnection : String {return CLocalize(text: "Please check your internet connection or try again later.")}

var CNotInTournament : String {return CLocalize(text: "You are not in Tournament")}
var CNoRoundRunning : String {return CLocalize(text: "No Round Running")}

//MARK:- Comment
var CJustNow : String {return CLocalize(text: "Just now")}
var CMinAgo : String {return CLocalize(text: "min ago")}
var CMinsAgo : String {return CLocalize(text: "mins ago")}
var CHourAgo : String {return CLocalize(text: "hour ago")}
var CHoursAgo : String {return CLocalize(text: "hours ago")}
var CDayAgo : String {return CLocalize(text: "day ago")}
var CDaysAgo : String {return CLocalize(text: "days ago")}
var CYearAgo : String {return CLocalize(text: "year ago")}
var CYearsAgo : String {return CLocalize(text: "years ago")}
var CMonthAgo : String {return CLocalize(text: "month ago")}
var CMonthsAgo : String {return CLocalize(text: "months ago")}

//MARK:- Navigation Title

var CSettings : String {return CLocalize(text: "Settings")}
var CProfile : String {return CLocalize(text: "Profile")}
var CForgotPasswordTitle : String {return CLocalize(text: "Forgot Password")}
var CResetPasswordTitle : String {return CLocalize(text: "Reset Password")}
var CVerifyEmail : String {return CLocalize(text: "Verify Email")}
var CNotificationsTitle : String {return CLocalize(text: "Notifications")}
var CUpcomingMatchesTitle : String {return CLocalize(text: "Upcoming Matches")}
var CBracket : String {return CLocalize(text: "Bracket")}
var CScoreCard : String {return CLocalize(text: "Score Card")}
var CTournamentUser : String {return CLocalize(text: "Tournament User")}
var CRateYourExperience : String {return CLocalize(text: "Rate Your Experience")}
