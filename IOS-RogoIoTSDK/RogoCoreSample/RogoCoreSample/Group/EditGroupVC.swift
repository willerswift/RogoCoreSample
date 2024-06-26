//
//  EditGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore
import DropDown

class EditGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var tfGroupName: UITextField!
    
    @IBOutlet weak var btnDropDownGroupType: UIButton!
    
    @IBOutlet weak var btnDropDownNameGroup: UIButton!
    
    //MARK: - Properties
    
    var groupType: RGBGroupType?
    
    var selectedLocation: RGBLocation? = nil
    
    let dropDownGroupName = DropDown()
    
    let dropDownGroupType = DropDown()
    
    var selectedGroup: RGBGroup?
    
    var listGroup: [RGBGroup]?
    
    var listGroupLabel: [String] = []

    var selectedGroupType: RGUIRoomType? = nil
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == groupType}
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
        hideKeyboardWhenTappedAround()
    }
    
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDownNameGroup;
//        let listGroupName = listGroup.map{$0.label ?? ""}
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownNameGroup.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
    
    func groupTypeDropDown() {
        dropDownGroupType.backgroundColor = .darkGray
        dropDownGroupType.textColor = .white
        dropDownGroupType.anchorView = btnDropDownGroupType;
        let listGroupType = RGUIRoomType.allCases
        dropDownGroupType.dataSource = listGroupType.map{$0.title}
        dropDownGroupType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownGroupType.setTitle(item, for: .normal)
            self?.selectedGroupType = listGroupType[index]
        }
    }
    
    //MARK: - Action

    @IBAction func btnDropDownGroupType(_ sender: Any) {
        groupTypeDropDown()
        dropDownGroupType.show()
    }
    @IBAction func btnDropDownChooseGroup(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
        
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        guard let selectedGroupID = selectedGroup?.uuid else {
            return
        }
        //TODO: - updateGroup
        RGCore.shared.group.updateGroup(id: selectedGroupID, label: tfGroupName.text ?? "", desc: selectedGroupType?.rawValue ?? "") { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
}
