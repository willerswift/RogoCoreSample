//
//  AddGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore
import DropDown

class AddGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var tfGroupName: UITextField!
    
    @IBOutlet weak var btnDropDown: UIButton!
    
    //MARK: - Properties
    
    var groupType: RGBGroupType?
    
    var selectedLocation: RGBLocation?
    
    var selectedGroupType: RGUIRoomType? = nil
    
    let dropDown = DropDown()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func typeGroupDropDown() {
        dropDown.backgroundColor = .darkGray
        dropDown.textColor = .white
        dropDown.anchorView = btnDropDown;
        let listGroupType = RGUIRoomType.allCases
        dropDown.dataSource = listGroupType.map{$0.title}
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnDropDown.setTitle(item, for: .normal)
            self?.selectedGroupType = listGroupType[index]
        }
    }
    
    //MARK: - Action
    @IBAction func btnAddGroup(_ sender: Any) {
        let editName: String = tfGroupName.text ?? ""
        let editNameType: String = selectedGroupType?.rawValue ?? ""
        guard let groupType = groupType else {return}
        //TODO: - createGroup
        RGCore.shared.group.createGroup(label: editName,
                                        desc: editNameType,
                                        type: groupType,
                                        locationId: selectedLocation?.uuid ?? "") { info, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    
    @IBAction func btnDropDownChooseGroupType(_ sender: Any) {
        typeGroupDropDown()
        dropDown.show()
    }
}
