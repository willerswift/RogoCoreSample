//
//  DeleteSmartVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/02/2024.
//

import UIKit
import RogoCore
import DropDown

class DeleteSmartVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDownSelectSmart: UIButton!
    //MARK: - Properties
    var selectedLocation: RGBLocation?
    var selectedSmart: RGBSmart?
    var dropDownSelectSmart =  DropDown()
    var smartType: RGBSmartType?
    var listSmart: [RGBSmart]? = nil
    var listSmartName = [String]()
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let listSmart = listSmart else {return}
        for rgbSmart in listSmart {
            listSmartName.append(rgbSmart.label ?? "")
        }
    }
    func selectSmartDropDown() {
        dropDownSelectSmart.backgroundColor = .darkGray
        dropDownSelectSmart.textColor = .white
        dropDownSelectSmart.anchorView = btnDropDownSelectSmart
        dropDownSelectSmart.dataSource = listSmartName
        dropDownSelectSmart.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectSmart.setTitle(item, for: .normal)
            self?.selectedSmart = self?.listSmart?[index]
        }
    }
    
    //MARK: - Action
    
    @IBAction func btnSelectSmartDropDown(_ sender: Any) {
        selectSmartDropDown()
        dropDownSelectSmart.show()
    }
    @IBAction func btnDeleteSmart(_ sender: Any) {
        guard let selectedSmartId = selectedSmart?.uuid else {return}
        //TODO: - deleteSmart
        RGCore.shared.smart.deleteSmart(uuid: selectedSmartId) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
}
