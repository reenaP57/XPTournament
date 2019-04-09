//
//  ExtensionDateFormatter.swift
//  TheBayaApp
//
//  Created by mac-0005 on 13/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

// MARK:- Date Related Functions
// MARK:-

extension DateFormatter{
    
    // To Get date string from timestamp
    static func dateStringFrom(timestamp: Double?, withFormate:String?) -> String {
        let fromDate:Date = Date(timeIntervalSince1970: timestamp!)
        DateFormatter.shared().locale = NSLocale.current
        DateFormatter.shared().timeZone = TimeZone.current
        /*
         if Localization.sharedInstance.getLanguage() == CLanguageArabic {
         DateFormatter.shared().locale = Locale(identifier: "ar_DZ")
         } else {
         DateFormatter.shared().locale = NSLocale.current
         }
         */
        return DateFormatter.shared().string(fromDate: fromDate, dateFormat: withFormate!)
    }
    
    // To Get date from timestamp
    func dateFrom(timestamp: String) -> Date? {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        let stringDate = DateFormatter.shared().string(fromDate: fromDate, dateFormat: "dd MMM, YYYY")
        return DateFormatter.shared().date(fromString: stringDate, dateFormat: "dd MMM, YYYY")
    }
    
    // To get specific date string fromate from specific date string
    func convertDateFormat(date : String?, currentformate : String?, updateformate : String?) -> String? {
        let dateString = date
        var dateInfo = ""
        self.dateFormat = currentformate // "dd-MM-yyyy hh:mm a"
        
        if let strCurrnetDate = self.date(from: dateString!){
            self.dateFormat = updateformate //"dd-MMM-yyyy hh:mm a"
            dateInfo = self.string(from: strCurrnetDate)
        }
        
        return dateInfo
    }
    
    // To compare two date with same formate
    func compareTwoDates(startDate : String?, endDate : String?, formate : String?) -> Bool{
        self.dateFormat = formate
        self.timeZone = TimeZone(abbreviation: "GMT")
        let startDateTimeStamp = self.date(from: startDate!)?.timeIntervalSince1970
        let endDateTimeStamp = self.date(from: endDate!)?.timeIntervalSince1970
        return Double(endDateTimeStamp!) > Double(startDateTimeStamp!)
    }
    
    // To get duration string from timestamp
    func durationString(duration: String) -> String {
        let calender:Calendar = Calendar.current as Calendar
        let fromDate:Date = Date(timeIntervalSince1970: Double(duration)!)
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        let dateComponents = calender.dateComponents(unitFlags, from:fromDate , to: Date())
        
        let years:NSInteger = dateComponents.year!
        let months:NSInteger = dateComponents.month!
        let days:NSInteger = dateComponents.day!
        let hours:NSInteger = dateComponents.hour!
        let minutes:NSInteger = dateComponents.minute!
        
        var durations:NSString = CJustNow as NSString
        
        if (years > 0) {
            durations = (years == 1 ? "\(years) \(CYearAgo)" : "\(years) \(CYearsAgo)") as NSString
        }
        else if (months > 0) {
            durations = (months == 1 ? "\(months) \(CMonthAgo)" : "\(months) \(CMonthsAgo)") as NSString
        }
        else if (days > 0) {
            durations = (days == 1 ? "\(days) \(CDayAgo)" : "\(days) \(CDaysAgo)") as NSString
        }
        else if (hours > 0) {
            durations = (hours == 1 ? "\(hours) \(CHourAgo)" : "\(hours) \(CHoursAgo)") as NSString
        }
        else if (minutes > 0) {
            durations = (minutes == 1 ? CMinAgo : "\(minutes) \(CMinsAgo)") as NSString
        }
        
        return durations as String;
    }
}

// MARK:- Timestamp Related Functions
// MARK:-
extension DateFormatter {
    // To Get GMT Timestamp from Specific Date
    func timestampGMTFromDate(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        self.timeZone = TimeZone(abbreviation: "GMT")
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        timeStamp = Double(timeStamp!)
        return timeStamp
    }
    
    // To Get local Timestamp from specific date
    func timestampFromDate(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        self.timeZone = TimeZone.current
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        //        timeStamp = Double((timeStamp?.toFloat)!)
        timeStamp = Double(timeStamp!)
        return timeStamp
    }
    
    // To Get GMT Timestamp from current date.
    func currentGMTTimestampInMilliseconds() -> Double? {
        let format = "yyyy-MM-dd HH:mm:ss.SSSS'Z'"
        self.dateFormat = format
        self.timeZone = TimeZone(identifier: "GMT")
        
        let createDate = self.string(from: Date())
        let timestamp = self.timestampGMTFromDate(date: createDate, formate: format)
        return timestamp! * 1000
    }
    
    // To Convert GMT timestamp to local timestamp
    func ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: Double) -> Double? {
        let format = "yyyy-MM-dd HH:mm:ss.SSSS'Z'"
        self.dateFormat = format
        self.timeZone = TimeZone.current
        let dateStr = NSDate(timeIntervalSince1970:timestamp)
        let createDate = self.string(from: dateStr as Date)
        let timestamp = self.timestampFromDate(date: createDate, formate: format)
        return timestamp
        
    }
    
    
}
