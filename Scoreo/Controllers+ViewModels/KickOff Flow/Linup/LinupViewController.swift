//
//  LinupViewController.swift
//  Scoreo
//
//  Created by Remya on 11/9/22.
//

import UIKit


class LinupViewController: BaseViewController {
    
    @IBOutlet weak var lblBench: UILabel!
    @IBOutlet weak var lblFormation: UILabel!
    @IBOutlet weak var fixedFormation: UILabel!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var liveMatchView: LiveMatchView!
    @IBOutlet weak var collectionView5: UICollectionView!
    @IBOutlet weak var collectionView4: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var lblGoalKeeper: UILabel!
    @IBOutlet weak var imgGoalKeeper: UIImageView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgSoccerField: UIImageView!
    @IBOutlet weak var tableViewPlayers: UITableView!
    
    @IBOutlet weak var soccerFieldHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var match:MatchList?
    var previewLinup:PreviewLineupList?
    var linup:LineupList?
    var titlesArray = [String]()
    var playerSet1 = [LinupPlayer]()
    var playerSet2 = [LinupPlayer]()
    var playerSet3 = [LinupPlayer]()
    var playerSet4 = [LinupPlayer]()
    var playerSet5 = [LinupPlayer]()
    var selectedIndex = 0
    var tableViewObserver: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

       
    }
    
    func initialSetup(){
        lblBench.text = "Bench".localized
        fixedFormation.text = "Formation".localized
        setupNavBar()
        collectionView1.registerCell(identifier: "PlayerCollectionViewCell")
        collectionView2.registerCell(identifier: "PlayerCollectionViewCell")
        collectionView3.registerCell(identifier: "PlayerCollectionViewCell")
        collectionView4.registerCell(identifier: "PlayerCollectionViewCell")
        collectionView5.registerCell(identifier: "PlayerCollectionViewCell")
        collectionViewTop.registerCell(identifier: "KickOffSelectionCollectionViewCell")
        tableViewPlayers.register(UINib(nibName: "BenchTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewObserver = tableViewPlayers.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.tableHeight.constant = height
        }
        
        liveMatchView.configureCell(obj: match)
        titlesArray.append(match?.homeName ?? "")
        titlesArray.append(match?.awayName ?? "")
        collectionViewTop.reloadData()
        collectionViewTop.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        setupLinup()
        tableViewPlayers.reloadData()
    }
    
    func setupNavBar(){
        self.navigationItem.titleView = getHeaderLabel(title: "Lineups".localized)
        setBackButton()
       
    }
    
    
    func setupLinup(){
        playerSet1.removeAll()
        playerSet2.removeAll()
        playerSet3.removeAll()
        playerSet4.removeAll()
        playerSet5.removeAll()
        
        
        if previewLinup != nil{
            linupFromPreview()
        }
        else{
            normalLinup()
        }
    }
    
    func linupFromPreview(){
        var group:[PreviewLineup]?
        if selectedIndex == 0{
            group = previewLinup?.homeLineup
        }
        else{
            group = previewLinup?.awayLineup
        }
        let goli = LinupPlayer(obj: group?.filter{$0.positionId == "0"}.first)
        lblGoalKeeper.text = goli.name
        imgGoalKeeper.image = UIImage(named: "Player")
        
        let grp1 = group?.filter{$0.positionId == "1"}
        let grp2 = group?.filter{$0.positionId == "2"}
        let grp3 = group?.filter{$0.positionId == "3"}
        let grp4 = group?.filter{$0.positionId == "4"}
        let grp5 = group?.filter{$0.positionId == "5"}
        
        for m in grp1 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet1.append(player)
        }
        
        for m in grp2 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet2.append(player)
        }
      
        for m in grp3 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet3.append(player)
        }
        
        for m in grp4 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet4.append(player)
        }
        
        for m in grp5 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet5.append(player)
        }
        reloadCollectionViews()
        
    }
    
    func normalLinup(){
        var group:[Lineup]?
        if selectedIndex == 0{
            group = linup?.homeLineup
        }
        else{
            group = linup?.awayLineup
        }
        let goli = LinupPlayer(obj: group?.filter{$0.positionId == "0"}.first)
        lblGoalKeeper.text = goli.name
        imgGoalKeeper.setImage(with: goli.image, placeholder: UIImage(named: "Player"))
        let grp1 = group?.filter{$0.positionId == "1"}
        let grp2 = group?.filter{$0.positionId == "2"}
        let grp3 = group?.filter{$0.positionId == "3"}
        let grp4 = group?.filter{$0.positionId == "4"}
        let grp5 = group?.filter{$0.positionId == "5"}
        
        for m in grp1 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet1.append(player)
        }
        
        for m in grp2 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet2.append(player)
        }
      
        for m in grp3 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet3.append(player)
        }
        
        for m in grp4 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet4.append(player)
        }
        
        for m in grp5 ?? []{
            let player = LinupPlayer(obj: m)
            playerSet5.append(player)
        }
        reloadCollectionViews()
        
    }
    
    func reloadCollectionViews(){

        var str = ""
        if playerSet1.count > 0{
            str = "\(playerSet1.count)-"
        }
        if playerSet2.count > 0{
            str += "\(playerSet2.count)-"
        }
        if playerSet3.count > 0{
            str += "\(playerSet3.count)-"
        }
        if playerSet4.count > 0{
            str += "\(playerSet4.count)"
        }
        if playerSet5.count > 0{
            str += "-\(playerSet5.count)"
        }
        lblFormation.text = str
        
        if playerSet4.count == 0{
            imgSoccerField.image = UIImage(named: "soccer1")
            soccerFieldHeight.constant = 390
        }
        else if playerSet4.count > 0 && playerSet5.count == 0{
            imgSoccerField.image = UIImage(named: "soccer2")
            soccerFieldHeight.constant = 470
        }
        else if playerSet4.count > 0 && playerSet5.count > 0{
            imgSoccerField.image = UIImage(named: "soccer3")
            soccerFieldHeight.constant = 550
        }
        
        
        if playerSet1.isEmpty{
            collectionView1.isHidden = true
        }
        else{
            collectionView1.isHidden = false
        }
        if playerSet2.isEmpty{
            collectionView2.isHidden = true
        }
        else{
            collectionView2.isHidden = false
        }
        if playerSet3.isEmpty{
            collectionView3.isHidden = true
        }
        else{
            collectionView3.isHidden = false
        }
        if playerSet4.isEmpty{
            collectionView4.isHidden = true
        }
        else{
            collectionView4.isHidden = false
        }
        if playerSet5.isEmpty{
            collectionView5.isHidden = true
        }
        else{
            collectionView5.isHidden = false
        }
        collectionView1.reloadData()
        collectionView2.reloadData()
        collectionView3.reloadData()
        collectionView4.reloadData()
        collectionView5.reloadData()
        
    }
    
    func gotoProfile(obj:Lineup?){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.player = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension LinupViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTop{
            return titlesArray.count
        }
        else if collectionView == collectionView1{
            return playerSet1.count
        }
        else if collectionView == collectionView2{
            return playerSet2.count
        }
        else if collectionView == collectionView3{
            return playerSet3.count
        }
        else if collectionView == collectionView4{
            return playerSet4.count
        }
        else {
            return playerSet5.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewTop{
            let cell = collectionViewTop.dequeueReusableCell(withReuseIdentifier: "KickOffSelectionCollectionViewCell", for: indexPath) as! KickOffSelectionCollectionViewCell
            cell.lblTitle.text = titlesArray[indexPath.row]
            return cell
            
        }
        else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCollectionViewCell", for: indexPath) as! PlayerCollectionViewCell
            cell.configureCell(obj: getObjectAtIndex(collectionView: collectionView, row: indexPath.row))
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewTop{
            selectedIndex = indexPath.row
            setupLinup()
        }
        else{
            if linup != nil{
            let ob = getObjectAtIndex(collectionView: collectionView, row: indexPath.row)
                var playerObj:Lineup?
                if selectedIndex == 0{
                    playerObj = linup?.homeLineup?.filter{$0.playerId == ob?.id}.first
                }
                else{
                    playerObj = linup?.awayLineup?.filter{$0.playerId == ob?.id}.first
                }
            gotoProfile(obj: playerObj)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewTop{
            let w = (UIScreen.main.bounds.width - 40)/2
            return CGSize(width: w, height: 45)
        }
        return CGSize(width: 50, height: 75)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewTop{
            return 10
        }
        else if collectionView == collectionView1{
            return getSpacing(count: playerSet1.count)
        }
        else if collectionView == collectionView2{
            return getSpacing(count: playerSet2.count)
        }
        else if collectionView == collectionView3{
            return getSpacing(count: playerSet3.count)
        }
        else if collectionView == collectionView4{
            return getSpacing(count: playerSet4.count)
            
        }
        else {
            return getSpacing(count: playerSet5.count)
            
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionViewTop{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if collectionView == collectionView1{
            return UIEdgeInsets(top: 0, left: getSpacing(count: playerSet1.count), bottom: 0, right: getSpacing(count: playerSet1.count))
       
        }
        else if collectionView == collectionView2{
            return UIEdgeInsets(top: 0, left: getSpacing(count: playerSet2.count), bottom: 0, right: getSpacing(count: playerSet2.count))
            
        }
        else if collectionView == collectionView3{
            return UIEdgeInsets(top: 0, left: getSpacing(count: playerSet3.count), bottom: 0, right: getSpacing(count: playerSet3.count))
           
        }
        else if collectionView == collectionView4{
            return UIEdgeInsets(top: 0, left: getSpacing(count: playerSet4.count), bottom: 0, right: getSpacing(count:playerSet4.count))
            
        }
        else {
            return UIEdgeInsets(top: 0, left: getSpacing(count: playerSet5.count), bottom: 0, right: getSpacing(count:playerSet5.count))
           
            
        }
       
    }
    
    func getSpacing(count:Int) -> CGFloat{
       let w = 346 - (count * 50)
        let sp = w / (count+1)
        return CGFloat(sp)
    }
    
    func getObjectAtIndex(collectionView:UICollectionView,row:Int) -> LinupPlayer?{
        if collectionView == collectionView1{
            return playerSet1[row]
        }
        else if collectionView == collectionView2{
            return playerSet2[row]
        }
        else if collectionView == collectionView3{
            return playerSet3[row]
        }
        else if collectionView == collectionView4{
            return playerSet4[row]
        }
        else {
            return playerSet5[row]
        }
    }

}
