//
//  ControlVirtualGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 26/03/2024.
//

import UIKit
import DropDown
import RogoCore

class ControlVirtualGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDownDevice: UIButton!
    @IBOutlet weak var btnDropDownNameGroup: UIButton!
    //MARK: - Properties
    var selectedLocation: RGBLocation?
    let dropDownGroupName = DropDown()
    let dropDownSelectDevice = DropDown()
    var listGroup: [RGBGroup]?
    var selectedGroup: RGBGroup?
    var selectedDevice: RGBDevice?
    var listGroupLabel: [String] = []
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == .VirtualGroup}
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
    }
    
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDownNameGroup;
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownNameGroup.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
    
    func chooseDeviceDropDown() {
        dropDownSelectDevice.backgroundColor = .darkGray
        dropDownSelectDevice.textColor = .white
        dropDownSelectDevice.anchorView = btnDropDownDevice;
        let listDeviceName = RGCore.shared.user.selectedLocation?.allDevicesInLocation.map{$0.label ?? ""}
        dropDownSelectDevice.dataSource = listDeviceName ?? []
        dropDownSelectDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownDevice.setTitle(item, for: .normal)
            self?.selectedDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation[index]
        }
    }
    
    //MARK: - Action
  
    @IBAction func btnAddDeviceGroup(_ sender: Any) {
        guard let selectedGroup = selectedGroup, let selectedDevice = selectedDevice, let elmIDs = selectedDevice.elementIDS else {return}
        RGCore.shared.group.updateGroupMemberElement(elementIds: elmIDs,
                                                     of: selectedDevice,
                                                     to: selectedGroup,
                                                     observer: self) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        chooseDeviceDropDown()
        dropDownSelectDevice.show()
    }
    @IBAction func btnClickedSelectGroup(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
}
