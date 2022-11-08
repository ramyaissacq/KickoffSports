//
//  KickOffSelectionCollectionViewCell.swift
//  Scoreo
//
//  Created by Remya on 11/5/22.
//

import UIKit

class KickOffSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var underLine:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        handleSelection()
    }
    
    override var isSelected: Bool{
        didSet{
            handleSelection()
        }
    }
    
    func handleSelection(){
        if isSelected{
            let gradient1 = lblTitle.getGradientLayer(bounds: lblTitle.bounds)
            lblTitle.textColor = lblTitle.gradientColor(bounds: lblTitle.bounds, gradientLayer: gradient1)
            let gradient2 = underLine.getGradientLayer(bounds: underLine.bounds)
            underLine.backgroundColor = underLine.gradientColor(bounds: underLine.bounds, gradientLayer: gradient2)
        }
        else{
            lblTitle.textColor = Colors.textColor()
            underLine.backgroundColor = Colors.black1Color()
        }
        
    }

}
