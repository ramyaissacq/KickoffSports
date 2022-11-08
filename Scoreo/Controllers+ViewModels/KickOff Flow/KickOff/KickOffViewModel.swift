//
//  KickOffViewModel.swift
//  Scoreo
//
//  Created by Remya on 11/7/22.
//

import Foundation


protocol KickOffViewModelDelegate{
    
    func diFinisfFetchMatches()
    func getSelectedLeagueID()->Int?
    func getCurrentPage()->Int
    func didFinishFilterByLeague()
}

class KickOffViewModel{
    var matches:[MatchList]?
    var OriginalLiveMatches:[MatchList]?
    var liveMatches:[MatchList]?
    var OriginalSoonMatches:[MatchList]?
    var soonMatches:[MatchList]?
    var pageData:Meta?
    var scoreResponse:ScoresResponse?
    var delegate:KickOffViewModelDelegate?
    
    
    func getMatchesList(page:Int){
        // Utility.showProgress()
        print("PAGE::\(page)")
        HomeAPI().getScores(page: page) { response in
            self.scoreResponse = response
            if page > 1 {
                var tempMatches = self.matches ?? []
                tempMatches.append(contentsOf: response.matchList ?? [])
                self.matches = tempMatches
            }
            else{
               
                self.matches?.removeAll()
                self.matches = response.matchList
            }
            
            self.pageData = response.meta
            self.filterMatches()
            self.delegate?.diFinisfFetchMatches()
            print("count::\(self.matches?.count ?? 0)")
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }
        
    }
    
    func getMatchesByLeague(leagueID:Int){
       
        self.matches?.removeAll()
        self.matches = scoreResponse?.todayHotLeagueList?.filter{$0.leagueId == leagueID}
        filterMatches()
        delegate?.didFinishFilterByLeague()
    }
    
    
}

extension KickOffViewModel{
    func filterMatches(){
      
            liveMatches = matches?.filter{!($0.state == 0 || $0.state == -1)}
            OriginalLiveMatches = liveMatches
            soonMatches = matches?.filter{$0.state == 0}
            OriginalSoonMatches = soonMatches
            let page = delegate!.getCurrentPage()
            if delegate?.getSelectedLeagueID() == nil{
            if soonMatches?.count == 0 && page <= (pageData?.lastPage ?? 0){
                getMatchesList(page: page)
                
            }
            }
    }
}
