//
//  BracketEliminationTblCell.swift
//  XPTournament
//
//  Created by mac-00011 on 05/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import UIKit
import WebKit

class BracketEliminationTblCell: UITableViewCell {
    
    //MARK:- UI Outlets
    //MARK:-
    
    @IBOutlet var webVElimination: UIWebView!
    @IBOutlet weak var btnPrint: UIButton! {
        didSet {
            btnPrint.layer.cornerRadius = btnPrint.CViewHeight * 0.1
        }
    }
    
    var eliminationUrl = String()
    let documentInteractionController = UIDocumentInteractionController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    // Load Url in WebVElimination
    func loadEliminationInfo(_ eliminationUrl: String) {
        webVElimination.loadRequest(URLRequest(url: URL(string: eliminationUrl)!))
        btnPrint.touchUpInside { (sender) in
            self.downloadPdfFile(eliminationUrl)
        }
    }
    
}

//MARK:- General Methods
//MARK:-

extension BracketEliminationTblCell {
    
    // To download video and store in document directory.
    func downloadPdfFile(_ pdfUrl: String?) {
        
        // If url not found
        if (pdfUrl?.isBlank)! || pdfUrl == nil {
            return
        }
        
        //download the file in a seperate thread.
        GCDBackgroundThread.async {
            
            let urlToDownload = pdfUrl
            let url = URL(string: urlToDownload ?? "")
            var urlData = Data()
            do {
                urlData = try Data(contentsOf: url!)
            }catch {
                print("Unable to load data: \(error)")
            }
            
            if urlData.count > 0 {
            
                let urlString = String(decoding: urlData, as: UTF8.self)
                
                GCDMainThread.async {
                    let marker = UIMarkupTextPrintFormatter(markupText: urlString)
                    
                    let activityVc = UIActivityViewController(activityItems: [marker], applicationActivities: nil)
                    self.window?.rootViewController?.present(activityVc, animated: false, completion: nil)
                }
            }
        }
        
    }
}

