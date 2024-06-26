//
//  AddDeviceIRRemoteFanVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/04/2024.
//

import UIKit
import DropDown
import RogoCore
import Combine

class AddDeviceIRRemoteFanVC: UIBaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlet
    
    @IBOutlet weak var lbNoti: UILabel!
    @IBOutlet weak var btnAddRemote: UIButton!
    
    @IBOutlet weak var viewDetectCmd: UIView!
    
    @IBOutlet weak var viewStartDetectRemote: UIView!
    
    @IBOutlet weak var viewSelectModeFan: UIView!
    
    @IBOutlet weak var lbStateHubDevice: UILabel!
    
    @IBOutlet weak var btnDropDownSelectedMode: UIButton!
    
    @IBOutlet weak var btnDropDownSelectedHub: UIButton!
    
    @IBOutlet weak var collectionViewModeFan: UICollectionView!
    
    //MARK: - Properties
    
    var lstDetectedRemoteCommand: [RGBIrFanRemoteInfoMessage] = []
    
    @Published var selectedModes: [RGBIrLearningCmdType] = []
    
    var selectedLocation: RGBLocation?
    
    var listHubs = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter{$0.productType?.productCategoryType == .IR_DEVICE_CONTROLLER} ?? []
    
    let listOptions: [RGBIrLearningCmdType] = RGBIrLearningCmdType.getListFanRemoteCmd()
    
    let dropDownSelectHub = DropDown()
    
    let dropDownSelectMode = DropDown()
    
    @Published var selectedHub: RGBDevice?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDetectCmd.isHidden = true
        viewStartDetectRemote.isHidden = true
        viewSelectModeFan.isHidden = true
        collectionViewModeFan.dataSource = self
        collectionViewModeFan.delegate = self
        collectionViewModeFan.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                       forCellWithReuseIdentifier: "SmartElementCell")
        getHubStatus()
        self.$selectedHub
            .sink { selectedHub in
                if selectedHub != nil {
                    if selectedHub?.meshStatus?.isAvailable == true {
                        self.lbStateHubDevice.text = "Hub device online - ready to add device"
                        self.lbStateHubDevice.textColor = UIColor.green
                        self.viewSelectModeFan.isHidden = false
                    } else {
                        self.lbStateHubDevice.text = "Hub device offline - please check again"
                        self.lbStateHubDevice.textColor = UIColor.systemPink
                        self.viewSelectModeFan.isHidden = true
                    }
                }
            }.store(in: &self.subscriptions)
        self.$selectedModes
            .sink { [weak self] _ in
                self?.collectionViewModeFan.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
        let mode = listOptions[indexPath.row]
        cell.lbElement.text = "\(mode)"
        cell.viewSelectElement.backgroundColor = selectedModes.contains(mode) ? .systemYellow : .white
        return cell
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
    
    //MARK: - Action
    
    @IBAction func btnClickedAddRemoteFan(_ sender: Any) {
        guard let selectedHub = selectedHub else {return}
        //TODO: - addIrFanRemote
        RGCore.shared.device.addIrFanRemote(remoteInfos: lstDetectedRemoteCommand, label: "Remote Fan", group: nil, toHub: selectedHub) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnClickedSelectedModeToLearn(_ sender: Any) {
        chooseModeDropDown()
        dropDownSelectMode.show()
    }
    @IBAction func btnClickedSelectedHub(_ sender: Any) {
        chooseHubDropDown()
        dropDownSelectHub.show()
    }
    @IBAction func btnConfirmSelectMode(_ sender: Any) {
        viewStartDetectRemote.isHidden = false
        viewSelectModeFan.isHidden = true
    }
    //MARK: - DropDown
    
    func chooseModeDropDown() {
        dropDownSelectMode.backgroundColor = .darkGray
        dropDownSelectMode.textColor = .white
        dropDownSelectMode.anchorView = btnDropDownSelectedMode
        dropDownSelectMode.dataSource = selectedModes.map{"\($0)"}
        dropDownSelectMode.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectedMode.setTitle(item, for: .normal)
            self?.viewDetectCmd.isHidden = false
            self?.startDetectingIrCmd()
            self?.selectedModes.remove(at: index)
            self?.lbNoti.text = "Point the controller at the infrared control device and press the corresponding button you have chosen"
            //            self?.selectedHub = self?.listHubs[index]
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
        }
    }
    
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var listSelected = self.selectedModes
        let mode = listOptions[indexPath.row]
        
        if let alredayIndex = selectedModes.firstIndex(of: mode){
            listSelected.remove(at: alredayIndex)
        } else {
            listSelected.append(mode)
        }
        // only power or on/off
        if mode == .POWER_SWITCH {
            if let onCmdIndx = listSelected.firstIndex(of: .POWER_ON) {
                listSelected.remove(at: onCmdIndx)
            }
            if let offCmdIndx = listSelected.firstIndex(of: .POWER_OFF) {
                listSelected.remove(at: offCmdIndx)
            }
        } else if mode == .POWER_ON || mode == .POWER_OFF,
                  let powerIndx = listSelected.firstIndex(of: .POWER_SWITCH) {
            listSelected.remove(at: powerIndx)
        }
        self.selectedModes = listSelected
    }
    
    //MARK: - Method
    fileprivate func startDetectingIrCmd() {
        guard let selectedHub = selectedHub else {return}
        //TODO: - setIRRemoteLearningModeFor
        RGCore.shared.device.setIRRemoteLearningModeFor(deviceType: .FAN,
                                                        hub: selectedHub,
                                                        observer: self,
                                                        isEnable: true,
                                                        timeout: 3) { [weak self] response, error in
            guard let self = self,
                  let res = response as? RGBIrFanRemoteInfoMessage else {
                return
            }
            lstDetectedRemoteCommand.append(res)
            lbNoti.text = "Control command detected, select next control command"
            
            if selectedModes.count == 0 {
                btnAddRemote.isHidden = false
            }
        }
    }
}

public enum RGBIrLearningCmdType: Int, CaseIterable {

    case POWER_ON = 1
    case POWER_OFF = 0
    case POWER_SWITCH = 2
    
    case NUM_0 = 10
    case NUM_1 = 11
    case NUM_2 = 12
    case NUM_3 = 13
    case NUM_4 = 14
    case NUM_5 = 15
    case NUM_6 = 16
    case NUM_7 = 17
    case NUM_8 = 18
    case NUM_9 = 19
    
    case FAN_SPEED = 63
    case MODE = 32
    
    case SLEEP = 60
    case SWING = 61
    case TIMING = 66
    
    public static func getListFanRemoteCmd() -> [RGBIrLearningCmdType] {
        return [.POWER_SWITCH,
                .POWER_ON,
                .POWER_OFF,
                .MODE,
                .FAN_SPEED,
                .SWING,
                .SLEEP,
                .TIMING,
                .NUM_0,
                .NUM_1,
                .NUM_2,
                .NUM_3,
                .NUM_4,
                .NUM_5]
    }
}

