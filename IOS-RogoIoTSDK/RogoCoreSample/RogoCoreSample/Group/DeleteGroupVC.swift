//
//  DeleteGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore
import DropDown

class DeleteGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDown: UIButton!
    
    //MARK: - Properties
    
    var groupType: RGBGroupType?
    
    var selectedLocation: RGBLocation?
    
    var dropDownGroupName = DropDown()
    
    var listGroup: [RGBGroup]?
    
    var listGroupLabel: [String] = []
    
    var selectedGroup: RGBGroup?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == groupType}
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
    }
    
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDown;
//        let listGroupName = listGroup.map{$0.label ?? ""}
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDown.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
    
    //MARK: - Action

    @IBAction func btnDeleteGroup(_ sender: Any) {
        //TODO: - deleteGroup
        guard let groupId = selectedGroup?.uuid else {
            return
        }
        RGCore.shared.group.deletedGroup(id: groupId) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnDropDownNameGroup(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
}
