//
//  EditSmartAutomationAdvanceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/03/2024.
//

import UIKit
import RogoCore
import DropDown

fileprivate let availableDeviceTargetType: [RGBProductCategoryType] = [.ALL, .LIGHT, .SWITCH, .PLUG, .CURTAINS, .GATE, .AC]

class EditSmartAutomationAdvanceVC: UIBaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Outlet
    @IBOutlet weak var collectionViewElement: UICollectionView!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var btnUpdateSmart: UIButton!
    @IBOutlet weak var btnDropDownSelectDevice: UIButton!
    @IBOutlet weak var btnDropDownSelectCommand: UIButton!
    @IBOutlet weak var gradientSlider: GradientSlider!
    @IBOutlet weak var viewBrightnessKelvin: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var kelvinSlider: UISlider!
    @IBOutlet weak var viewSetColor: UIView!
    @IBOutlet weak var btnSelectSmart: UIButton!
    @IBOutlet weak var btnSelectCommand: UIButton!
    @IBOutlet weak var btnSelectDevice: UIButton!
    
    //MARK: - Properties
    var valueColor: [CGFloat]?
    var selectedIndexes: [Int] = []
    var targetElementIds = [""]
    var listDeviceLabel: [String] = []
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    var listDeviceByCommand: [RGBDevice] = []
    var selectedLocation: RGBLocation?
    var listAdvance: [RGBSmart] = []
    let selectSmartDropDown = DropDown()
    var selectCommandDropDown = DropDown()
    var dropDownDevice = DropDown()
    var listSmartName: [String] = []
    @Published var selectedSmart: RGBSmart?
    @Published var selectedCommandType: RGBSmartCmdType?
    @Published var selectedDevice: RGBDevice?
    var listCmds: [RGBSmartCmd] = []
    var listTargetDeviceType: [RGBProductCategoryType] = availableDeviceTargetType
    let listCommandType: [RGBSmartCmdType] = [.onOff(isOn: true), .onOff(isOn: false), .openClose(value: .open), .openClose(value: .close) , .brightnessKelvin(b: nil, k: nil), .color(h: nil, s: nil, v: nil), .controlAirConditioner(isOn: nil, mode: nil, temperature: nil, fan: nil, swing: nil, other: nil)]
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        viewSelectElement.isHidden = true
        viewSetColor.isHidden = true
        viewBrightnessKelvin.isHidden = true
        collectionViewElement.delegate = self
        collectionViewElement.dataSource = self
        collectionViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        gradientSlider?.actionBlock = { [weak self] slider, newValue, finished in
            guard self != nil else {
                return
            }
            let newColor = UIColor(hue: newValue, saturation: 1, brightness: 1.0, alpha: 1.0)
            if finished == true {
                self?.valueColor = RGBHSVColor(color: newColor).hsv
                guard let valueColor = self?.valueColor else {return}
                let hValue = valueColor.first ?? 0.0
                let sValue = valueColor.count > 1 ? valueColor[1] : 0.0
                let vValue = valueColor.count > 2 ? valueColor[2] : 0.0
                self?.selectedCommandType = .color(h: hValue * 10, s: sValue * 1000, v: vValue * 1000)
            }
        }
        for rgbSmart in listAdvance {
            listSmartName.append(rgbSmart.label ?? "")
        }
        self.$selectedDevice
            .sink { dv in
                self.collectionViewElement.reloadData()
            }.store(in: &self.subscriptions)
        guard let listAllDevice = listAllDevice else {return}
        self.$selectedCommandType
            .sink { cmdType in
                    switch cmdType {
                    case .openClose(value: _):
                        self.listTargetDeviceType = [.ALL, .CURTAINS, . GATE, . MOTOR_CONTROLLER]
                    case .onOff(isOn: _):
                        self.listTargetDeviceType = availableDeviceTargetType
                    case .brightnessKelvin(b: _, k: _),
                            .changeBrightness(isIncrease: _),
                            .changeKelvin(isIncrease: _):
                        self.listTargetDeviceType = [.LIGHT]
                        self.viewBrightnessKelvin.isHidden = false
                    case .color(h: _, s: _, v: _):
                        self.listTargetDeviceType = [.LIGHT]
                        self.viewSetColor.isHidden = false
                    case .controlAirConditioner(isOn: _, mode: _, temperature: _, fan: _, swing: _, other: _):
                        self.listTargetDeviceType = [.AC]
                    default:
                        self.listTargetDeviceType = availableDeviceTargetType
                }
                self.listDeviceByCommand = listAllDevice.filter({ dv in
                    guard let deviceProductCategoryType = dv.productType?.productCategoryType else {
                        return false
                    }
                    return self.listTargetDeviceType.contains(deviceProductCategoryType)
                })
                print(self.listDeviceByCommand.count)
                self.listDeviceLabel = []
                for rgbDevice in self.listDeviceByCommand {
                    self.listDeviceLabel.append(rgbDevice.label ?? "")
                }
            }.store(in: &self.subscriptions)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
        // Phần check xem element nào đã được chọn khi tạo
        if let cmds = selectedSmart?.cmds?.first?.cmds {
            let keys = Array(cmds.keys)
            let elementInfoKeys = selectedDevice?.elementInfos?.keys
            
            if keys.indices.contains(indexPath.row), let elementInfoKeys = elementInfoKeys {
                if elementInfoKeys.contains(keys[indexPath.row]) {
                    cell.viewSelectElement.backgroundColor = UIColor.systemYellow
                    selectedIndexes.append(indexPath.row)
                } else {
                    cell.viewSelectElement.backgroundColor = UIColor.white
                }
            }
        }
        let listElementValues = selectedDevice?.elementInfos?.values
        var listElementLabel: [String] = []
        if let listElementValues = listElementValues {
            for elementValue in listElementValues {
                listElementLabel.append(elementValue.label ?? "")
            }
            if listElementLabel.count > 0, !listElementLabel.contains("") {
                cell.lbElement.text = listElementLabel[indexPath.row]
            } else {
                cell.lbElement.text = "Node \(indexPath.row + 1)"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedDevice?.elementInfos?.count ?? 0 > 1 {
            return selectedDevice?.elementInfos?.count ?? 0
        } else {
            viewSelectElement.isHidden = true
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SmartElementCell else {
            return
        }
        let selectedIndex = indexPath.row
        if selectedIndexes.contains(selectedIndex) {
            selectedIndexes.remove(at: selectedIndexes.firstIndex(of: selectedIndex)!)
            cell.viewSelectElement.backgroundColor = UIColor.white
        } else {
            selectedIndexes.append(selectedIndex)
            cell.viewSelectElement.backgroundColor = UIColor.systemYellow
        }
        guard let listElementValues = selectedDevice?.elementInfos?.keys.map({ String($0)}) else {
            return
        }
        targetElementIds = selectedIndexes.compactMap { index in
            guard index < listElementValues.count else {
                return nil
            }
            return listElementValues[index]
        }
    }
    func selectSmartAutomationDropDown() {
        selectSmartDropDown.backgroundColor = .darkGray
        selectSmartDropDown.textColor = .white
        selectSmartDropDown.anchorView = btnSelectSmart
        selectSmartDropDown.dataSource = listSmartName
        selectSmartDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelectSmart.setTitle(item, for: .normal)
            self?.selectedSmart = self?.listAdvance[index]
            guard let selectedSmartCmds = self?.selectedSmart?.cmds else {return}
            self?.listCmds = selectedSmartCmds
        }
    }
    func selectCommandTypeDropDown() {
        selectCommandDropDown.backgroundColor = .darkGray
        selectCommandDropDown.textColor = .white
        selectCommandDropDown.anchorView = btnSelectCommand;
        selectCommandDropDown.dataSource = ["On", "Off", "Open", "Close", "Brightness Kelvin", "Color", "Control Air Conditioner"]
        selectCommandDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelectCommand.setTitle(item, for: .normal)
            self?.selectedCommandType = self?.listCommandType[index]
            self?.btnSelectCommand.isEnabled = false
        }
    }
    
    func selectDeviceDropDown() {
        dropDownDevice.backgroundColor = .darkGray
        dropDownDevice.textColor = .white
        dropDownDevice.anchorView = btnDropDownSelectDevice
        dropDownDevice.dataSource = listDeviceLabel
        dropDownDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectDevice.setTitle(item, for: .normal)
            self?.selectedDevice = self?.listDeviceByCommand[index]
            if self?.selectedDevice?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElement.isHidden = false
            }
            self?.btnDropDownSelectDevice.isEnabled = false
            self?.btnUpdateSmart.isHidden = false
        }
    }
    
    //MARK: - Action
    
    // For editing, it's just as simple as if there's a component inside, we can edit that component
    
    @IBAction func btnClickedConfirmUpdateSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let smartID = selectedSmart?.uuid,
              let deviceID = selectedDevice?.uuid, let cmdType = selectedCommandType else {return}
        if let oldCmd = selectedSmart?.cmds?.first {
            var targetElementIds = [""]
            if self.selectedDevice?.elementIDS?.count == 1 {
                targetElementIds = ["\(self.selectedDevice?.elementIDS?.first ?? 0)"]
            } else {
                targetElementIds = self.targetElementIds
            }
            var cmds: [String : RGBSmartCmdValue] = [:]
            targetElementIds.forEach { elmId in
                cmds[elmId] = RGBSmartCmdValue(cmdType: cmdType)
            }
            let newCmd = RGBSmartCmd(extra: oldCmd.extra,
                                     cmds: cmds,
                                     filter: oldCmd.filter,
                                     smartID: oldCmd.smartID,
                                     target: oldCmd.target,
                                     targetID: deviceID,
                                     userID: oldCmd.userID,
                                     createdAt: oldCmd.createdAt,
                                     updatedAt: oldCmd.updatedAt,
                                     uuid: oldCmd.uuid)
            RGCore.shared.smart.updateSmartCmd(with: smartID, smartCmd: newCmd) { response, error in
                self.checkError(error: error, dismiss: true)
            }
        }
    }
    @IBAction func prgBrightnessSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func prgKelvinSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        selectDeviceDropDown()
        dropDownDevice.show()
    }
    @IBAction func btnClickedSelectCmd(_ sender: Any) {
        selectCommandTypeDropDown()
        selectCommandDropDown.show()
    }
    @IBAction func btnClickedSelectSmart(_ sender: Any) {
        selectSmartAutomationDropDown()
        selectSmartDropDown.show()
    }
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}
