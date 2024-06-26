//
//  AddDeviceIRRemoteVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class AddDeviceIRRemoteVC: UIBaseVC {
    
    //MARK: - Outlet
    @IBOutlet weak var viewControlVerify: UIView!
    @IBOutlet weak var viewAddRemoteAc: UIView!
    @IBOutlet weak var lbModelManufacture: UILabel!
    @IBOutlet weak var lbManufacture: UILabel!
    @IBOutlet weak var btnSelectManufactureDropDown: UIButton!
    @IBOutlet weak var collectionViewModeFan: UICollectionView!
    @IBOutlet weak var collectionViewModeAc: UICollectionView!
    @IBOutlet weak var btnAddRemoteLearnIR: UIButton!
    @IBOutlet weak var btnStartLearnIRRemote: UIButton!
    @IBOutlet weak var lbDetectedNameRemote: UILabel!
    @IBOutlet weak var viewLearnIRRemote: UIView!
    @IBOutlet weak var viewAddIRRemoteType: UIView!
    @IBOutlet weak var viewSelectedTypeDevice: UIView!
    @IBOutlet weak var btnDropDownSelectedDeviceTypeAddIRRemote: UIButton!
    @IBOutlet weak var btnDropDownSelectedAddIRRemoteType: UIButton!
    @IBOutlet weak var lbStateHubDevice: UILabel!
    @IBOutlet weak var btnDropDownSelectedHub: UIButton!
    //MARK: - Properties
    let listAcModes = RGBIrAcModeType.allCases.filter{$0.rawValue >= 0}
    let listAcFanModes = RGBIrAcFanType.allCases.filter{$0.rawValue >= 0}
    var listIRRemoteInfor: [RGBIrRemoteInfo] = []
    var acManufacture: RGBManufacturer?
    var irInfos: RGBIrRemoteInfo?
    @Published var selectedHub: RGBDevice?
    @Published var selectedModeAC: Int = 0
    @Published var selectedModeFan: Int = 0
    @Published var mode: RGBIrAcModeType = .AC_MODE_AUTO
    @Published var fanSpeed: RGBIrAcFanType = .FAN_SPEED_LOW
    @Published var currentSelectedIrInfoIndex: Int = 0
    @Published var canChangeTemp: Bool = false
    @Published var canChangeFanSpeed: Bool = false
    @Published var isOn: Bool = false
    @Published var currentTemperature: Int = 16
    @Published var selectedManufactureType: RGBManufacturer?
    @Published var minTemp: Int = 16
    @Published var maxTemp: Int = 30
    var selectedDeviceType: RGBProductCategoryType?
    var selectedLocation: RGBLocation?
    let dropDownSelectHub = DropDown()
    let dropDownChooseDeviceType = DropDown()
    let dropDownChooseAddIRRemoteType = DropDown()
    let dropDownChooseManufacture = DropDown()
