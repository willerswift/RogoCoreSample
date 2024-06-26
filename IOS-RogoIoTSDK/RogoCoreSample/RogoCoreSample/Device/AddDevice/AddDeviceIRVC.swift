//  AddDeviceIRVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit
import RogoCore
import DropDown

class AddDeviceIRVC: UIBaseVC {
    
    //MARK: - Outlet
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbPercent: UILabel!
    @IBOutlet weak var tfDeviceName: UITextField!
    @IBOutlet weak var btnDropDownSelectedGroup: UIButton!
    @IBOutlet weak var btnDropDownSelectedWifi: UIButton!
    @IBOutlet weak var viewAddDevice: UIView!
    @IBOutlet weak var viewScanDeviceFail: UIView!
    @IBOutlet weak var viewDetectingDevice: UIView!
    @IBOutlet weak var viewScanningDevice: UIView!
    @IBOutlet weak var btnScanDevice: UIButton!
    @IBOutlet weak var lbNameDevice: UILabel!
    
    //MARK: - Properties
    var wifiSelectionHandler: ((String, String) -> ())?
    var deviceInfo: RGBDevice?
    var listSSID: [String]?
    var selectedGroup: RGBGroup?
    var listGroupLabel: [String] = []
    var selectedLocation: RGBLocation?
    var detectedDevice: RGBMeshScannedDevice?
    let dropDownGroupName = DropDown()
    let dropDownSSID = DropDown()
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType != .VirtualGroup}
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.viewScanningDevice.isHidden = true
        self.viewDetectingDevice.isHidden = true
        self.viewScanDeviceFail.isHidden = true
        self.viewAddDevice.isHidden = true
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
        btnDropDownSelectedWifi.isEnabled = false
        btnConfirm.isHidden = true
    }
    
    func stopConfigWileDevice() {
        //TODO: - cancelWileConfig
        RGCore.shared.device.cancelWileConfig()
    }
    
    //MARK: - Action
    
    @IBAction func btnClickedScanDeviceIR(_ sender: Any) {
        btnScanDevice.isHidden = true
        viewScanningDevice.isHidden = false
        //TODO: - scanAvailableWileDevice
        RGCore.shared.device.scanAvailableWileDevice(timeout: 60) { response, error in
            if error == nil {
                self.viewDetectingDevice.isHidden = false
                self.viewScanningDevice.isHidden = true
                self.lbNameDevice.text = response?.product?.name
                self.detectedDevice = response
            } else {
                self.viewScanDeviceFail.isHidden = false
                self.viewScanningDevice.isHidden = true
                self.stopConfigWileDevice()
            }
        }
    }
    
    @IBAction override func btnBack(_ sender: Any) {
        dismiss(animated: true)
        stopConfigWileDevice()
    }
    
    @IBAction func btnAddDeviceIR(_ sender: Any) {
        viewDetectingDevice.isHidden = true
        viewAddDevice.isHidden = false
        tfDeviceName.text = detectedDevice?.product?.name
        guard let detectedDevice = detectedDevice else {
            return
        }
        RGCore.shared.device.wileDelegate = self
        //TODO: - startConfigWileDevice
        RGCore.shared.device.startConfigWileDevice(device: detectedDevice)
    }
    
    @IBAction func btnConfirmToAddDevice(_ sender: Any) {
        guard let ssid = btnDropDownSelectedWifi.titleLabel?.text else {
            return
        }
        self.wifiSelectionHandler!(ssid, tfPassword.text ?? "")
        lbPercent.text = "Please, select a wifi"
    }
    
    @IBAction func btnChooseGroupDropDown(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
    @IBAction func btnSelectWifiSSID(_ sender: Any) {
        dropDownSelectedSSID()
        dropDownSSID.show()
        if listSSID?.count != 0 {
            btnConfirm.isHidden = false
        }
    }
}

extension AddDeviceIRVC: RGBWileDelegate {
    // RGBWifiInfo has information such as, ssid: Wifi name, authType: Wifi security type and rssi: the strength of that Wifi signal
    func didScannedWifiInfo(_ listWifiInfos: [RogoCore.RGBWifiInfo], wifiSelectionHandler: ((String, String) -> ())?) {
        self.listSSID = listWifiInfos.filter{ $0.ssid != nil }.map{ $0.ssid!}
        dropDownSelectedSSID()
        btnDropDownSelectedWifi.isEnabled = true
        self.wifiSelectionHandler = wifiSelectionHandler
    }
    // Enter the device name and group ID
    func didConnectDeviceSuccess(setDeviceInfoHandler: ((String?, String?) -> ())?) {
        setDeviceInfoHandler?(self.tfDeviceName.text,self.selectedGroup?.uuid)
    }
    // Where progress percentage is displayed
    func didUpdateProgessing(percent: Int) {
        DispatchQueue.main.async {
            self.lbPercent.text = "\(percent) %"
        }
    }
    
    func didFailedToConnectWifi(_ ssid: String?, _ password: String?, _ wifiConnectionState: RogoCore.RGBWifiConnectionErrorType) {
        switch wifiConnectionState {
            
        case .PASSWORD_WRONG:
            lbPercent.text = "Password wrong"
        case .SSID_NOTFOUND:
            lbPercent.text = "Ssid not found"
        case .SOMETHING_WENT_WRONG:
            lbPercent.text = "Wifi name does not exist"
        default:
            break
        }
    }
    
    func didFinishAddWileDevice(response: RogoCore.RGBDevice?, error: (Error)?) {
        deviceInfo = response
        stopConfigWileDevice()
        checkError(error: error, dismiss: true)
    }
    
    //MARK: - Dropdown
    
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDownSelectedGroup;
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedGroup.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
    func dropDownSelectedSSID () {
        dropDownSSID.anchorView = btnDropDownSelectedWifi
        dropDownSSID.textColor = .white
        dropDownSSID.backgroundColor = .darkGray
        dropDownSSID.dataSource = listSSID ?? []
        dropDownSSID.cellHeight = 70.0
        //
        dropDownSSID.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
        dropDownSSID.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CustomDropDownCell else { return }
            cell.lbWiFiProtectedAccess.text = self.listSSID?[index]
            // Phần này sẽ có bản update trong lần sau và cho phép hiển thị kiểu bảo mật của wifi
            cell.lbWiFiProtectedAccess.text = "WPA2"
        }
        dropDownSSID.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedWifi.setTitle(item, for: .normal)
            //
        }
    }
}
