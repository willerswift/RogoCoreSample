//
//  AddLocaitonVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore
import DropDown

class AddLocaitonVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var tfLocationName: UITextField!
    
    //MARK: - Properties
    
    var selectedLocationType: RGUILocationType? = nil
    let dropDown = DropDown()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func typeLocationDropDown() {
        dropDown.backgroundColor = .darkGray
        dropDown.textColor = .white
        dropDown.anchorView = btnDropDown;
        let listLocationType = RGUILocationType.allCases
        dropDown.dataSource = listLocationType.map{$0.desc()}
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnDropDown.setTitle(item, for: .normal)
            self?.selectedLocationType = listLocationType[index]
        }
    }
    
    //MARK: - Action
    @IBAction func btnAddLocaiton(_ sender: Any) {
        RGCore.shared.user.createLocation(label: tfLocationName.text ?? "",
                                          desc: selectedLocationType?.desc() ?? "Chưa xác định") { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnDropDownChooseLocaitonType(_ sender: Any) {
        typeLocationDropDown()
        dropDown.show()
    }
}
