//
//  ControlVirtualGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 27/03/2024.
//

import UIKit
import RogoCore
import DropDown

class ControlVirtualGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDownDevice: UIButton!
    @IBOutlet weak var btnDropDownNameGroup: UIButton!
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    let dropDownGroupName = DropDown()
    
    let dropDownSelectDevice = DropDown()
    
    var listGroupLabel: [String] = []
    
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == .VirtualGroup}
    
    var selectedGroup: RGBGroup?
    var selectedDevice: RGBDevice?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func btnClickedAddDeviceGroupControl(_ sender: Any) {
        // In this part you can select a few elements inside the device, in this example I am taking all the elements inside the device to pass in.
        guard let device = selectedDevice, let group = selectedGroup, let elmIDs = device.elementIDS else {return}
        //TODO: - updateGroupMemberElement
        RGCore.shared.group.updateGroupMemberElement(elementIds: elmIDs,
                                                     ofDeviceWith: device.uuid ?? "",
                                                     toGroupdWith: group.uuid ?? "",
                                                     observer: self) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnClickedSelectDeviceDropDown(_ sender: Any) {
        chooseDeviceDropDown()
        dropDownSelectDevice.show()
    }
    @IBAction func btnClickedSelectGroupDropDown(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
}
