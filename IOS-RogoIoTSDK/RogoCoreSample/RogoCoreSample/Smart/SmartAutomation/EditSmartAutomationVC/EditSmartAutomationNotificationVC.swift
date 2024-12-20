//
//  EditSmartAutomationNotificationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class EditSmartAutomationNotificationVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var tfTimeConfig: UITextField!
    @IBOutlet weak var btnEndTimeMinute: UIButton!
    @IBOutlet weak var btnStartTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeHour: UIButton!
    @IBOutlet weak var btnStartTimeHour: UIButton!
    @IBOutlet weak var btnDeviceDropDown: UIButton!
    @IBOutlet weak var tfNameSmart: UITextField!
    @IBOutlet weak var btnSelectSmart: UIButton!
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    var listNotification: [RGBSmart] = []
    let selectSmartDropDown = DropDown()
    let selectDeviceDropDown = DropDown()
    let chooseHourStartTimeDropDown = DropDown()
    let chooseMinuteStartTimeDropDown = DropDown()
    let chooseHourEndTimeDropDown = DropDown()
    let chooseeMinuteEndTimeDropDown = DropDown()
    @Published var selectedSmart: RGBSmart?
    @Published var selectedDevice: RGBDevice?
    var listSmartName: [String] = []
    var listDeviceSupport: [RGBDevice] = []
    var listSmartTriggerEventType: [RGBSmartTriggerEventType] = []
    @Published var timeConfig: Int = 0
    @Published var hourStartTime: Int = 0
    @Published var minuteStartTime: Int = 0
    @Published var hourEndTime: Int = 0
    @Published var minuteEndTime: Int = 0
    var startTime: Int?
    var endTime: Int?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
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
                default:
                    self.listSmartTriggerEventType = []
                }
            }.store(in: &self.subscriptions)
        guard let listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation else {return}
        listDeviceSupport = RGCore.shared.automation.getListDevicesSupport(automationType: .Notification, from: listAllDevice)
        for rgbSmart in listNotification {
            listSmartName.append(rgbSmart.label ?? "")
        }
    }

    func selectSmartAutomationDropDown() {
        selectSmartDropDown.backgroundColor = .darkGray
        selectSmartDropDown.textColor = .white
        selectSmartDropDown.anchorView = btnSelectSmart
        selectSmartDropDown.dataSource = listSmartName
        selectSmartDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelectSmart.setTitle(item, for: .normal)
            self?.selectedSmart = self?.listNotification[index]
            self?.tfNameSmart.text = self?.selectedSmart?.label
            guard let selectedSmartTrigger = self?.selectedSmart?.triggers?.first else {return}
            guard let device = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter({$0.uuid == selectedSmartTrigger.devID}).first else {
                return
            }
            self?.btnDeviceDropDown.setTitle(device.label, for: .normal)
            self?.selectedDevice = device
        }
    }
    
    func selectNewDeviceDropDown() {
        selectDeviceDropDown.backgroundColor = .darkGray
        selectDeviceDropDown.textColor = .white
        selectDeviceDropDown.anchorView = btnDeviceDropDown
        selectDeviceDropDown.dataSource = listDeviceSupport.map{$0.label ?? ""}
        selectDeviceDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnDeviceDropDown.setTitle(item, for: .normal)
            self?.selectedDevice = self?.listDeviceSupport[index]
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
    //MARK: - Action
    
    @IBAction func btnConfirmUpdateSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let nameSmart = tfNameSmart.text, let selectedSmart = selectedSmart, let smartID = selectedSmart.uuid else {return}
        RGCore.shared.smart.updateSmartTitle(withSmartId: smartID,
                                             label: nameSmart) { response, error in
            if error == nil {
                var timeJob: [Int]? = nil
                var timeConfig: [Int]? = nil
                if self.startTime == 0 || self.endTime == 0 {
                    timeJob = nil
                } else {
                    guard let startTime = self.startTime, let endTime = self.endTime else {return}
                    timeJob = [startTime, endTime]
                }
                if let newTimeConfig = Int(self.tfTimeConfig.text!) {
                    timeConfig = [newTimeConfig]
                } else {
                    timeConfig = nil
                }
                let firstTrigger = selectedSmart.triggers?.first
                //sửa thông tin của deviceID và elementID trong trigger rồi thả vào hàm update trigger
                guard var newTrigger = self.selectedSmart?.triggers?.first else {return}
                newTrigger.devID = self.selectedDevice?.uuid
                newTrigger.timeJob = timeJob
                
                newTrigger.timeCFG = timeConfig
                RGCore.shared.smart.updateSmartTrigger(to: selectedSmart,
                                                       trigger: newTrigger) { response, error in
                    self.checkError(error: error, dismiss: true)
                }
            }
        }
    }
    @IBAction func btnClickedSelectDevice(_ sender: Any) {
        selectNewDeviceDropDown()
        selectDeviceDropDown.show()
    }
    @IBAction func btnClickedSelectSmart(_ sender: Any) {
        selectSmartAutomationDropDown()
        selectSmartDropDown.show()
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
