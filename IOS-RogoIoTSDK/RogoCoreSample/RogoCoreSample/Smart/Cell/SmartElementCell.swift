//
//  SmartElementCell.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 04/03/2024.
//

import UIKit

class SmartElementCell: UICollectionViewCell {

    @IBOutlet weak var lbElement: UILabel!
    
    @IBOutlet weak var viewSelectElement: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        viewSelectElement.backgroundColor = UIColor.white
        lbElement.text = ""
    }
    
}