//    let listProductType: [RGBProductCategoryType] = [.AC, .TV, .FAN]
    let listProductType: [RGBProductCategoryType] = [.AC]
    let listACManufacture: [RGBManufacturer] = [.CASPER, .DAIKIN, .PANASONIC, .SAMSUNG, .MITSUBISHI, .TOSHIBA, .MIDEA, .GREE, .LG, .SHARP, .HITACHI, .HAIER, .CARRIER, .CORONA, .FUJITSU, .VESTEL]
    var listHubs = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter{$0.productType?.productCategoryType == .IR_DEVICE_CONTROLLER} ?? []
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAddRemoteAc.isHidden = true
        btnAddRemoteLearnIR.isHidden = true
        viewLearnIRRemote.isHidden = true
        viewSelectedTypeDevice.isHidden = true
        viewAddIRRemoteType.isHidden = true
        collectionViewModeAc.delegate = self
        collectionViewModeAc.dataSource = self
        collectionViewModeAc.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        collectionViewModeFan.delegate = self
        collectionViewModeFan.dataSource = self
        collectionViewModeFan.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        getHubStatus()
        self.$selectedHub
            .sink { selectedHub in
                if selectedHub != nil {
                    if selectedHub?.meshStatus?.isAvailable == true {
                        self.lbStateHubDevice.text = "Hub device online - ready to add device"
                        self.lbStateHubDevice.textColor = UIColor.green
                    } else {
                        self.lbStateHubDevice.text = "Hub device offline - please check again"
                        self.lbStateHubDevice.textColor = UIColor.systemPink
                    }
                }
            }.store(in: &self.subscriptions)
        self.$currentSelectedIrInfoIndex.sink { selectedIndex in
            guard self.listIRRemoteInfor.count > 0,
                  selectedIndex >= 0,
                  selectedIndex < self.listIRRemoteInfor.count else {
                return
            }
            var remoteInfo = self.listIRRemoteInfor[selectedIndex]
            
            DispatchQueue.main.async {
                self.lbModelManufacture.text = "Controller Code: \(self.currentSelectedIrInfoIndex + 1)"
            }
            guard let rid = remoteInfo.rid else {
                return
            }
            guard let selecManufacture = self.selectedManufactureType else {
                return
            }
            // Get the list of corresponding control commands
            // For the TV remote we use: deviceType: .TV
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: selecManufacture, deviceType: .AC, remoteId: rid) { response, error in
                guard let lstCmds = response else {
                    return
                }
                remoteInfo.remoteCmdData = lstCmds
                self.listIRRemoteInfor[selectedIndex] = remoteInfo
            }
        }.store(in: &subscriptions)
    }
    // Check whether the Hub is online
    private func getHubStatus() {
        RGCore.shared.device.getIRHubAvailable(observer: nil,
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
            }
        }
    }
    func setIRRemoteLearningMode() {
        btnStartLearnIRRemote.isHidden = true
        guard let selectedHub = selectedHub else {
            return
        }
        //TODO: - setIRRemoteLearningModeFor
        RGCore.shared.device.setIRRemoteLearningModeFor(deviceType: .AC,
                                                        hub: selectedHub,
                                                        observer: self,
                                                        isEnable: true,
                                                        timeout: 3) { [self] response, error in
            if let res = response as? RGBIrRemoteInfo,
               let irAcProtocol = res.acProtocol,
               let manufacture = RGBManufacturer.getManufacturerBy(irProtocol: irAcProtocol) {
                acManufacture = manufacture
                irInfos = res
                lbDetectedNameRemote.text = "\(String(describing: manufacture))"
                btnAddRemoteLearnIR.isHidden = false
            } else {
                lbDetectedNameRemote.text = "No response seen, try again !"
                btnStartLearnIRRemote.isHidden = false
            }
        }
    }
    func changeMode() {
        // Send cmd control change mode
        if let availableModes = self.listIRRemoteInfor[currentSelectedIrInfoIndex].acModes {
            self.updateAvailableFunctionByMode()
            sendControlCmd()
        }
    }
    func changeFanSpeed() {
        // Send cmd control change fan speed
        if let availableFanSpeeds = self.listIRRemoteInfor[currentSelectedIrInfoIndex].availableFanValues {
            sendControlCmd()
        }
    }
    private func updateAvailableFunctionByMode() {
        self.canChangeTemp = self.listIRRemoteInfor[currentSelectedIrInfoIndex].tempAllowInModes?.contains(self.mode) ?? false
        self.canChangeFanSpeed = self.listIRRemoteInfor[currentSelectedIrInfoIndex].fanpAllowInModes?.contains(self.mode) ?? false
    }
    private func sendControlCmd(isOn: Bool? = nil) {
        
        guard let hub = RGCore.shared.user.selectedLocation?.allDevicesInLocation.first(where: {$0.uuid == self.selectedHub?.uuid}) else {
            return
        }
        //TODO: - sendVerifyIrAcRemoteCommand
        // For the TV remote we use: RGCore.shared.device.sendVerifyIrTVCommand(hub: RGBDevice, commandValue: RGBIrRemoteCmdType, remoteInfo: RGBIrRemoteInfo)
        if isOn == false {
            RGCore.shared.device.sendVerifyIrAcRemoteCommand(hub: hub,
                                                             isSetPowerOn: isOn,
                                                             mode: nil,
                                                             temperature: nil,
                                                             fanSpeed: nil,
                                                             remoteInfo: listIRRemoteInfor[currentSelectedIrInfoIndex])
        } else {
            RGCore.shared.device.sendVerifyIrAcRemoteCommand(hub: hub,
                                                             isSetPowerOn: self.isOn,
                                                             mode: self.mode,
                                                             temperature: self.currentTemperature,
                                                             fanSpeed: self.fanSpeed,
                                                             remoteInfo: listIRRemoteInfor[currentSelectedIrInfoIndex])
        }
        
    }
    //MARK: - Action
    
    @IBAction func btnOffAc(_ sender: Any) {
        sendControlCmd(isOn: false)
    }
    @IBAction func btnOnAc(_ sender: Any) {
        sendControlCmd(isOn: true)
    }
    @IBAction func btnTempDown(_ sender: Any) {
        if currentTemperature > minTemp {
            currentTemperature -= 1
            sendControlCmd()
        }
    }
    @IBAction func btnTempUp(_ sender: Any) {
        if currentTemperature < maxTemp {
            currentTemperature += 1
            sendControlCmd()
        }
    }
    @IBAction func btnClickedAddRemote(_ sender: Any) {
        guard let irInfos = irInfos, let acManufacture = acManufacture, let selectedHub = selectedHub else {return}
        //TODO: - addIrRemote
        // For the TV remote, we do the same thing, only the two components are different when adding: productType: .IR_TV_Remote and protocolType: .RGIrRawZip
        RGCore.shared.device.addIrRemote(protocolType: .RGIrPrtcAc,
                                         remoteInfo: irInfos,
                                         manufacturer: acManufacture,
                                         label: "Remote AC \(acManufacture)",
                                         productType: .IR_AirCondition_Remote,
                                         group: nil,
                                         toHub: selectedHub) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnStartLearnIRRemote(_ sender: Any) {
        setIRRemoteLearningMode()
    }
    @IBAction func btnClickedSelectedAddIRRemoteType(_ sender: Any) {
        chooseAddIRRemoteTypeDropDown()
        dropDownChooseAddIRRemoteType.show()
    }
    @IBAction func btnClickSelectedTypeDeviceAddIRRemote(_ sender: Any) {
        chooseDeviceTypeDropDown()
        dropDownChooseDeviceType.show()
    }
    @IBAction func btnClickedSelectedHub(_ sender: Any) {
        chooseHubDropDown()
        dropDownSelectHub.show()
    }
    @IBAction func btnClickedSelectManufacture(_ sender: Any) {
        chooseManufactureDropDown()
        dropDownChooseManufacture.show()
    }
    @IBAction func btnPeviousRemoteAc(_ sender: Any) {
        if currentSelectedIrInfoIndex < listIRRemoteInfor.count - 1 {
            if currentSelectedIrInfoIndex > 0 {
                currentSelectedIrInfoIndex -= 1
            } else {
            }
        } else {
//            currentSelectedIrInfoIndex = listIRRemoteInfor.count - 1
        }
    }
    @IBAction func btnNextRemoteAc(_ sender: Any) {
        if currentSelectedIrInfoIndex < listIRRemoteInfor.count - 1 {
            currentSelectedIrInfoIndex += 1
        } else {
            currentSelectedIrInfoIndex = 0
        }
    }
    @IBAction func btnClickedConfirmAddIRRemote(_ sender: Any) {
        if listIRRemoteInfor[currentSelectedIrInfoIndex].protocolCtlType == .RGIrPrtcAc {
            var chooseIrInfo = listIRRemoteInfor[currentSelectedIrInfoIndex]
            guard let hub = selectedHub, let selecManufacture = selectedManufactureType, let name = lbManufacture.text else {return}
            chooseIrInfo.setValueInfo(tempRange: [minTemp, maxTemp],
                                      acModes: listAcModes,
                                      availableFanValues: listAcFanModes,
                                      tempAllowInModes: listAcModes,
                                      fanAllowInModes: listAcModes)
            //TODO: - addIrRemote
            RGCore.shared.device.addIrRemote(protocolType: .RGIrPrtcAc,
                                             remoteInfo: chooseIrInfo,
                                             manufacturer: selecManufacture,
                                             label: "AC \(name)",
                                             productType: .IR_AirCondition_Remote,
                                             group: nil,
                                             toHub: hub) { response, error in
                self.checkError(error: error, dismiss: true)
            }
        } else {
            guard let selecManufacture = selectedManufactureType, let name = lbManufacture.text, let hub = selectedHub else {
                return
            }
            RGCore.shared.device.addIrRemote(protocolType: .RGIrRawZip,
                                             remoteInfo: listIRRemoteInfor[currentSelectedIrInfoIndex],
                                             manufacturer: selecManufacture,
                                             label: "AC \(name)",
                                             productType: .IR_AirCondition_Remote,
                                             group: nil,
                                             toHub: hub) { response, error in
                self.checkError(error: error, dismiss: true)
            }
        }
    }
    //MARK: - DropDown
    func chooseHubDropDown() {
        dropDownSelectHub.backgroundColor = .darkGray
        dropDownSelectHub.textColor = .white
        dropDownSelectHub.anchorView = btnDropDownSelectedHub
        let listHubsName = listHubs.map{$0.label ?? ""}
        dropDownSelectHub.dataSource = listHubsName
        dropDownSelectHub.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedHub.setTitle(item, for: .normal)
            self?.selectedHub = self?.listHubs[index]
            self?.viewSelectedTypeDevice.isHidden = false
        }
    }
    func chooseDeviceTypeDropDown() {
        dropDownChooseDeviceType.backgroundColor = .darkGray
        dropDownChooseDeviceType.textColor = .white
        dropDownChooseDeviceType.anchorView = btnDropDownSelectedDeviceTypeAddIRRemote
        dropDownChooseDeviceType.dataSource = ["IR AirCondition Remote"]
        dropDownChooseDeviceType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedDeviceTypeAddIRRemote.setTitle(item, for: .normal)
            self?.selectedDeviceType = self?.listProductType[index]
            self?.viewAddIRRemoteType.isHidden = false
        }
    }
    func chooseAddIRRemoteTypeDropDown() {
        dropDownChooseAddIRRemoteType.backgroundColor = .darkGray
        dropDownChooseAddIRRemoteType.textColor = .white
        dropDownChooseAddIRRemoteType.anchorView = btnDropDownSelectedAddIRRemoteType
        dropDownChooseAddIRRemoteType.dataSource = ["Add devices manually","Learn IR Remote"]
        dropDownChooseAddIRRemoteType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedAddIRRemoteType.setTitle(item, for: .normal)
            if index == 0 {
                self?.viewLearnIRRemote.isHidden = true
                self?.viewAddRemoteAc.isHidden = false
            } else {
                self?.viewLearnIRRemote.isHidden = false
            }
        }
    }
    func chooseManufactureDropDown() {
        dropDownChooseManufacture.textColor = .white
        dropDownChooseManufacture.backgroundColor = .darkGray
        dropDownChooseManufacture.anchorView = btnSelectManufactureDropDown
        dropDownChooseManufacture.dataSource = ["Casper", "Daikin", "Panasonic", "Samsung", "Mitsubishi", "Toshiba", "Media", "Gree", "LG", "Sharp", "Hitachi", "Haier", "Carrier", "Corona", "Fujitsu", "Vestel"]
        dropDownChooseManufacture.selectionAction = { [weak self] (index, item) in
            self?.btnSelectManufactureDropDown.setTitle(item, for: .normal)
            self?.selectedManufactureType = self?.listACManufacture[index]
            guard let selectedManufacture = self?.selectedManufactureType else {return}
            RGCore.shared.device.getListIrRemotesInfoOf(manufacturer: selectedManufacture,
                                                        deviceType: .AC) { response, error in
                guard let listRemotes = response, listRemotes.count > 0 else {return}
                self?.listIRRemoteInfor = listRemotes
                self?.currentSelectedIrInfoIndex = 0
                DispatchQueue.main.async {
                    self?.lbManufacture.text = item
                    self?.viewControlVerify.isHidden = true
                }
            }
        }
    }
}

