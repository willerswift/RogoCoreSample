//
//  EditSmartScenarioVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 04/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

fileprivate let availableDeviceTargetType: [RGBProductCategoryType] = [.ALL, .LIGHT, .SWITCH, .PLUG, .CURTAINS, .GATE, .AC]

class EditSmartScenarioVC: UIBaseVC {
    
    //MARK: - Outlet
    @IBOutlet weak var btnChooseMinute: UIButton!
    @IBOutlet weak var btnChooseHour: UIButton!
    @IBOutlet var btnsWeekDay: [UIButton]!
    @IBOutlet var lbsWeekDay: [UILabel]!
    @IBOutlet weak var viewScheduleTime: UIView!
    @IBOutlet weak var heightScheduleTime: NSLayoutConstraint!
    @IBOutlet weak var btnUpdateSmartScenario: UIButton!
    @IBOutlet weak var collectionViewElement: UICollectionView!
    @IBOutlet weak var gradientSlider: GradientSlider!
    @IBOutlet weak var kelvinSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var viewBrightnessKelvin: UIView!
    @IBOutlet weak var viewSetColor: UIView!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var btnDeviceDropDown: UIButton!
    @IBOutlet weak var btnCmdDropDown: UIButton!
    @IBOutlet weak var tfSmartName: UITextField!
    @IBOutlet weak var btnDropDownSelectSmart: UIButton!
    //MARK: - Properties
    var valueColor: [CGFloat]?
    var cmd: RGBSmartCmdValue?
    var targetElementIds = [""]
    var selectedIndexes: [Int] = []
    var listTargetDeviceType: [RGBProductCategoryType] = availableDeviceTargetType
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    var listDeviceLabel: [String] = []
    var listDeviceByCommand: [RGBDevice] = []
    @Published var selectedDevice: RGBDevice?
    @Published var selectedSmart: RGBSmart?
    @Published var selectedCommandType: RGBSmartCmdType?
    @Published var hourWorkTime: Int = 0
    
    @Published var minuteWorkTime: Int = 0
    
    @Published var selectedWeekDays: [Int] = []
    
