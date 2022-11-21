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
    
    //For Linups
    var previewLinups:[PreviewLineupList]?
    var linupList:[LineupList]?
   
    var apiCounter = 0{
        didSet{
            if apiCounter == 3{
                print("Finished All")
                print(self.previewLinups?.count ?? 0)
                print(self.linupList?.count ?? 0)
                apiCounter = 0
                self.filterMatches()
                self.delegate?.diFinisfFetchMatches()
                
            }
        }
    }
    
   
    
    func getMatchesList(page:Int){
        // Utility.showProgress()
        print("PAGE::\(page)")
      
        HomeAPI().getScores(page: page) { response in
            self.scoreResponse = response
            if page > 1 {
                var tempMatches = self.matches ?? []
                tempMatches.append(contentsOf: response.matchList ?? [])
                self.matches = tempMatches
                 self.filterMatches()
                 self.delegate?.diFinisfFetchMatches()
            }
            else{
               
                self.matches?.removeAll()
                self.matches = response.matchList
                self.apiCounter += 1
            }
            
            self.pageData = response.meta
            let page = self.delegate!.getCurrentPage()
            if page <= (self.pageData?.lastPage ?? 0){
                self.getMatchesList(page: page)
            }
           
        } failed: { msg in
          //  Utility.showErrorSnackView(message: msg)
        }
        
    }
    
    func getMatchesByLeague(leagueID:Int){
       
        self.matches?.removeAll()
        self.matches = scoreResponse?.todayHotLeagueList?.filter{$0.leagueId == leagueID}
        filterMatches()
        delegate?.didFinishFilterByLeague()
    }
    
    func getLinupPreview(){
       
        HomeAPI().getLinupPreview { response in
            self.previewLinups = response.lineupList
            self.apiCounter += 1
        } failed: { _ in
            
        }

    }
    
    func getLinupList(){
        
        HomeAPI().getLinup { response in
            self.linupList = response.lineupList
            self.apiCounter += 1
        } failed: { _ in
            
        }

    }
    
    
}

extension KickOffViewModel{
    func filterMatches(){
       
        let linupIds:[Int] = linupList?.map{$0.matchId ?? 0} ?? []
        liveMatches = matches?.filter{linupIds.contains($0.matchId!)}
        OriginalLiveMatches = liveMatches
        let previewIds:[Int] = previewLinups?.map{$0.matchId ?? 0} ?? []
        soonMatches = matches?.filter{previewIds.contains($0.matchId!)}
        OriginalSoonMatches = soonMatches
      
//            liveMatches = matches?.filter{!($0.state == 0 || $0.state == -1)}
//            OriginalLiveMatches = liveMatches
//            soonMatches = matches?.filter{$0.state == 0}
//            OriginalSoonMatches = soonMatches
//            let page = delegate!.getCurrentPage()
//            if delegate?.getSelectedLeagueID() == nil{
//            if soonMatches?.count == 0 && page <= (pageData?.lastPage ?? 0){
//                getMatchesList(page: page)
//            }
//            }
    }
}
