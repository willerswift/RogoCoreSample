//
//  AddSmartAutomationAdvanceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 19/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

fileprivate let availableDeviceTargetType: [RGBProductCategoryType] = [.ALL, .LIGHT, .SWITCH, .PLUG, .CURTAINS, .GATE, .AC]

class AddSmartAutomationAdvanceVC: UIBaseVC {

    //MARK: - Outlet
    @IBOutlet weak var tfNameSmart: UITextField!
    @IBOutlet weak var btnDropDownSelectCommandDevice: UIButton!
    @IBOutlet weak var btnAddSmart: UIButton!
    @IBOutlet weak var viewSelectDevice: UIView!
    @IBOutlet weak var btnDropDownSelectCommand: UIButton!
    @IBOutlet weak var viewSelectEmlementCmd: UIView!
    @IBOutlet weak var gradientSlider: GradientSlider!
    @IBOutlet weak var viewBrightnessKelvin: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var kelvinSlider: UISlider!
    @IBOutlet weak var viewSetColor: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewAddCmd: UIView!
    @IBOutlet weak var tfTimeHoldTheState: UITextField!
    @IBOutlet weak var btnStartTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeHour: UIButton!
    @IBOutlet weak var btnStartTimeHour: UIButton!
    @IBOutlet weak var btnSelectState: UIButton!
    @IBOutlet weak var collectionViewSelectElement: UICollectionView!
    @IBOutlet weak var heightSelectElement: NSLayoutConstraint!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var btnSelectDeviceDropDown: UIButton!
    
