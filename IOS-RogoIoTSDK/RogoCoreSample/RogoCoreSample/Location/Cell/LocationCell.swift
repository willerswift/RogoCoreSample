//
//  LocationCell.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var lbNameLocation: UILabel!
    
    @IBOutlet weak var lbDescLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
