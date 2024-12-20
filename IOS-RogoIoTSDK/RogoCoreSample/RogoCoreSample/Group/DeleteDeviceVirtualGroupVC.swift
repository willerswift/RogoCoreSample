//
//  DeleteDeviceVirtualGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 27/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class DeleteDeviceVirtualGroupVC: UIBaseVC {
    //MARK: - Outlet
    
    @IBOutlet weak var btnDropDownDevice: UIButton!
    @IBOutlet weak var btnDropDownNameGroup: UIButton!
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    let dropDownGroupName = DropDown()
    
    let dropDownSelectDevice = DropDown()
    
    var listGroupLabel: [String] = []
    
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == .VirtualGroup}
    
    var listDeviceGroup: [RGBDevice] = []
    
    var listDeviceName: [String]?
    
    @Published var selectedGroup: RGBGroup?
    
    var selectedDevice: RGBDevice?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.$selectedGroup
            .sink { selectedGroup in
                guard let groupMembers = selectedGroup?.groupMembers else {return}
                for member in groupMembers {
                    if let device = RGCore.shared.user.selectedLocation?.allDevicesInLocation.first(where: {$0.uuid == member.deviceID}) {
                        self.listDeviceGroup.append(device)
                    }
                }
                self.listDeviceName = self.listDeviceGroup.map{$0.label ?? ""}
            }.store(in: &self.subscriptions)
        
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
            self?.selectedDevice = nil
            self?.btnDropDownDevice.setTitle("Tap to select", for: .normal)
        }
    }
    
    func chooseDeviceDropDown() {
        dropDownSelectDevice.backgroundColor = .darkGray
        dropDownSelectDevice.textColor = .white
        dropDownSelectDevice.anchorView = btnDropDownDevice;
        dropDownSelectDevice.dataSource = listDeviceName ?? []
        dropDownSelectDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownDevice.setTitle(item, for: .normal)
            self?.selectedDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation[index]
        }
    }
    
    //MARK: - Action

    @IBAction func btnClickedDeleteDeviceGroupControl(_ sender: Any) {
        //TODO: - updateGroupMemberElement
        // Delete a device within a virtual group
        guard let device = selectedDevice, let group = selectedGroup else {return}
        RGCore.shared.group.removeGroupMember(deviceWithUUID: device.uuid ?? "", fromGroupWith: group.uuid ?? "", observer: self) { response, error in
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
