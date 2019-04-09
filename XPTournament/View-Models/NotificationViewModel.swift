//
//  NotificationViewModel.swift
//  XPTournament
//
//  Created by mac-00011 on 06/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

typealias notificationSuccessCompletion = ((_ isRefreshScreen: Bool) -> ())

class NotificationViewModel {
    
    var apiTask: URLSessionTask?
    var notificationModel: [NotificationModel]?
    var arrNotification = [NotificationModel]()
    var pageNumber = 0
    
}

extension NotificationViewModel {
    
    func notificationList(isShowLoader: Bool?, successCompletion: @escaping notificationSuccessCompletion) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getNotificationList(isShowLoader: isShowLoader, page: pageNumber, completion: { (response, error) in
            
            if response != nil && error == nil {
                if let responseData = response,let notificationInfo =
                    responseData as? NotificationListModel {
                
                    // Remove all data when user calling api for 0 page
                    if self.pageNumber == 0 {
                        self.arrNotification.removeAll()
                        successCompletion(true)
                    }
                    
                    if let notificationListInfo = notificationInfo.data, notificationListInfo.count > 0 {
                        self.arrNotification += notificationListInfo
                        successCompletion(true)
                        self.pageNumber += 1
                        return
                    }
                }
            }
            
            successCompletion(false)
        })
    }
    
    func notificationReadList(successCompletion: @escaping notificationSuccessCompletion) {
        _ = APIRequest.shared().readNotification(completion: { (response, error) in
            if (response != nil && error == nil) {
                if let responseDic = response as? [String: Any] {
                    if (responseDic.valueForJSON(key: CJsonMeta) as? [String: Any]) != nil {
                       successCompletion(true)
                    }
                }
            }
        })
    }
}
