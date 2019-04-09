//
//  BracketHeader.swift
//  XPTournament
//
//  Created by Mac-00016 on 21/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

@objc protocol BracketHeaderDelegate: class {
    @objc optional func bracketRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath)
}

class BracketHeader: UIView {

    @IBOutlet weak var lblCompletedCount : UILabel!
    @IBOutlet weak var lblOnGoingCount : UILabel!
    @IBOutlet weak var clRound : UICollectionView!
    
    var roundCount: Int?
    var availableRoundCount: Int?
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var bracketHeaderDelegate: BracketHeaderDelegate!
    var elimationRCount = 0
    var swissRCounts = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadHeaderViewData(bracketViewModel: TournamentBracketViewModel) {
        elimationRCount = bracketViewModel.eliminationRoundCounts
        swissRCounts = bracketViewModel.swissRoundCounts
        let totalRound = elimationRCount + swissRCounts
        
        if totalRound > 0 {
            availableRoundCount = bracketViewModel.arrAllRound.count
            selectedIndexPath = bracketViewModel.selectedRoundIndexPath
            lblCompletedCount.text = "\(bracketViewModel.totalCompletedRound ?? 0)"
            lblOnGoingCount.text = "\(bracketViewModel.totalOnGoingRound ?? 0)"
            clRound.register(UINib(nibName: "TournamentDetailRoundCollCell", bundle: nil), forCellWithReuseIdentifier: "TournamentDetailRoundCollCell")
            GCDMainThread.async {
                if self.swissRCounts > 0 {
                    self.clRound.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
                }
            }
            
        }
    }
}


//MARK:- UICollectionView Delegate and Datasource
//MARK:-

extension BracketHeader : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return swissRCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentDetailRoundCollCell", for: indexPath) as! TournamentDetailRoundCollCell

        cell.lblRound.text = "\(kRoundText) \(indexPath.item+1)"
        
        if selectedIndexPath == indexPath {
            cell.lblRound.textColor = CRoundSelectedColor
            cell.viewBottomLine.isHidden = false
        } else {
            cell.lblRound.textColor = CRoundNormalColor
            cell.viewBottomLine.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO:- Cell will be clickable for completed and Ongoing round, not Upcoimg round
        if (availableRoundCount! - 1 >= indexPath.item) {
            selectedIndexPath = indexPath
            if bracketHeaderDelegate != nil {
                
                bracketHeaderDelegate.bracketRoundSelected?(round: selectedIndexPath.item+1, isElimantionRound: false, indexpath: selectedIndexPath)
            }
            clRound.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontPoppins(size: 18, type: .regular).setUpAppropriateFont()
        var title = ""
        var extraSpace: CGFloat = 40.0
        extraSpace = 40
        title = "\(kRoundText) \(indexPath.item+1)"
        
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + extraSpace)))
        size.height = clRound.frame.size.height
        return size
    }
}
