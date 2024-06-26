//
//  AddDeviceBLEVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit
import RogoCore
import DropDown

class AddDeviceBLEVC: UIBaseVC {
    
    //MARK: - Outlet
    @IBOutlet weak var lbSelectHubDevice: UILabel!
    @IBOutlet weak var lbStateHubDevice: UILabel!
    @IBOutlet weak var viewProgressAddDevice: UIView!
    @IBOutlet weak var tfNameDevice: UITextField!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lbPercent: UILabel!
    @IBOutlet weak var viewAddDevice: UIView!
    @IBOutlet weak var viewScanDeviceFail: UIView!
    @IBOutlet weak var btnScanDevice: UIButton!
    @IBOutlet weak var btnDropDownSelectedHub: UIButton!
    @IBOutlet weak var viewScanningDevice: UIView!
    @IBOutlet weak var viewDetectingDevice: UIView!
    @IBOutlet weak var lbNameDetectingDevice: UILabel!
    
    //MARK: - Properties
    
    var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType != .VirtualGroup}
    var detectedDevice: RGBMeshScannedDevice?
    var selectedLocation: RGBLocation?
    var listHubs = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter{$0.productType?.productCategoryType == .MEDIA_BOX} ?? []
    let dropDownSelectHub = DropDown()
    @Published var selectedHub: RGBDevice?
    var selectedGroup: RGBGroup?
    let dropDownGroupName = DropDown()
    var listGroupLabel: [String] = []
    var setDeviceInfoHandler: ((String?, String?) -> ())?
    var selectedGroupID: String?
    var deviceInfo: RGBDevice?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        btnScanDevice.isHidden = true
        viewScanningDevice.isHidden = true
        viewDetectingDevice.isHidden = true
        viewScanDeviceFail.isHidden = true
        viewAddDevice.isHidden = true
        viewProgressAddDevice.isHidden = true
        guard let listGroup = listGroup else {return}
        for rgbGroup in listGroup {
            listGroupLabel.append(rgbGroup.label ?? "")
        }
        getHubStatus()
        self.$selectedHub
        // A very important thing when adding a BLE device is to check whether the central controller we choose to add is online or not.
            .sink { selectedHub in
                if selectedHub != nil {
                    if selectedHub?.meshStatus?.isAvailable == true {
                        self.lbStateHubDevice.text = "Hub device online - ready to add device"
                        self.lbStateHubDevice.textColor = UIColor.green
                        self.btnScanDevice.isHidden = false
                    } else {
                        self.lbStateHubDevice.text = "Hub device offline - please check again"
                        self.lbStateHubDevice.textColor = UIColor.systemPink
                    }
                }
            }.store(in: &self.subscriptions)
        
    }
    private func getHubStatus() {
        RGCore.shared.device.getHubsStatus(hubs: listHubs,
                                           observer: self,
                                           timeout: 5) {[weak self] status, error in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if let status = status,
                   let findIndex = self.listHubs.firstIndex(where: {
                       $0.uuid?.uppercased() == status.uuid?.uppercased()
                       || $0.mac?.uppercased() == status.mac?.uppercased()
                       
                   }) {
                    var device = self.listHubs[findIndex]
                    device.meshStatus = status
                    self.listHubs[findIndex] = device
                }
                //
            }
        }
    }
    func stopScanBLEDevice() {
        //TODO: - stopScanBleDevice
        RGCore.shared.device.stopScanBleDevice()
    }
    //MARK: -Action
    
    @IBAction func btnChooseGroupDropDown(_ sender: Any) {
        chooseGroupDropDown()
        dropDownGroupName.show()
    }
    @IBAction func btnStartScanDevice(_ sender: Any) {
        viewScanDeviceFail.isHidden = true
        viewScanningDevice.isHidden = false
        btnScanDevice.isHidden = true
        //TODO: - scanAvailableBleDevice
        RGCore.shared.device.scanAvailableBleDevice(timeout: 120) { response, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.viewScanningDevice.isHidden = true
                    self.viewDetectingDevice.isHidden = false
                    self.lbNameDetectingDevice.text = response?.product?.name
                }
            } else {
                self.viewScanDeviceFail.isHidden = false
                self.viewScanningDevice.isHidden = true
            }
            self.detectedDevice = response
            self.stopScanBLEDevice()
        }
    }
    @IBAction func btnClickedSelectedHub(_ sender: Any) {
        chooseHubDropDown()
        dropDownSelectHub.show()
    }
    @IBAction func btnNextToAddDevice(_ sender: Any) {
        viewAddDevice.isHidden = false
        tfNameDevice.text = detectedDevice?.product?.name
        btnDropDownSelectedHub.isEnabled = false
        lbSelectHubDevice.isHidden = true
        btnDropDownSelectedHub.isHidden = true
        lbStateHubDevice.isHidden = true
    }
    @IBAction func btnBackInView(_ sender: Any) {
        dismiss(animated: true)
        stopScanBLEDevice()
    }
    @IBAction func btnConfirmAddDevice(_ sender: Any) {
        self.viewProgressAddDevice.isHidden = false
        guard let detectedDevice = detectedDevice, let selectedHub = selectedHub else {
            return
        }
        RGCore.shared.device.meshDelegate = self
        // After scanAvailableBleDevice has a response, we will take that response to add that device, remember to transmit it to the central controller we have chosen.
        RGCore.shared.device.addMeshDevice(device: detectedDevice, toHub: selectedHub, didUpdateProgessing: nil, completion: nil)
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
    func chooseGroupDropDown() {
        dropDownGroupName.backgroundColor = .darkGray
        dropDownGroupName.textColor = .white
        dropDownGroupName.anchorView = btnDropDown;
        dropDownGroupName.dataSource = listGroupLabel
        dropDownGroupName.selectionAction = { [weak self] (index, item) in
            self?.btnDropDown.setTitle(item, for: .normal)
            self?.selectedGroup = self?.listGroup?[index]
        }
    }
}
extension AddDeviceBLEVC: RGBMeshDelegate {
    func didUpdateProgessing(percent: Int) {
        DispatchQueue.main.async {
            self.lbPercent.text = "\(percent) %"
        }
    }
    func didProvisioningSuccess(setDeviceInfoHandler: ((String?, String?) -> ())?) {
        setDeviceInfoHandler?(self.tfNameDevice.text,self.selectedGroup?.uuid)
    }
    func didFinishAddMeshDevice(response: RogoCore.RGBDevice?, error: (Error)?) {
        deviceInfo = response
        checkError(error: error, dismiss: true)
    }
}
