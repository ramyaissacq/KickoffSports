//
//  KickOffViewController.swift
//  Scoreo
//
//  Created by Remya on 11/7/22.
//

import UIKit

class KickOffViewController: BaseViewController {

    @IBOutlet weak var lblLeague: UILabel!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewMatch: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leagueView: UIView!
    
    //MARK: - Variables
    var viewModel = KickOffViewModel()
    var page = 1
    var selectedLeagueID:Int?
    var sectionHeaders = ["Live Matches".localized,"Soon".localized]
    var topTitles = ["ALL".localized,"LEAGUES".localized]
    var headerLabel:UILabel?
    
    
    static var urlDetails:UrlDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 15)
    }

    func initialSettings(){
        setupNavBar()
        searchBar.searchTextField.leftView?.tintColor = Colors.gray1Color()
        setupGestures()
        collectionViewTop.registerCell(identifier: "KickOffSelectionCollectionViewCell")
        tableViewMatch.register(UINib(nibName: "SoonTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewMatch.register(UINib(nibName: "LiveMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "liveCell")
        tableViewMatch.register(UINib(nibName: "SectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableViewMatch.register(UINib(nibName: "LoaderTableViewCell", bundle: nil), forCellReuseIdentifier: "loaderCell")
        tableViewMatch.register(UINib(nibName: "EmptySoonTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
        collectionViewTop.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        lblLeague.text = "Select League".localized
        viewModel.delegate = self
        viewModel.getMatchesList(page: page)
    }
    
    func setupGestures(){
        let tapLg = UITapGestureRecognizer(target: self, action: #selector(tapLeague))
        leagueView.addGestureRecognizer(tapLg)
    }
    
    func setupNavBar(){
        setupLeftView(title: "Kick-Off Sports".localized)
        let rightBtn = getButton(image: UIImage(named: "menu")!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func setupLeftView(title:String){
        headerLabel = getGradientHeaderLabel(title:title)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: headerLabel!)
    }
    
    @objc func tapLeague(){
        let mapCnt = KickOffViewController.urlDetails?.map?.count ?? 0
        if mapCnt > 0{
            openLeaguePopup()
        }
    }
    
    
    func openLeaguePopup(){
        if viewModel.scoreResponse?.todayHotLeague?.count == 0{
            return
        }
        
        var indx:Int?
        if selectedLeagueID != nil{
            indx = viewModel.scoreResponse?.todayHotLeague?.firstIndex(where: {$0.leagueId == selectedLeagueID})
            
        }
        
        Dialog.openLeaguePopup(leagues: viewModel.scoreResponse?.todayHotLeague,index: indx) { obj in
            self.lblLeague.text = obj.leagueName
            self.setupLeftView(title: obj.leagueName ?? "")
                self.selectedLeagueID = obj.leagueId
                self.viewModel.getMatchesByLeague(leagueID: self.selectedLeagueID!)
        }
        
       
       
    }
    
    
    static func showPopup(){
        let frequency = AppPreferences.getPopupFrequency()
        let promptFrequency = HomeViewController.urlDetails?.prompt?.frequency ?? 0
        if frequency < promptFrequency{
            let title = HomeViewController.urlDetails?.prompt?.title ?? ""
            let message = HomeViewController.urlDetails?.prompt?.message ?? ""
            if title.count > 0{
                Dialog.openSuccessDialog(buttonLabel: "OK".localized, title: title, msg: message, completed: {})
                AppPreferences.setPopupFrequency(frequency: frequency+1)
            }
        }
    }

}


extension KickOffViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return viewModel.soonMatches?.count ?? 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveCell", for: indexPath) as! LiveMatchesTableViewCell
            cell.matches = viewModel.liveMatches
            return cell
            
        }
        else{
            if indexPath.row == ((viewModel.liveMatches?.count ?? 0) - 1) && selectedLeagueID == nil{
                if page <= (viewModel.pageData?.lastPage ?? 0){
                    viewModel.getMatchesList(page: page)
                    //let cell = tableView.dequeueReusableCell(withIdentifier: "loaderCell", for: indexPath) as! LoaderTableViewCell
                    //cell.activity.startAnimating()
                    //return cell
                }
            }
            if viewModel.soonMatches?.count ?? 0 > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SoonTableViewCell
            cell.configureCell(obj: viewModel.soonMatches?[indexPath.row])
            return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! EmptySoonTableViewCell
                return cell
            }
                
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SectionHeaderTableViewCell
        cell.lblTitle.text = sectionHeaders[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
}


extension KickOffViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewTop.dequeueReusableCell(withReuseIdentifier: "KickOffSelectionCollectionViewCell", for: indexPath) as! KickOffSelectionCollectionViewCell
        cell.lblTitle.text = topTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            selectedLeagueID = nil
            leagueView.isHidden = true
            setupLeftView(title: "Kick-Off Sports".localized)
           
        page = 1
        viewModel.getMatchesList(page: page)
        }
        else{
            lblLeague.text = "Select League".localized
            let mapCnt = KickOffViewController.urlDetails?.map?.count ?? 0
            if mapCnt > 0{
                leagueView.isHidden = false
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (UIScreen.main.bounds.width - 50)/2
        return CGSize(width: w, height: 45)
    }
    
}


extension KickOffViewController:KickOffViewModelDelegate{
    func didFinishFilterByLeague() {
        prepareDisplays()
    }
    
    func getCurrentPage() -> Int {
        return page
    }
    
    func getSelectedLeagueID()->Int?{
           return selectedLeagueID
       }
    
    
    func diFinisfFetchMatches() {
        page += 1
        prepareDisplays()
        
    }
    
    
    func prepareDisplays(){
        applySearch()
        prepareViews()
    }
    
    func applySearch(){
        if !(searchBar.text?.isEmpty ?? false) {
            doSearch(searchText: searchBar.text ?? "")
        }
    }
    
    func prepareViews(){
        tableViewMatch.reloadData()
    }
   
}
