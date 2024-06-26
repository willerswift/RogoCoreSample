//
//  AddSmartScenarioVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 26/02/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

fileprivate let availableDeviceTargetType: [RGBProductCategoryType] = [.ALL, .LIGHT, .SWITCH, .PLUG, .CURTAINS, .GATE, .AC]

class AddSmartScenarioVC: UIBaseVC {
    //MARK: - Outlet
    @IBOutlet weak var collectionViewElement: UICollectionView!
    @IBOutlet weak var btnDropDownSelectDevice: UIButton!
    @IBOutlet weak var btnAddSmartScenario: UIButton!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var viewSelectDevice: UIView!
    @IBOutlet weak var tfNameSmartScenario: UITextField!
    @IBOutlet weak var btnDropDownSelectCommand: UIButton!
    @IBOutlet weak var gradientSlider: GradientSlider!
    @IBOutlet weak var viewBrightnessKelvin: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var kelvinSlider: UISlider!
    @IBOutlet weak var viewSetColor: UIView!
    //MARK: - Properties
    var cmd: RGBSmartCmdValue?
    var targetElementIds = [""]
    var selectedIndexes: [Int] = []
    var valueBrightnessKelvin: RGBValueBrightnessKelvin?
    var valueColor: [CGFloat]?
    var listTargetDeviceType: [RGBProductCategoryType] = availableDeviceTargetType
    var listDeviceLabel: [String] = []
    var listDeviceByCommand: [RGBDevice] = []
    @Published var selectedDevice: RGBDevice?
    @Published var selectedCommandType: RGBSmartCmdType?
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    var selectedLocation: RGBLocation?
    let dropDownCommandType = DropDown()
    let dropDownDevice = DropDown()
    let dropDownSelectElement = DropDown()
    let listCommandType: [RGBSmartCmdType] = [.onOff(isOn: true), .onOff(isOn: false), .openClose(value: .open), .openClose(value: .close) , .brightnessKelvin(b: nil, k: nil), .color(h: nil, s: nil, v: nil), .controlAirConditioner(isOn: nil, mode: nil, temperature: nil, fan: nil, swing: nil, other: nil)]
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        collectionViewElement.dataSource = self
        collectionViewElement.delegate = self
        collectionViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                       forCellWithReuseIdentifier: "SmartElementCell")
        viewSelectDevice.isHidden = true
        viewSelectElement.isHidden = true
        btnAddSmartScenario.isHidden = true
        viewSetColor.isHidden = true
        viewBrightnessKelvin.isHidden = true
        gradientSlider?.hasRainbow = true
        gradientSlider?.continuous = false
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
    
    //MARK: - Action
    
    @IBAction func btnAddScenario(_ sender: Any) {
        // Creating a Smart Scenario will include the following steps: Create a Smart (Create a name and pass in the Location you want to create a Scenario) -> add control commands for it
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let locationId = selectedLocation?.uuid, let nameSmart = tfNameSmartScenario.text else {
            return
        }
        RGCore.shared.smart.addSmart(with: nameSmart,
                                     locationId: locationId,
                                     type: .scenario,
                                     subType: RGBSmartSubType.defaultType) { response, error in
            if error == nil {
                var targetElementIds = [""]
                if self.selectedDevice?.elementIDS?.count == 1 {
                    targetElementIds = ["\(self.selectedDevice?.elementIDS?.first ?? 0)"]
                } else {
                    targetElementIds = self.targetElementIds
                }
                guard let smartID = response?.uuid, let selectedDeviceID = self.selectedDevice?.uuid, let cmdType = self.selectedCommandType else {return}
                RGCore.shared.smart.addSmartCmd(smartId: smartID,
                                                targetId: selectedDeviceID,
                                                targetElementIds: targetElementIds,
                                                cmdValue: RGBSmartCmdValue(cmdType: cmdType, delay: nil,reversing: nil)) { response, error in
                    self.checkError(error: error, dismiss: true)
                }
            }
        }
    }
    
    @IBAction func btnClickedSelectCommandType(_ sender: Any) {
        selectCommandTypeDropDown()
        dropDownCommandType.show()
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        selectDeviceDropDown()
        dropDownDevice.show()
    }
    @IBAction func prgBrightnessSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        valueBrightnessKelvin = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func prgKelvinSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        valueBrightnessKelvin = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    //MARK: - DropDown
    func selectCommandTypeDropDown() {
        dropDownCommandType.backgroundColor = .darkGray
        dropDownCommandType.textColor = .white
        dropDownCommandType.anchorView = btnDropDownSelectCommand;
        dropDownCommandType.dataSource = ["On", "Off", "Open", "Close", "Brightness Kelvin", "Color", "Control Air Conditioner"]
        dropDownCommandType.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectCommand.setTitle(item, for: .normal)
            self?.selectedCommandType = self?.listCommandType[index]
            self?.viewSelectDevice.isHidden = false
            self?.btnDropDownSelectCommand.isEnabled = false
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
            self?.btnAddSmartScenario.isHidden = false
        }
    }
}

extension AddSmartScenarioVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDevice?.elementInfos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
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
    
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}

