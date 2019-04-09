//
//  TournamentDetailCompletedHeader.swift
//  XPTournament
//
//  Created by mac-0005 on 19/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

@objc protocol TournamentDetailCompletedHeaderDelegate: class {
    @objc optional func tournamentCompleteRoundSelected(round: Int, isElimantionRound: Bool, indexpath: IndexPath)
}
let CRoundSelectedColor = CRGB(r: 27, g: 190, b: 49)
let CRoundNormalColor = CRGB(r: 185, g: 220, b: 255)

class TournamentDetailCompletedHeader: UIView {
    
    @IBOutlet var clRound : UICollectionView!
    var tournamentDetailCompletedHeaderDelegate: TournamentDetailCompletedHeaderDelegate!
    
    //    var roundCount = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var isCompletedTournament = true
    var arrRoundList = [RoundDetailModel]()
    var elimationRCount = 0
    var swissRCounts = 0
    var availableRoundCount = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
// MARK:- --------- UICollectionView Delegate/Datasources
extension TournamentDetailCompletedHeader {
    
    func configureCurrentlyRunningAndCompletedHeader(tournament: TournamentDetailViewModel) {
        
        elimationRCount = tournament.eliminationRoundCounts
        swissRCounts = tournament.swissRoundCounts
        let totalRound = tournament.eliminationRoundCounts + tournament.swissRoundCounts
        if totalRound > 0 {
            availableRoundCount = tournament.tournamentStatus == .TournamentCompleted ?tournament.arrRoundMatches.count : tournament.arrRoundCurrentlyRunningMatches.count

            selectedIndexPath = tournament.selectedRoundIndexPath
            clRound.register(UINib(nibName: "TournamentDetailRoundCollCell", bundle: nil), forCellWithReuseIdentifier: "TournamentDetailRoundCollCell")
            
            GCDMainThread.async {
                self.clRound.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension TournamentDetailCompletedHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        }else {
            cell.lblRound.textColor = CRoundNormalColor
            cell.viewBottomLine.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            if self.isCompletedTournament {
                // Selection for completed Tournament
                selectedIndexPath = indexPath
                if tournamentDetailCompletedHeaderDelegate != nil {
                    if indexPath.item > swissRCounts - 1 {
                        // It is elimanation Round
                        let elimationRoundNumber = indexPath.item - (swissRCounts - 1)
                        tournamentDetailCompletedHeaderDelegate?.tournamentCompleteRoundSelected?(round: elimationRoundNumber, isElimantionRound: true, indexpath: selectedIndexPath)
                    }else {
                        // It is normal Round
                        tournamentDetailCompletedHeaderDelegate?.tournamentCompleteRoundSelected?(round: selectedIndexPath.item+1, isElimantionRound: false, indexpath: selectedIndexPath)
                    }
                    clRound.reloadData()
                }
            }else {
                // Selection for other user Tournament
                if (availableRoundCount - 1 >= indexPath.item) {
                    selectedIndexPath = indexPath
                    if tournamentDetailCompletedHeaderDelegate != nil {
                        if indexPath.item > swissRCounts - 1 {
                            // It is elimanation Round
                            let elimationRoundNumber = indexPath.item - (swissRCounts - 1)
                            tournamentDetailCompletedHeaderDelegate?.tournamentCompleteRoundSelected?(round: elimationRoundNumber, isElimantionRound: true, indexpath: selectedIndexPath)
                        }else {
                            // It is normal Round
                            tournamentDetailCompletedHeaderDelegate?.tournamentCompleteRoundSelected?(round: selectedIndexPath.item+1, isElimantionRound: false, indexpath: selectedIndexPath)
                        }
                        
                        clRound.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontPoppins(size: 18, type: .regular).setUpAppropriateFont()
        var title = ""
        var extraSpace: CGFloat = 40.0
        if indexPath.item > swissRCounts - 1 {
            extraSpace = 60
            title = "\(kElimantionText) \(indexPath.item - (swissRCounts - 1))"
        }else {
            extraSpace = 40
            title = "\(kRoundText) \(indexPath.item+1)"
        }
        
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + extraSpace)))
        size.height = clRound.frame.size.height
        return size
        
    }
}
