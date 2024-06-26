//
//  DoorSensorCell.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 27/03/2024.
//

import UIKit

class DoorSensorCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    
    @IBOutlet weak var lbStateDoor: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
