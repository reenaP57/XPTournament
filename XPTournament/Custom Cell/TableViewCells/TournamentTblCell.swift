//
//  TournamentTblCell.swift
//  XPTournament
//
//  Created by Mind-00011 on 16/11/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

protocol TournamentTblCellDelegate: class {
    func didRefreshTournamentList()
}

class TournamentTblCell: UITableViewCell {

    @IBOutlet weak var collVTournament: UICollectionView!
    @IBOutlet weak var btnViewAll: MIGenericButton!
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var vwSperatorLine : UIView!

    var tournamentType = 0
    var arrTournament = [TournamentDetailModel]()
    var tournamentTblCellDelegate: TournamentTblCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func loadTournamentData(arrTournamentList: [TournamentDetailModel], tournament: Int) {
        tournamentType = tournament
        arrTournament = arrTournamentList
        collVTournament.reloadData()
    }
}


//MARK:-
//MARK:- CollectionView Methods

extension TournamentTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrTournament.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (CScreenWidth * 308)/375 , height: (CScreenWidth * 323)/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentCollCell", for: indexPath) as? TournamentCollCell {
           
            //...Pass tournament info to cell
            cell.setTournamentInfo(tournamentInfo: arrTournament[indexPath.row], tournamentType: tournamentType)

            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tournamentInfo = arrTournament[indexPath.row]
        let tournamentID: Int64 = tournamentInfo.id ?? 0
        
        switch tournamentType {
        case CTypeMyTournament:
        //... My Tournament
            switch(tournamentInfo.tournamentStatus){
            case CLive:
                if let detailsVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "MyTournamentDetailsViewController") as? MyTournamentDetailsViewController{
                    
                    // Refresh screen after completed the tournament
                    detailsVC.setBlock { (object, message) in
                        if self.tournamentTblCellDelegate != nil {
                            self.tournamentTblCellDelegate.didRefreshTournamentList()
                        }
                    }
                    detailsVC.viewModelTournamentDetail.tournamentStatus = .LiveMyTournament
                    detailsVC.viewModelTournamentDetail.tournamentType = CTypeMyTournament
                    detailsVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                    self.viewController!.navigationController?.pushViewController(detailsVC, animated: true)
                }
                break
            case CUpcoming:
                if let resgiterTournamentVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "RegisterTournamentViewController") as? RegisterTournamentViewController{
                    resgiterTournamentVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                    self.viewController!.navigationController?.pushViewController(resgiterTournamentVC, animated: true)
                }
                break
            case CCompleted:
                if let detailsVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "MyTournamentDetailsViewController") as? MyTournamentDetailsViewController {
                    
                    detailsVC.viewModelTournamentDetail.tournamentStatus = .TournamentCompleted
                    detailsVC.viewModelTournamentDetail.tournamentType = CTypeMyTournament
                    detailsVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                    self.viewController!.navigationController?.pushViewController(detailsVC, animated: true)
                }
                break
            default:
                break
            }
            break
        case CTypeOpenForRegistration:
        //... Open for Registration
            if let resgiterTournamentVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "RegisterTournamentViewController") as? RegisterTournamentViewController{
                resgiterTournamentVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                self.viewController!.navigationController?.pushViewController(resgiterTournamentVC, animated: true)
            }
            break
        default:
        //... Currently Running
            if let detailsVC = CStoryboardTournamentDetails.instantiateViewController(withIdentifier: "MyTournamentDetailsViewController") as? MyTournamentDetailsViewController {
                
                // Refresh screen after completed the tournament
                detailsVC.setBlock { (object, message) in
                    if self.tournamentTblCellDelegate != nil {
                        self.tournamentTblCellDelegate.didRefreshTournamentList()
                    }
                }
                detailsVC.viewModelTournamentDetail.tournamentStatus = .LiveOtherTournament
                detailsVC.viewModelTournamentDetail.tournamentType = CTypeCurrentlyRunning
                detailsVC.viewModelTournamentDetail.tournamentID = Int(tournamentID)
                self.viewController!.navigationController?.pushViewController(detailsVC, animated: true)
            }
            break
        }
    }
}