    //MARK: - Properties
    var startTime: Int?
    var endTime: Int?
    @Published var hourStartTime: Int = 0
    @Published var minuteStartTime: Int = 0
    @Published var hourEndTime: Int = 0
    @Published var minuteEndTime: Int = 0
    @Published var selectedCommandType: RGBSmartCmdType?
    var listSmartTriggerEventType: [RGBSmartTriggerEventType] = []
    var listDeviceSupport: [RGBDevice] = []
    var selectedLocation: RGBLocation?
    var selectedAutomationType: RGBAutomationEventType?
    let dropDownDevice = DropDown()
    let dropDownCommanDevice = DropDown()
    let chooseStateDropDown = DropDown()
    let chooseHourStartTimeDropDown = DropDown()
    let chooseHourEndTimeDropDown = DropDown()
    let chooseMinuteStartTimeDropDown = DropDown()
    let chooseeMinuteEndTimeDropDown = DropDown()
    let dropDownCommandType = DropDown()
    var valueBrightnessKelvin: RGBValueBrightnessKelvin?
    var valueColor: [CGFloat]?
    @Published var selectedDevice: RGBDevice?
    @Published var selectedCommandDevice: RGBDevice?
    var selectedIndex: Int?
    var triggerElementId: Int?
    var selectedState: RGBSmartTriggerEventType?
    var listTargetDeviceType: [RGBProductCategoryType] = availableDeviceTargetType
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    var listDeviceByCommand: [RGBDevice] = []
    var listDeviceLabel: [String] = []
    let listCommandType: [RGBSmartCmdType] = [.onOff(isOn: true), .onOff(isOn: false), .openClose(value: .open), .openClose(value: .close) , .brightnessKelvin(b: 500, k: 4600), .color(h: nil, s: nil, v: nil), .controlAirConditioner(isOn: nil, mode: nil, temperature: nil, fan: nil, swing: nil, other: nil)]
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        collectionViewSelectElement.delegate = self
        collectionViewSelectElement.dataSource = self
        collectionViewSelectElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        btnAddSmart.isHidden = true
        viewSelectDevice.isHidden = true
        viewSelectEmlementCmd.isHidden = true
        viewBrightnessKelvin.isHidden = true
        viewSetColor.isHidden = true
        btnConfirm.isHidden = true
        viewAddCmd.isHidden = true
        viewSelectElement.isHidden = true
        heightSelectElement.constant = 0.0
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
                switch dv?.productType?.productCategoryType {
                case .DOOR_SENSOR, .CURTAINS:
                    self.listSmartTriggerEventType = [.OPENCLOSE_MODE_CLOSE, .OPENCLOSE_MODE_OPEN]
                case .SWITCH_SCENE:
                    self.listSmartTriggerEventType = [.BTN_PRESS_SINGLE, .BTN_PRESS_DOUBLE, .BTN_PRESS_LONG]
                case .DOORLOCK:
                    self.listSmartTriggerEventType = [.DOOR_LOCKED, .DOOR_UNLOCKED, .LOCK_UNLOCK]
                case .MOTION_SENSOR:
                    self.listSmartTriggerEventType = [.MOTION_STATE_CHANGE, .MOTION, .NO_MOTION]
                case .SWITCH:
                    self.listSmartTriggerEventType = [.ON, .OFF]
                default:
                    self.listSmartTriggerEventType = []
                }
                self.collectionViewSelectElement.reloadData()
            }.store(in: &self.subscriptions)
        Publishers.CombineLatest($hourStartTime, $minuteStartTime)
            .sink { [weak self] (selecHourStartTime, selecMinuteStartTime) in
                
                self?.startTime = selecHourStartTime * 60 + selecMinuteStartTime
            }
            .store(in: &subscriptions)
        Publishers.CombineLatest($hourEndTime, $minuteEndTime)
            .sink { [weak self] (selecHourEndTime, selecMinuteEndTime) in
                
                self?.endTime = selecHourEndTime * 60 + selecMinuteEndTime
            }
            .store(in: &subscriptions)
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
//                guard let selectedDevice = self.selectedDevice else {return}
//                if let index = self.listDeviceByCommand.firstIndex(of: selectedDevice) {
//                    self.listDeviceByCommand.remove(at: index)
//                }
                self.listDeviceLabel = []
                for rgbDevice in self.listDeviceByCommand {
                    self.listDeviceLabel.append(rgbDevice.label ?? "")
                }
            }.store(in: &self.subscriptions)
    }
    
    //MARK: - Action
    @IBAction func btnClickedAddSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let selectedAutomationType = selectedAutomationType, let selectedState = selectedState, let elementID = selectedDevice?.elementIDS?.first, let deviceID = selectedDevice?.uuid, let nameSmart = tfNameSmart.text else {return}
        var timeJob: [Int]? = nil
        if startTime == 0 || endTime == 0 {
            timeJob = nil
        } else {
            guard let startTime = startTime, let endTime = endTime else {return}
            timeJob = [startTime, endTime]
        }
        // For Smart Automation, there will be a Trigger and commands. When the Trigger is activated, the control commands will also be automatically activated, for example, simply when the Trigger turns on a button of the control command switch: For example, change the color of the light. In the example below, I create a Trigger and a control command to see how it works.
        
        let trigger = RGBSmartTrigger(automationEventType: selectedAutomationType,
                                      triggerCmdValues: [selectedState],
                                      triggerElementId: elementID,
                                      deviceId: deviceID,
                                      timeJob: timeJob,
                                      timeConfig: Int(tfTimeHoldTheState.text!),
                                      triggerType: .OWNER)
        guard let deviceIDCommand = selectedCommandDevice?.uuid, let elementIDCommand = selectedCommandDevice?.elementIDS?.first, let cmdType = selectedCommandType else {return}
        let commandDevice = RGBSmartCmd(deviceId: deviceIDCommand,
                                        elementIds: ["\(elementIDCommand)"],
                                        cmdValue: RGBSmartCmdValue(cmdType: cmdType))
        var automationType: RGBSmartAutomationType
        if trigger.triggerCmdValues.contains(.NO_MOTION) {
            automationType = .TYPE_NOMOTION_DETECTED_SIMULATE
        } else {
            automationType = .TYPE_MIX_OR
        }
        //TODO: - addSmartAutomation
        RGCore.shared.smart.addSmartAutomation(smartTitle: nameSmart,
                                               automationType: automationType,
                                               triggers: [trigger],
                                               commands: [commandDevice],
                                               initSmartCompletionHandler: nil,
                                               addTriggerCompletionHandler: nil,
                                               addCommandCompletionHandler: nil) { response, error in
            self.checkError(error: error , dismiss: true)
        }
    }
    @IBAction func prgBrightnessSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        valueBrightnessKelvin = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        self.selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func prgKelvinSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        valueBrightnessKelvin = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        self.selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func btnClickedSelectCommandDevice(_ sender: Any) {
        selectDeviceForCommandDropDown()
        dropDownCommanDevice.show()
    }
    @IBAction func btnClickedSelectCommnad(_ sender: Any) {
        selectCommandDropDown()
        dropDownCommandType.show()
    }
    @IBAction func btnConfirmTrigger(_ sender: Any) {
        viewAddCmd.isHidden = false
    }
    @IBAction func btnClickedSelectState(_ sender: Any) {
        selectStateDropDown()
        chooseStateDropDown.show()
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        selectDeviceDropDown()
        dropDownDevice.show()
    }
    @IBAction func btnClickedStartTimeHour(_ sender: Any) {
        chooseHourStatTime()
        chooseHourStartTimeDropDown.show()
    }
    @IBAction func btnClickStartTimeMinute(_ sender: Any) {
        chooseMinuteStartTime()
        chooseMinuteStartTimeDropDown.show()
    }
    @IBAction func btnClickedEndTimeHour(_ sender: Any) {
        chooseHourEndTime()
        chooseHourEndTimeDropDown.show()
    }
    @IBAction func btnClickedEndTimeMinute(_ sender: Any) {
        chooseMinuteEndTime()
        chooseMinuteStartTimeDropDown.show()
    }
}

extension AddSmartAutomationAdvanceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDevice?.elementIDS?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as! SmartElementCell
        var listElementValues: Dictionary<String, RGBDeviceElementInfo>.Values? = nil
        let isSelected = indexPath.row == selectedIndex
        cell.viewSelectElement.backgroundColor = isSelected ? .yellow : .white
        listElementValues = selectedDevice?.elementInfos?.values
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
        guard let listElementFirst = selectedDevice?.elementInfos?.keys.map({ String($0)}) else {
            return
        }
        triggerElementId = Int(listElementFirst[indexPath.row])
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
    
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
    
    //MARK: - DropDown
    
    func selectStateDropDown() {
        chooseStateDropDown.anchorView = btnSelectState
        chooseStateDropDown.textColor = .white
        chooseStateDropDown.backgroundColor = UIColor(hex: "#292c37")
        if selectedDevice?.productType?.productCategoryType == .SWITCH_SCENE {
            chooseStateDropDown.dataSource = ["Press Single", "Press Double", "Press Long"]
        } else if selectedDevice?.productType?.productCategoryType == .DOOR_SENSOR {
            chooseStateDropDown.dataSource = ["Close", "Open"]
        } else if selectedDevice?.productType?.productCategoryType == .DOORLOCK {
            chooseStateDropDown.dataSource = ["Door Locked", "Door Unlocked", "Lock, Unlock"]
        } else if selectedDevice?.productType?.productCategoryType == .MOTION_SENSOR {
            chooseStateDropDown.dataSource = ["Motion State Change", "Motion", "No Motion"]
        } else if selectedDevice?.productType?.productCategoryType == .SWITCH {
            chooseStateDropDown.dataSource = ["On", "Off"]
        }
        chooseStateDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelectState.setTitle(item, for: .normal)
            self?.selectedState = self?.listSmartTriggerEventType[index]
            self?.btnConfirm.isHidden = false
        }
    }
    
    func selectDeviceDropDown() {
        dropDownDevice.backgroundColor = .darkGray
        dropDownDevice.textColor = .white
        dropDownDevice.anchorView = btnSelectDeviceDropDown
        dropDownDevice.dataSource = listDeviceSupport.map{$0.label ?? ""}
        dropDownDevice.selectionAction = { [weak self] (index, item) in
            self?.btnSelectDeviceDropDown.setTitle(item, for: .normal)
            self?.selectedDevice = self?.listDeviceSupport[index]
            if self?.selectedDevice?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElement.isHidden = false
                self?.heightSelectElement.constant = 150.0
            } else {
                self?.viewSelectElement.isHidden = true
                self?.heightSelectElement.constant = 0.0
            }
        }
    }
    func selectCommandDropDown() {
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
    func selectDeviceForCommandDropDown() {
        dropDownCommanDevice.backgroundColor = .darkGray
        dropDownCommanDevice.textColor = .white
        dropDownCommanDevice.anchorView = btnDropDownSelectCommandDevice
        dropDownCommanDevice.dataSource = listDeviceLabel
        dropDownCommanDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectCommandDevice.setTitle(item, for: .normal)
            self?.selectedCommandDevice = self?.listDeviceByCommand[index]
            if self?.selectedCommandDevice?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElement.isHidden = false
            }
            self?.btnDropDownSelectCommandDevice.isEnabled = false
            self?.btnAddSmart.isHidden = false
        }
    }
    func chooseHourStatTime() {
        chooseHourStartTimeDropDown.anchorView = btnStartTimeHour
        chooseHourStartTimeDropDown.textColor = .white
        chooseHourStartTimeDropDown.backgroundColor = UIColor(hex: "#292c37")
        chooseHourStartTimeDropDown.dataSource = ["00","01","02","03","04", "05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
        chooseHourStartTimeDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnStartTimeHour.setTitle(item, for: .normal)
            self?.hourStartTime = Int(item)!
        }
    }
    func chooseHourEndTime() {
        chooseHourEndTimeDropDown.anchorView = btnEndTimeHour
        chooseHourEndTimeDropDown.textColor = .white
        chooseHourEndTimeDropDown.backgroundColor = UIColor(hex: "#292c37")
        chooseHourEndTimeDropDown.dataSource = ["00","01","02","03","04", "05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
        chooseHourEndTimeDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnEndTimeHour.setTitle(item, for: .normal)
            self?.hourEndTime = Int(item)!
        }
    }
    func chooseMinuteStartTime() {
        chooseMinuteStartTimeDropDown.anchorView = btnStartTimeMinute
        chooseMinuteStartTimeDropDown.textColor = .white
        chooseMinuteStartTimeDropDown.backgroundColor = UIColor(hex: "#292c37")
        chooseMinuteStartTimeDropDown.dataSource = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
        chooseMinuteStartTimeDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnStartTimeMinute.setTitle(item, for: .normal)
            self?.minuteStartTime = Int(item)!
        }
    }
    func chooseMinuteEndTime() {
        chooseeMinuteEndTimeDropDown.anchorView = btnEndTimeMinute
        chooseeMinuteEndTimeDropDown.textColor = .white
        chooseeMinuteEndTimeDropDown.backgroundColor = UIColor(hex: "#292c37")
        chooseeMinuteEndTimeDropDown.dataSource = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
        chooseeMinuteEndTimeDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnEndTimeMinute.setTitle(item, for: .normal)
            self?.minuteEndTime = Int(item)!
        }
    }
}