    @Published var workTimeValue: Int = 0
    var valueBrightnessKelvin: RGBValueBrightnessKelvin?
    var selectedLocation: RGBLocation?
    var listSmart: [RGBSmart]? = nil
    var listSmartName: [String] = []
    var dropDownSelectSmart =  DropDown()
    var dropDownCommandType = DropDown()
    var dropDownDevice = DropDown()
    var dropDownHour = DropDown()
    var dropDownMinute = DropDown()
    let listCommandType: [RGBSmartCmdType] = [.onOff(isOn: true), .onOff(isOn: false), .openClose(value: .open), .openClose(value: .close) , .brightnessKelvin(b: 500, k: 4600), .color(h: nil, s: nil, v: nil), .controlAirConditioner(isOn: nil, mode: nil, temperature: nil, fan: nil, swing: nil, other: nil)]
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewElement.dataSource = self
        collectionViewElement.delegate = self
        collectionViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                       forCellWithReuseIdentifier: "SmartElementCell")
        hideKeyboardWhenTappedAround()
        viewSetColor.isHidden = true
        viewSelectElement.isHidden = true
        viewBrightnessKelvin.isHidden = true
        if listSmart?.first?.smartType == .scenario {
            self.heightScheduleTime.constant = 0.0
            self.viewScheduleTime.isHidden = true
        }
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
        self.$selectedWeekDays
            .sink {[weak self] selectedWeeks in
                self?.lbsWeekDay.forEach({ lbWeekDay in
                    if selectedWeeks.contains(lbWeekDay.tag) == true {
                        lbWeekDay.backgroundColor = UIColor(hex: "#fac423")
                    } else {
                        lbWeekDay.backgroundColor = UIColor(hex: "#262a36")
                    }
                })
            }
            .store(in: &subscriptions)
        
        Publishers.CombineLatest($hourWorkTime, $minuteWorkTime)
            .sink { [weak self] (selecHourWorkTime, selecMinuteWorkTime) in
                
                self?.workTimeValue = selecHourWorkTime * 60 + selecMinuteWorkTime
            }
            .store(in: &subscriptions)
        guard let listSmart = listSmart else {return}
        self.$selectedSmart
            .sink { selectedSmart in
                self.selectedDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter({$0.uuid == self.selectedSmart?.cmds?.first?.targetID}).first
                if selectedSmart?.smartType == .schedule {
                    self.lbsWeekDay.forEach { lbWeekDay in
                        if selectedSmart?.lstSchedule?.first?.weekdaysInLocalTimeZone?.contains(lbWeekDay.tag) == true {
                            self.selectedWeekDays.append(lbWeekDay.tag)
                            lbWeekDay.backgroundColor = UIColor(hex: "#fac423")
                        } else {
                            lbWeekDay.backgroundColor = UIColor(hex: "#262a36")
                        }
                    }
                    self.btnChooseHour.setTitle(String(format: "%02d", (selectedSmart?.lstSchedule?.first?.timeInLocalTimeZone)! / 60), for: .normal)
                    self.btnChooseMinute.setTitle(String(format: "%02d", (selectedSmart?.lstSchedule?.first?.timeInLocalTimeZone)! % 60), for: .normal)
                }
            }.store(in: &self.subscriptions)
        self.$selectedDevice
            .sink { dv in
                self.collectionViewElement.reloadData()
            }.store(in: &self.subscriptions)
        for rgbSmart in listSmart {
            listSmartName.append(rgbSmart.label ?? "")
        }
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
    
    func selectSmartDropDown() {
        dropDownSelectSmart.backgroundColor = .darkGray
        dropDownSelectSmart.textColor = .white
        dropDownSelectSmart.anchorView = btnDropDownSelectSmart
        dropDownSelectSmart.dataSource = listSmartName
        dropDownSelectSmart.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectSmart.setTitle(item, for: .normal)
            self?.selectedSmart = self?.listSmart?[index]
            //            self?.btnDropDownSelectSmart.isEnabled = false
            self?.tfSmartName.text = self?.selectedSmart?.label
            //            self?.btnCmdDropDown.setTitle(String(describing: self?.selectedSmart?.cmds?.first?.cmds?.values.first?.cmdType), for: .normal)
            DispatchQueue.main.async {
                self?.updateCommandName(cmdValue: self?.selectedSmart?.cmds?.first?.cmds?.values.first)
            }
            guard let device = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter({$0.uuid == self?.selectedSmart?.cmds?.first?.targetID}).first else {
                return
            }
            self?.btnDeviceDropDown.setTitle(device.label, for: .normal)
            self?.selectedDevice = device
            self?.btnCmdDropDown.isEnabled = true
            self?.collectionViewElement.reloadData()
        }
    }
    
    func chooseHour() {
        dropDownHour.anchorView = btnChooseHour
        dropDownHour.textColor = .white
        dropDownHour.backgroundColor = UIColor(hex: "#292c37")
        dropDownHour.dataSource = ["00","01","02","03","04", "05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
        dropDownHour.selectionAction = { [weak self] (index, item) in
            self?.btnChooseHour.setTitle(item, for: .normal)
            self?.hourWorkTime = Int(item) ?? 0
        }
    }
    
    func chooseMinute() {
        dropDownMinute.anchorView = btnChooseMinute
        dropDownMinute.textColor = .white
        dropDownMinute.backgroundColor = UIColor(hex: "#292c37")
        dropDownMinute.dataSource = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
        dropDownMinute.selectionAction = { [weak self] (index, item) in
            self?.btnChooseMinute.setTitle(item, for: .normal)
            self?.minuteWorkTime = Int(item) ?? 0
        }
    }
    
    fileprivate func updateCommandName(cmdValue: RGBSmartCmdValue?) {
        guard let cmdType = selectedSmart?.cmds?.first?.cmds?.values.first?.cmdType else {
            return
        }
        let reverseTime = cmdValue?.reversing ?? 0
        
        switch cmdType {
        case .openClose(let value):
            switch value {
            case .close:
                btnCmdDropDown.setTitle("Close", for: .normal)
            case .open:
                btnCmdDropDown.setTitle("Open", for: .normal)
            case .stop:
                btnCmdDropDown.setTitle("Stop", for: .normal)
            @unknown default:
                btnCmdDropDown.setTitle("", for: .normal)
                break
            }
        case .onOff(isOn: let isOn):
            if isOn == true {
                btnCmdDropDown.setTitle("On", for: .normal)
            } else {
                btnCmdDropDown.setTitle("Off", for: .normal)
            }
            //            if reverseTime > 0 {
            //                let min = Int(reverseTime/60)
            //                let sec = Int(reverseTime%60)
            //                self.lbDes.text = "\(self.lbDes.text ?? "") - Giữ trạng thái trong"
            //                self.lbDes.text = min > 0 ? "\(self.lbDes.text ?? "") \(min) phút \(sec) giây" : " \(self.lbDes.text ?? "") \(sec) giây"
            //            }
            guard let deviceElements = selectedDevice?.elementIDS else {return}
            if deviceElements.count > 1 {
                viewSelectElement.isHidden = false
            }
        case .brightnessKelvin(b: let b, k: _):
            let brightnessPercent = Float(b ?? 0) / Float(RGBValueBrightnessKelvin.MAXB) * 100
            btnCmdDropDown.setTitle("Set Brightness \(Int(brightnessPercent))%", for: .normal)
            viewBrightnessKelvin.isHidden = false
            //            brightnessSlider.value = brightnessPercent
            //            kelvinSlider.value =
        case .color:
            btnDeviceDropDown.setTitle("Change Light Color", for: .normal)
        case .switchingOnOff:
            btnCmdDropDown.setTitle("Revers", for: .normal)
        case .syncOnOffState, .syncReverseOnOffState:
            btnCmdDropDown.setTitle("Sync", for: .normal)
        case .changeBrightness(isIncrease: let isIncrease):
            if isIncrease == isIncrease {
                btnCmdDropDown.setTitle("Increase Light Brightness", for: .normal)
            } else {
                btnCmdDropDown.setTitle("Reduce Light Brightness", for: .normal)
            }
        case .changeKelvin(isIncrease: let isIncrease):
            if isIncrease == isIncrease {
                btnCmdDropDown.setTitle("Increase Light Kelvin", for: .normal)
            } else {
                btnCmdDropDown.setTitle("Reduce Light Kelvin", for: .normal)
            }
        case .controlAirConditioner:
            btnCmdDropDown.setTitle("Control AC", for: .normal)
        @unknown default:
            break
        }
    }
    
    func selectCommandTypeDropDown() {
        dropDownCommandType.backgroundColor = .darkGray
        dropDownCommandType.textColor = .white
        dropDownCommandType.anchorView = btnCmdDropDown;
        dropDownCommandType.dataSource = ["On", "Off", "Open", "Close", "Brightness Kelvin", "Color", "Control Air Conditioner"]
        dropDownCommandType.selectionAction = { [weak self] (index, item) in
            self?.btnCmdDropDown.setTitle(item, for: .normal)
            self?.selectedCommandType = self?.listCommandType[index]
            self?.btnCmdDropDown.isEnabled = false
            self?.btnDeviceDropDown.setTitle("Tap to select", for: .normal)
            self?.btnDropDownSelectSmart.isEnabled = false
        }
    }
    func selectDeviceDropDown() {
        dropDownDevice.backgroundColor = .darkGray
        dropDownDevice.textColor = .white
        dropDownDevice.anchorView = btnDeviceDropDown
        dropDownDevice.dataSource = listDeviceLabel
        dropDownDevice.selectionAction = { [weak self] (index, item) in
            self?.btnDeviceDropDown.setTitle(item, for: .normal)
            self?.selectedDevice = self?.listDeviceByCommand[index]
            if self?.selectedDevice?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElement.isHidden = false
            }
            self?.btnDeviceDropDown.isEnabled = false
            self?.btnUpdateSmartScenario.isHidden = false
        }
    }
    
    //MARK: - Action
    @IBAction func btnClickeđUpdateSmart(_ sender: Any) {
        // Editing the Scenario control is similar, we can edit the Scenario name or edit the command that contains it, editing its command is simply taking out its old command and editing it, in 1 Smart Scenario there may be many commands. control, in this example I am editing the first control command
        guard let smartID = selectedSmart?.uuid, let name = tfSmartName.text, let deviceID = selectedDevice?.uuid, let cmdType = self.selectedCommandType, let oldCmd = self.selectedSmart?.cmds?.first else {
            return
        }
        //TODO: - updateSmartTitle
        RGCore.shared.smart.updateSmartTitle(withSmartId: smartID, label: name) { response, error in
            if error == nil {
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
                //TODO: - updateSmartCmd
                if self.selectedSmart?.smartType == .schedule {
                    guard var schedule = self.selectedSmart?.lstSchedule?.first else {return}
                    schedule.weekdaysInLocalTimeZone = self.selectedWeekDays
                    schedule.timeInLocalTimeZone = self.workTimeValue
                    RGCore.shared.schedule.updateSchedule(schedule: schedule) { response, error in
                        if error == nil {
                            RGCore.shared.smart.updateSmartCmd(with: smartID, smartCmd: newCmd) { response, error in
                                self.checkError(error: error, dismiss: true)
                            }
                        }
                    }
                } else {
                    RGCore.shared.smart.updateSmartCmd(with: smartID, smartCmd: newCmd) { response, error in
                        self.checkError(error: error, dismiss: true)
                    }
                }
            }
        }
    }
    
    @IBAction func prgBrightnessSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        self.selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func prgKelvinSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        self.selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        selectDeviceDropDown()
        dropDownDevice.show()
    }
    @IBAction func btnClickedSelectCommandType(_ sender: Any) {
        selectCommandTypeDropDown()
        dropDownCommandType.show()
    }
    @IBAction func btnSelectSmartDropDown(_ sender: Any) {
        selectSmartDropDown()
        dropDownSelectSmart.show()
    }
    @IBAction func btnDropDownMinute(_ sender: Any) {
        chooseMinute()
        dropDownMinute.show()
    }
    @IBAction func btnDropDownHour(_ sender: Any) {
        chooseHour()
        dropDownHour.show()
    }
    @IBAction func btnWeekDayClicked(_ sender: UIButton) {
        let weekValue = sender.tag
        if let index = self.selectedWeekDays.firstIndex(of: weekValue) {
            self.selectedWeekDays.remove(at: index)
        } else {
            self.selectedWeekDays.append(weekValue)
        }
    }
}

extension EditSmartScenarioVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedDevice?.elementInfos?.count ?? 0 > 1 {
            return selectedDevice?.elementInfos?.count ?? 0
        } else {
            viewSelectElement.isHidden = true
            return 0
        }
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
