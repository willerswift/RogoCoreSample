//
//  EditDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore
import DropDown

class EditDeviceVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var lbNoti: UILabel!
    
    @IBOutlet weak var tfDeviceName: UITextField!
    
    @IBOutlet weak var btnDropDownDevice: UIButton!
    
    //MARK: - Properties
    
    let dropDownSelectDevice = DropDown()
    
    var selectedDevice: RGBDevice?
    
    var listGroupLabel: [String] = []
    
    // Get the list of group that are not virtual group
    // Virtual groups and real groups are similar, but when you look at the virtual group control section, you will see the difference between them. For the devices inside the virtual group, we can send commands to control them as a group.
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType != .VirtualGroup}
    
    var selectedGroup: RGBGroup?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
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

    @IBAction func btnConfirm(_ sender: Any) {
        if tfDeviceName.text == "" {
            lbNoti.text = "Device Name Empty"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.lbNoti.text = ""
            }
        } else {
            guard let deviceID = selectedDevice?.uuid else {return}
            //TODO: - updateDevice
            RGCore.shared.device.updateDevice(deviceID, label: tfDeviceName.text, elementLabels: nil) { response, error in
                self.checkError(error: error, dismiss: true)
            }
        }
    }
    
    @IBAction func btnDropDownSelectDevice(_ sender: Any) {
        chooseDeviceDropDown()
        dropDownSelectDevice.show()
    }
}
