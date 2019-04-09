//
//  CMSViewModel.swift
//  XPTournament
//
//  Created by mac-0005 on 17/01/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation

// PropetryListDelegate Methods
protocol CMSDelegate: class {
    func cmsDetail(_ cmsInfo: CMSModel?)
}

class CMSViewModel {
    
    // MARK: - Global Variables.
    // MARK: -
    var cmsDelegate: CMSDelegate!
}

// MARK: - Api Functions
// MARK: -
extension CMSViewModel {
    func loadCMSData(cmsType: String?) {
        _ = APIRequest.shared().loadCMS(cmsType: cmsType, completion: { (response, error) in
        
            if (response != nil && error == nil) {
                if let cmsInfo = response as? CMSModel {
                    if self.cmsDelegate != nil {
                        self.cmsDelegate.cmsDetail(cmsInfo)
                    }
                }
            }
        })
    }
}
