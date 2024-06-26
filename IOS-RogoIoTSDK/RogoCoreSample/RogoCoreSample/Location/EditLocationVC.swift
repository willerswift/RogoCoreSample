//
//  EditLocationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 12/01/2024.
//

import UIKit
import RogoCore
import DropDown

class EditLocationVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var tfUpdateLocationName: UITextField!
    
    @IBOutlet weak var btnDropDownChooseLocation: UIButton!
    
    @IBOutlet weak var btnDropDownLocationType: UIButton!
    

    //MARK: - Properties
    
    var selectedLocationType: RGUILocationType? = nil
    
    var selectedLocaiton: RGBLocation?
    
    var listLocation = RGCore.shared.user.locations
    
    let dropDownLocationType = DropDown()
    
    let dropDownSelectLocaiton = DropDown()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectLocationDropDown()
        hideKeyboardWhenTappedAround()
    }
    
    func SelectLocationDropDown() {
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
    
    func typeLocationDropDown() {
        dropDownLocationType.backgroundColor = .darkGray
        dropDownLocationType.textColor = .white
        dropDownLocationType.anchorView = btnDropDownLocationType;
        let listLocationType = RGUILocationType.allCases
        dropDownLocationType.dataSource = listLocationType.map{$0.desc()}
        dropDownLocationType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownLocationType.setTitle(item, for: .normal)
            self?.selectedLocationType = listLocationType[index]
        }
    }
    
    //MARK: - Action

    @IBAction func btnUpdateLocation(_ sender: Any) {
        guard let selectLocationId = selectedLocaiton?.uuid else {
            return
        }
        //TODO: - updateLocations
        RGCore.shared.user.updateLocations(id: selectLocationId , label: tfUpdateLocationName.text ?? "", desc: selectedLocationType?.desc() ?? "Chưa xác định") { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnDropDownChooseLocation(_ sender: Any) {
        SelectLocationDropDown()
        dropDownSelectLocaiton.show()
    }
    @IBAction func btnChooseLocationType(_ sender: Any) {
        typeLocationDropDown()
        dropDownLocationType.show()
    }
}