extension AddDeviceIRRemoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewModeAc {
            return 5
        } else {
            return 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewModeAc {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
            if indexPath.row == 0 {
                cell.lbElement.text = "Auto"
            } else if indexPath.row == 1 {
                cell.lbElement.text = "Dry"
            } else if indexPath.row == 2 {
                cell.lbElement.text = "Cool"
            } else if indexPath.row == 3 {
                cell.lbElement.text = "Fan"
            } else {
                cell.lbElement.text = "Heat"
            }
            cell.viewSelectElement.backgroundColor = indexPath.row == selectedModeAC ? UIColor.systemYellow : UIColor.white
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
            if indexPath.row == 0 {
                cell.lbElement.text = "Auto"
            } else if indexPath.row == 1 {
                cell.lbElement.text = "Low"
            } else if indexPath.row == 2 {
                cell.lbElement.text = "Normal"
            } else {
                cell.lbElement.text = "High"
            }
            cell.viewSelectElement.backgroundColor = indexPath.row == selectedModeFan ? UIColor.systemYellow : UIColor.white
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewModeAc {
            selectedModeAC = indexPath.row
            collectionViewModeAc.reloadData()
            if indexPath.row == 0 {
                mode = .AC_MODE_AUTO
                changeMode()
            } else if indexPath.row == 1 {
                mode = .AC_MODE_DRY
                changeMode()
            } else if indexPath.row == 2 {
                mode = .AC_MODE_COOLING
                changeMode()
            } else if indexPath.row == 3 {
                mode = .AC_MODE_FAN
                changeMode()
            } else {
                mode = .AC_MODE_HEATING
                changeMode()
            }
        } else {
            selectedModeFan = indexPath.row
            collectionViewModeFan.reloadData()
            if indexPath.row == 0 {
                fanSpeed = .FAN_SPEED_AUTO
                changeFanSpeed()
            } else if indexPath.row == 1 {
                fanSpeed = .FAN_SPEED_LOW
                changeFanSpeed()
            } else if indexPath.row == 2 {
                fanSpeed = .FAN_SPEED_NORMAL
                changeFanSpeed()
            } else {
                fanSpeed = .FAN_SPEED_HIGH
                changeFanSpeed()
            }
        }
    }
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewModeAc {
            return CGSize(width: (collectionView.frame.size.width - 50)/5, height: 45.0)
        } else {
            return CGSize(width: (collectionView.frame.size.width - 40)/4, height: 45.0)
        }
    }
}
