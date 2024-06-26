//
//  AddDeviceZigbeeVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit
import RogoCore
import DropDown

class AddDeviceZigbeeVC: UIBaseVC {
    
    //MARK: - Outlet
    @IBOutlet weak var tfDeviceName: UITextField!
    @IBOutlet weak var lbPercent: UILabel!
    @IBOutlet weak var viewAddDevice: UIView!
    @IBOutlet weak var lbStateHubDevice: UILabel!
    @IBOutlet weak var btnDropDownSelectedZigbeeDeviceType: UIButton!
    @IBOutlet weak var btnDropDownSelectedHub: UIButton!
    @IBOutlet weak var lbDeviceNameDetect: UILabel!
    @IBOutlet weak var viewChooseZigbeeDeviceType: UIView!
    @IBOutlet weak var btnStartScanDevice: UIButton!
    @IBOutlet weak var viewScanningDevice: UIView!
    @IBOutlet weak var viewDetectDevice: UIView!
    @IBOutlet weak var viewScanDeviceFail: UIView!
    @IBOutlet weak var btnDropDownSelectGroup: UIButton!
    //MARK: - Properties
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType != .VirtualGroup}
    var selectedGroup: RGBGroup?
    var detectedDevice: RGBMeshScannedDevice?
    let dropDownSelectZigbeeDeviceType = DropDown()
    let dropDownSelectHub = DropDown()
    let dropDownGroupName = DropDown()
    var selectedLocation: RGBLocation?
    var listGroupLabel: [String] = []
    var listHubs = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter{$0.productType?.productCategoryType == .USB_DONGLE} ?? []
    @Published var selectedHub: RGBDevice?
    @Published var selectedZigbeeDeviceType: RGBProductType?
    let listDeviceType: [RGBProductType] = [.Zigbee_SwitchScene,
                                            .Zigbee_Plug,
                                            .Zigbee_Switch,
                                            .Zigbee_Motor,
                                            .Zigbee_DoorSensor,
                                            .Zigbee_MotionLightSensor]
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        viewDetectDevice.isHidden = true
        viewScanningDevice.isHidden = true
        viewScanDeviceFail.isHidden = true
        viewChooseZigbeeDeviceType.isHidden = true
        btnStartScanDevice.isHidden = true
        viewAddDevice.isHidden = true
        getUsbDongleStatus()
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
        self.$selectedHub
            .sink { selectedHub in
                if selectedHub != nil {
                    if selectedHub?.meshStatus?.isAvailable == true {
                        self.lbStateHubDevice.text = "Hub device online - ready to add device"
                        self.lbStateHubDevice.textColor = UIColor.green
                        self.viewChooseZigbeeDeviceType.isHidden = false
                    } else {
                        self.lbStateHubDevice.text = "Hub device offline - please check again"
                        self.lbStateHubDevice.textColor = UIColor.systemPink
                    }
                }
            }.store(in: &self.subscriptions)
    }
    // Check whether the Hub is online
    private func getUsbDongleStatus() {
        //TODO: - getZigbeeDongleStatus
        guard let location = RGCore.shared.user.selectedLocation else {
            return
        }
        RGCore.shared.device.getZigbeeDongleStatus(at: location,
                                                   observer: self,
                                                   timeout: 5) {[weak self] status, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if let status = status,
                   let findIndex = self.listHubs.firstIndex(where: {$0.uuid?.uppercased() == status.deviceUUID?.uppercased()}) {
                    var device = self.listHubs[findIndex]
                    device.meshStatus = RGBNetworkStatusMessage(isAvailable: status.isAvailable,
                                                                tId: status.tId,
                                                                uuid: status.deviceUUID)
                    self.listHubs[findIndex] = device
                }
            }
        }
    }
    
    func stopScanZigbeeDevice () {
        guard let selectedHub = selectedHub else {
            return
        }
        //TODO: - stopScanZigbeeDevice
        RGCore.shared.device.stopScanZigbeeDevice(gateWay: selectedHub)
    }
    //MARK: - Action

    @IBAction func btnConfirmAddDevice(_ sender: Any) {
        guard var detectedDevice = detectedDevice, let selectedHub = selectedHub else { return }
        detectedDevice.deviceLabel = tfDeviceName.text
        detectedDevice.group = selectedGroup
        //TODO: - addZigbeeDevice
                RGCore.shared.device.addZigbeeDevice(device: detectedDevice, toHub: selectedHub) { completedPercent in
                    self.lbPercent.text = "\(completedPercent) %"
                } completion: { response, error in
                    self.stopScanZigbeeDevice()
                    self.checkError(error: error, dismiss: true)
                }
    }
    @IBAction func btnBackInView(_ sender: Any) {
        dismiss(animated: true)
        stopScanZigbeeDevice()
    }
    @IBAction func btnStartScanDevice(_ sender: Any) {
        viewScanningDevice.isHidden = false
        guard let selectedHub = selectedHub, let selectedZigbeeDeviceType = selectedZigbeeDeviceType else { return }
        self.btnStartScanDevice.isHidden = true
        self.btnDropDownSelectedHub.isEnabled = false
        self.btnDropDownSelectedZigbeeDeviceType.isEnabled = false
        //TODO: - startScanZigbeeDevice
        RGCore.shared.device.startScanZigbeeDevice(deviceType: selectedZigbeeDeviceType, gateWay: selectedHub, timeout: 60) { response, error in
            if error == nil {
                self.viewScanningDevice.isHidden = true
                self.viewDetectDevice.isHidden = false
                self.lbDeviceNameDetect.text = response?.first?.product?.name
                self.tfDeviceName.text = response?.first?.product?.name
                self.detectedDevice = response?.first
            } else {
                self.viewScanDeviceFail.isHidden = false
                self.viewScanningDevice.isHidden = true
            }
            self.stopScanZigbeeDevice()
        }
    }
    @IBAction func btnClickedSelectedZigbeeDeviceType(_ sender: Any) {
        chooseZigbeeDeviceTypeDropDown()
        dropDownSelectZigbeeDeviceType.show()
    }
    @IBAction func btnClickedSelectedHub(_ sender: Any) {
        chooseHubDropDown()
        dropDownSelectHub.show()
    }
    @IBAction func btnAddDeviceClicked(_ sender: Any) {
        viewAddDevice.isHidden = false
        lbStateHubDevice.isHidden = true
    }
    @IBAction func btnClickedSelectGroup(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
    //MARK: - DropDown
    
    func chooseHubDropDown() {
        dropDownSelectHub.backgroundColor = .darkGray
        dropDownSelectHub.textColor = .white
        dropDownSelectHub.anchorView = btnDropDownSelectedHub;
        let listHubsName = listHubs.map{$0.label ?? ""}
        dropDownSelectHub.dataSource = listHubsName
        dropDownSelectHub.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedHub.setTitle(item, for: .normal)
            self?.selectedHub = self?.listHubs[index]
        }
    }
    func chooseZigbeeDeviceTypeDropDown() {
        dropDownSelectZigbeeDeviceType.backgroundColor = .darkGray
        dropDownSelectZigbeeDeviceType.textColor = .white
        dropDownSelectZigbeeDeviceType.anchorView = btnDropDownSelectedHub;
        dropDownSelectZigbeeDeviceType.dataSource = ["Zigbee Switch Scene","Zigbee Plug","Zigbee Switch","Zigbee Motor","Zigbee Door Sensor","Zigbee Motion Light Sensor"]
        dropDownSelectZigbeeDeviceType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedZigbeeDeviceType.setTitle(item, for: .normal)
            self?.selectedZigbeeDeviceType = self?.listDeviceType[index]
            self?.btnStartScanDevice.isHidden = false
        }
    }
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDownSelectGroup;
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectGroup.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
}

