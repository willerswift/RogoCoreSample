//
//  DeleteLocaitonVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 12/01/2024.
//

import UIKit
import RogoCore
import DropDown

class DeleteLocaitonVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDownChooseLocation: UIButton!
    
    //MARK: - Properties
    
    var selectedLocaiton: RGBLocation?
    
    let dropDownSelectLocaiton = DropDown()
    
    let listLocation = RGCore.shared.user.locations
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectLocationDropDown() {
        dropDownSelectLocaiton.backgroundColor = .darkGray
        dropDownSelectLocaiton.textColor = .white
        dropDownSelectLocaiton.anchorView = btnDropDownChooseLocation;
        let lisLocationName = listLocation.map{$0.label ?? ""}
        dropDownSelectLocaiton.dataSource = lisLocationName
        dropDownSelectLocaiton.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownChooseLocation.setTitle(item, for: .normal)
            self?.selectedLocaiton = self?.listLocation[index]
        }
    }
    
    //MARK: -Action

    @IBAction func btnDeleteLocaiton(_ sender: Any) {
        guard let selectedLocaitonId = selectedLocaiton?.uuid else {return}
        //TODO: - deletedLocations
        RGCore.shared.user.deletedLocations(id: selectedLocaitonId) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnChooseLocaiton(_ sender: Any) {
        selectLocationDropDown()
        dropDownSelectLocaiton.show()
    }
}
