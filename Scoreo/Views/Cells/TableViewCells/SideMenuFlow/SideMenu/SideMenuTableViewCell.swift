//
//  SideMenuTableViewCell.swift
//  Core Score
//
//  Created by Remya on 9/29/22.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgArrow.tintColor = Colors.accentColor()
        imgIcon.tintColor = Colors.accentColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
