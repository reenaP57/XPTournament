//
//  TournamentDetailMyLiveHeader.swift
//  XPTournament
//
//  Created by mac-0005 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

let kElimantionText = "Elimination Round"
let kRoundText = "Round"

@objc protocol TournamentDetailMyLiveHeaderDelegate: class {
    @objc optional func tournamentMyLiveRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath)
}

class TournamentDetailMyLiveHeader: UIView {
    
    @IBOutlet var clRound : UICollectionView!
    @IBOutlet weak var lblRunningRound: MIGenericLabel!
    
    var tournamentDetailMyLiveHeaderDelegate: TournamentDetailMyLiveHeaderDelegate!
    var isSelecting = false
    
    var availableRoundCount = 0
    var elimationRCount = 0
    var swissRCounts = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension TournamentDetailMyLiveHeader{
    /*
     totalRound:- Total No of round
     indexPath:- Selected indexpath
     availableTotalRound:- completed-Live round count
     */
    func configureMyLiveHeader(tournament: TournamentDetailViewModel, runningRound: Int, selectedTournamentType: Int) {
        elimationRCount = tournament.eliminationRoundCounts
        swissRCounts = tournament.swissRoundCounts
        let totalRound = elimationRCount + swissRCounts
        
        if totalRound > 0 {
            availableRoundCount = tournament.arrRoundMatches.count
            selectedIndexPath = tournament.selectedRoundIndexPath
            
            if runningRound != 0 {
                lblRunningRound.text = selectedTournamentType == 1 ? "\(kRoundText) \(runningRound) Running" : "\(kElimantionText) \(runningRound) Running"
            } else {
                lblRunningRound.text = ""
            }
            
            clRound.register(UINib(nibName: "TournamentDetailRoundCollCell", bundle: nil), forCellWithReuseIdentifier: "TournamentDetailRoundCollCell")
            GCDMainThread.async {
                self.clRound.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
// MARK:-

extension TournamentDetailMyLiveHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elimationRCount + swissRCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentDetailRoundCollCell", for: indexPath) as! TournamentDetailRoundCollCell
        
        cell.lblRound.text = indexPath.item > swissRCounts - 1 ? "\(kElimantionText) \(indexPath.item - (swissRCounts - 1))" : "\(kRoundText) \(indexPath.item+1)"
        
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
        
        //...Cell will be clickable for completed and Ongoing round, not Upcoimg round
        
        if selectedIndexPath != indexPath {
            if (availableRoundCount - 1 >= indexPath.item) {
                selectedIndexPath = indexPath
                if indexPath.item > swissRCounts - 1 {
                    // It is elimanation Round
                    let elimationRoundNumber = indexPath.item - (swissRCounts - 1)
                    if tournamentDetailMyLiveHeaderDelegate != nil {
                        self.tournamentDetailMyLiveHeaderDelegate.tournamentMyLiveRoundSelected?(round: elimationRoundNumber, isElimantionRound: true, indexpath: selectedIndexPath)
                    }
                }else {
                    // It is normal Round
                    if tournamentDetailMyLiveHeaderDelegate != nil {
                        tournamentDetailMyLiveHeaderDelegate.tournamentMyLiveRoundSelected?(round: selectedIndexPath.item+1, isElimantionRound: false, indexpath: selectedIndexPath)
                    }
                }
                
                clRound.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize = CFontPoppins(size: 18, type: .regular).setUpAppropriateFont()
        var title = ""
        var extraSpace: CGFloat = 40.0
        if indexPath.item > swissRCounts - 1 {
            extraSpace = 60
            title = "\(kElimantionText) \(indexPath.item - (swissRCounts - 1))"
        } else {
            extraSpace = 40
            title = "\(kRoundText) \(indexPath.item+1)"
        }
        
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + extraSpace)))
        size.height = clRound.frame.size.height
        return size
        
    }
}
