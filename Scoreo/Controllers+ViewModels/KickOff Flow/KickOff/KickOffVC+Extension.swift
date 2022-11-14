//
//  KickOffVC+Extension.swift
//  Scoreo
//
//  Created by Remya on 11/8/22.
//

import Foundation
import UIKit

//MARK: - Searchbar Delegates
extension KickOffViewController:UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim() != ""{
            if KickOffViewController.urlDetails?.key.contains(searchText.lowercased()) ?? false{
                if let indx = KickOffViewController.urlDetails?.key.firstIndex(of: searchText.lowercased()){
                    if KickOffViewController.urlDetails?.url.count ?? 0 > indx{
                        gotoWebview(url: KickOffViewController.urlDetails?.url[indx] ?? "")
                    }
                }
            }
           
            else{
            doSearch(searchText: searchText)
            }
        }
        else{
            
            self.viewModel.liveMatches = self.viewModel.OriginalLiveMatches
            self.viewModel.soonMatches = self.viewModel.OriginalSoonMatches
            
            prepareViews()
            
        }
        
    }
    
    func doSearch(searchText:String){
       
            var originals = viewModel.OriginalLiveMatches
            
        self.viewModel.liveMatches = originals?.filter{($0.leagueName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.leagueNameShort?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.homeName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.awayName?.lowercased().contains(searchText.lowercased()) ?? false)}
        originals = viewModel.OriginalSoonMatches
        self.viewModel.soonMatches = originals?.filter{($0.leagueName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.leagueNameShort?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.homeName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.awayName?.lowercased().contains(searchText.lowercased()) ?? false)}
        
        prepareViews()
        
    }
    
    func gotoWebview(url:String){
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        if url != ""{
            vc.urlString = url
        }
        self.navigationController?.pushViewController(vc, animated: true)
       
        searchBar.text = ""
        searchBar.endEditing(true)
        self.viewModel.liveMatches = self.viewModel.OriginalLiveMatches
        self.viewModel.soonMatches = self.viewModel.OriginalSoonMatches
        prepareViews()
    }
    
    
}
