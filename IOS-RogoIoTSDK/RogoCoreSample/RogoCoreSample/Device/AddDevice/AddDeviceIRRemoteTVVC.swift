//
//  AddDeviceIRRemoteTVVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 12/04/2024.
//

import UIKit
import RogoCore
import DropDown

class AddDeviceIRRemoteTVVC: UIBaseVC {

    // MARK: - Outlet
    
    @IBOutlet weak var viewVerifyAddRemoteTv: UIView!
    @IBOutlet weak var lbModelManufacture: UILabel!
    @IBOutlet weak var viewControlVerify: UIView!
    @IBOutlet weak var lbManufacture: UILabel!
    @IBOutlet weak var btnSelectManufactureDropDown: UIButton!
    
    @IBOutlet weak var btnDropDownSelectedHub: UIButton!
    
    @IBOutlet weak var lbStateHubDevice: UILabel!
    
    // MARK: - Properties
    var listIRRemoteInfor: [RGBIrRemoteInfo] = []
    
    var selectedLocation: RGBLocation?
    
    var commandValue: RGBIrRemoteCmdType?
    
    @Published var selectedHub: RGBDevice?
    
    @Published var selectedManufactureType: RGBManufacturer?
    
    @Published var currentSelectedIrInfoIndex: Int = 0
    
    let manufacturer: RGBManufacturer? = nil
    
    var listHubs = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter{$0.productType?.productCategoryType == .IR_DEVICE_CONTROLLER} ?? []
    
    let dropDownSelectHub = DropDown()
    
    let dropDownChooseManufacture = DropDown()
    
    let listTVManufacture: [RGBManufacturer] = [.SAMSUNG,
                                                .SONY,
                                                .LG,
                                                .PANASONIC,
                                                .TCL,
                                                .TOSHIBA]
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewVerifyAddRemoteTv.isHidden = true
        self.$selectedHub
            .sink { selectedHub in
                if selectedHub != nil {
                    if selectedHub?.meshStatus?.isAvailable == true {
                        self.lbStateHubDevice.text = "Hub device online - ready to add device"
                        self.lbStateHubDevice.textColor = UIColor.green
                        self.viewVerifyAddRemoteTv.isHidden = false
                    } else {
                        self.lbStateHubDevice.text = "Hub device offline - please check again"
                        self.lbStateHubDevice.textColor = UIColor.systemPink
                        self.viewVerifyAddRemoteTv.isHidden = true
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
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: selecManufacture, deviceType: .TV, remoteId: rid) { response, error in
                guard let lstCmds = response else {
                    return
                }
                remoteInfo.remoteCmdData = lstCmds
                self.listIRRemoteInfor[selectedIndex] = remoteInfo
            }
        }.store(in: &subscriptions)
    }

    func sendControlCmd(command: RGBIrRemoteCmdType) {
        guard let hub = selectedHub else {return}
        RGCore.shared.device.sendVerifyIrTVCommand(hub: hub,
                                                   commandValue: command,
                                                   remoteInfo: listIRRemoteInfor[currentSelectedIrInfoIndex])
    }
    
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
    
    //MARK: - Action
    @IBAction func btnAddRemoteTV(_ sender: Any) {
        guard let selectedHub = selectedHub, let selectedManufactureType = selectedManufactureType else {return}
        //TODO: - addIrRemote
        RGCore.shared.device.addIrRemote(protocolType: .RGIrRaw,
                                         remoteInfo: listIRRemoteInfor[currentSelectedIrInfoIndex],
                                         manufacturer: selectedManufactureType,
                                         label: "Remote TV \(selectedManufactureType)",
                                         productType: .IR_TV_Remote,
                                         group: nil,
                                         toHub: selectedHub) { response, error in
            self.checkError(error: error, dismiss: true)
        }
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
    @IBAction func btnClickedSelectedManufacture(_ sender: Any) {
        chooseManufactureDropDown()
        dropDownChooseManufacture.show()
    }
    @IBAction func btnClickedSelectedHub(_ sender: Any) {
        chooseHubDropDown()
        dropDownSelectHub.show()
    }
    
    @IBAction func btnRemoteHomeClicked(_ sender: Any) {
        sendControlCmd(command: .HOME)
    }
    
    @IBAction func btnRemotePowerClicked(_ sender: Any) {
        sendControlCmd(command: .POWER)
    }
    
    @IBAction func btnRemoteUpClicked(_ sender: Any) {
        sendControlCmd(command: .UP)
    }
    
    @IBAction func btnRemoteRighClicked(_ sender: Any) {
        sendControlCmd(command: .RIGHT)
    }
    
    @IBAction func btnRemoteDownClicked(_ sender: Any) {
        sendControlCmd(command: .DOWN)
    }
    
    @IBAction func btnRemoteLeftClicked(_ sender: Any) {
        sendControlCmd(command: .LEFT)
    }
    
    @IBAction func btnRemoteCenterClicked(_ sender: Any) {
        sendControlCmd(command: .OK)
    }
    
    @IBAction func btnRemoteMuteClicked(_ sender: Any) {
        sendControlCmd(command: .MUTE)
    }
    
    @IBAction func btnRemoteAllAppClicked(_ sender: Any) {
        sendControlCmd(command: .MENU)
    }
    
    @IBAction func btnRemoteBackClicked(_ sender: Any) {
        sendControlCmd(command: .BACK)
    }
    
    @IBAction func btnRemoteVolumeUpClicked(_ sender: Any) {
        sendControlCmd(command: .VOL_UP)
    }
    
    @IBAction func btnRemoteVolumeDownClicked(_ sender: Any) {
        sendControlCmd(command: .VOL_DOWN)
    }
    
    @IBAction func btnChannelNextClicked(_ sender: Any) {
        sendControlCmd(command: .CHANNEL_UP)
    }
    
    @IBAction func btnChannelPreviousClicked(_ sender: Any) {
        sendControlCmd(command: .CHANNEL_DOWN)
    }
    @IBAction func btnChannelNumberClicked(_ sender: UIButton) {
        if let cmd = RGBIrRemoteCmdType(rawValue: sender.tag) {
            sendControlCmd(command: cmd)
        }
    }
    
    // MARK: - DropDown
    
    func chooseManufactureDropDown() {
        dropDownChooseManufacture.textColor = .white
        dropDownChooseManufacture.backgroundColor = .darkGray
        dropDownChooseManufacture.anchorView = btnSelectManufactureDropDown
        dropDownChooseManufacture.dataSource = ["Samsung", "Sony", "LG", "Panasonic", "TCL", "Toshiba"]
        dropDownChooseManufacture.selectionAction = { [weak self] (index, item) in
            self?.btnSelectManufactureDropDown.setTitle(item, for: .normal)
            self?.selectedManufactureType = self?.listTVManufacture[index]
            guard let selectedManufacture = self?.selectedManufactureType else {return}
            RGCore.shared.device.getListIrRemotesInfoOf(manufacturer: selectedManufacture,
                                                        deviceType: .TV) { response, error in
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
    
    func chooseHubDropDown() {
        dropDownSelectHub.backgroundColor = .darkGray
        dropDownSelectHub.textColor = .white
        dropDownSelectHub.anchorView = btnDropDownSelectedHub
        let listHubsName = listHubs.map{$0.label ?? ""}
        dropDownSelectHub.dataSource = listHubsName
        dropDownSelectHub.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedHub.setTitle(item, for: .normal)
            self?.selectedHub = self?.listHubs[index]
            self?.getHubStatus()
        }
    }
}
