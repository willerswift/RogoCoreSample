//
//  AddSmartScheduleVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 04/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

fileprivate let availableDeviceTargetType: [RGBProductCategoryType] = [.ALL, .LIGHT, .SWITCH, .PLUG, .CURTAINS, .GATE, .AC]

class AddSmartScheduleVC: UIBaseVC {

    //MARK: - Outlet
    @IBOutlet weak var collectionViewElement: UICollectionView!
    @IBOutlet weak var lbNoti: UILabel!
    @IBOutlet var btnsWeekDay: [UIButton]!
    @IBOutlet var lbsWeekDay: [UILabel]!
    @IBOutlet weak var btnChooseHour: UIButton!
    @IBOutlet weak var btnChooseMinute: UIButton!
    @IBOutlet weak var btnDropDownSelectDevice: UIButton!
    @IBOutlet weak var btnAddSmartSchedule: UIButton!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var viewSelectDevice: UIView!
    @IBOutlet weak var tfNameSmartSchedule: UITextField!
    @IBOutlet weak var btnDropDownSelectCommand: UIButton!
    @IBOutlet weak var gradientSlider: GradientSlider!
    @IBOutlet weak var viewBrightnessKelvin: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var kelvinSlider: UISlider!
    @IBOutlet weak var viewSetColor: UIView!
    
    //MARK: - Properties
    var valueColor: [CGFloat]?
    var targetElementIds = [""]
    var selectedIndexes: [Int] = []
    var valueBrightnessKelvin: RGBValueBrightnessKelvin?
    let dropDownCommandType = DropDown()
    let dropDownDevice = DropDown()
    var listDeviceLabel: [String] = []
    var listDeviceByCommand: [RGBDevice] = []
    var selectedLocation: RGBLocation?
    var listTargetDeviceType: [RGBProductCategoryType] = availableDeviceTargetType
    let dropDownHour = DropDown()
    let dropDownMinute = DropDown()
    let currentTime = Date()
    @Published var hourWorkTime: Int = 0
    
    @Published var minuteWorkTime: Int = 0
    
    @Published var selectedWeekDays: [Int] = []
    
    @Published var workTimeValue: Int = 0
    
    @Published var selectedDevice: RGBDevice?
    @Published var selectedCommandType: RGBSmartCmdType?
    
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    let listCommandType: [RGBSmartCmdType] = [.onOff(isOn: true), .onOff(isOn: false), .openClose(value: .open), .openClose(value: .close) , .brightnessKelvin(b: nil, k: nil), .color(h: nil, s: nil, v: nil), .controlAirConditioner(isOn: nil, mode: nil, temperature: nil, fan: nil, swing: nil, other: nil)]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewElement.dataSource = self
        collectionViewElement.delegate = self
        collectionViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                       forCellWithReuseIdentifier: "SmartElementCell")
        hideKeyboardWhenTappedAround()
        viewSelectDevice.isHidden = true
        viewSelectElement.isHidden = true
        btnAddSmartSchedule.isHidden = true
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
        
        guard let listAllDevice = listAllDevice else {return}
        self.$selectedDevice
            .sink { dv in
                self.collectionViewElement.reloadData()
            }.store(in: &self.subscriptions)
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
    //MARK: - Action
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
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    @IBAction func prgKelvinSlider(_ sender: Any) {
        let valueKelvin = Int(kelvinSlider.value)
        let valueBrightness = Int(brightnessSlider.value)
        selectedCommandType = .brightnessKelvin(b: valueBrightness, k: valueKelvin)
    }
    //MARK: - DropDown
    
    func selectCommandTypeDropDown() {
        if selectedWeekDays == [] {
            DispatchQueue.main.async {
                self.lbNoti.text = "Please, set time !"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.lbNoti.text = ""
                }
            }
        } else {
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
//                self?.getElementByDevice()
            }
            self?.btnDropDownSelectDevice.isEnabled = false
            self?.btnAddSmartSchedule.isHidden = false
        }
    }
    
    //MARK: - Action
  
    @IBAction func btnAddSchedule(_ sender: Any) {
        guard let locationId = selectedLocation?.uuid, let nameSmart = tfNameSmartSchedule.text else {
            return
        }
        // As for Smart Schedule, it is similar to Scenario, the only difference is that we can set the time for it to activate automatically instead of having to call activeSmart like Scenario.
        RGCore.shared.smart.addSmart(with: nameSmart,
                                     locationId: locationId,
                                     type: .schedule,
                                     subType: RGBSmartSubType.defaultType) { response, error in
            if error == nil {
                guard let smartID = response?.uuid, let smart = response, let selectedDeviceID = self.selectedDevice?.uuid, let cmdType = self.selectedCommandType else {return}
                RGCore.shared.schedule.addSchedule(toSmart: smart, time: self.workTimeValue, weekdays: self.selectedWeekDays) { response, error in
                    if error == nil {
                        var targetElementIds = [""]
                        if self.selectedDevice?.elementIDS?.count == 1 {
                            targetElementIds = ["\(self.selectedDevice?.elementIDS?.first ?? 0)"]
                        } else {
                            targetElementIds = self.targetElementIds
                        }
                        RGCore.shared.smart.addSmartCmd(toSmartWithUUID: smartID,
                                                        targetId: selectedDeviceID,
                                                        targetElementIds: targetElementIds,
                                                        cmdValue: RGBSmartCmdValue(cmdType: cmdType, delay: nil,reversing: nil)) { response, error in
                                self.checkError(error: error, dismiss: true)
                        }
                    }
                }
            }
        }
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
extension AddSmartScheduleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}
