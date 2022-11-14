//
//  SoonTableViewCell.swift
//  Scoreo
//
//  Created by Remya on 11/7/22.
//

import UIKit

class SoonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHomeName: UILabel!
    @IBOutlet weak var lblAwayName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgHomeLogo: UIImageView!
    @IBOutlet weak var imgAwayLogo: UIImageView!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
      backView.roundCorners(corners: [.topLeft,.bottomRight], radius: 11)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:MatchList?){
        
        lblName.text = obj?.leagueNameShort
        lblHomeName.text = obj?.homeName
        lblAwayName.text = obj?.awayName
        imgAwayLogo.setImage(with: obj?.awayLogo, placeholder: Utility.getPlaceHolder())
        imgHomeLogo.setImage(with: obj?.homeLogo, placeholder: Utility.getPlaceHolder())
        
            let matchDate = Utility.getSystemTimeZoneTime(dateString: obj?.matchTime ?? "")
            lblTime.text = Utility.formatDate(date: matchDate, with: .hhmm2)
        lblDate.text = Utility.formatDate(date: matchDate, with: .ddmmm)
    }
    
}
