//
//  DeleteDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore
import DropDown

class DeleteDeviceVC: UIBaseVC {

    //MARK: - Outlet
    
    var selectedLocaiton: RGBLocation?
    
    var selectedDevice: RGBDevice?
    
    @IBOutlet weak var btnDropDown: UIButton!
    
    //MARK: - Properties
    
    let dropDownSelectDevice = DropDown()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SelectDevicenDropDown()
    }

    func SelectDevicenDropDown() {
        dropDownSelectDevice.backgroundColor = .darkGray
        dropDownSelectDevice.textColor = .white
        dropDownSelectDevice.anchorView = btnDropDown;
        let listDeviceName = RGCore.shared.user.selectedLocation?.allDevicesInLocation.map{$0.label ?? ""}
        dropDownSelectDevice.dataSource = listDeviceName ?? []
        dropDownSelectDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDropDown.setTitle(item, for: .normal)
            self?.selectedDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation[index]
        }
    }
    
    //MARK: - Action
    
    @IBAction func btnDropDrownSelectDevice(_ sender: Any) {
        SelectDevicenDropDown()
        dropDownSelectDevice.show()
    }
    
    @IBAction func btnDeleteDevice(_ sender: Any) {
        //TODO: - deleteDevice
        guard let selectedDevice = selectedDevice else {return}
        RGCore.shared.device.deleteDevice(selectedDevice) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
}
