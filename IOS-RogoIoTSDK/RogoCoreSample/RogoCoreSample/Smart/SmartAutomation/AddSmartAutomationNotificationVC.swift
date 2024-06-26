//
//  AddSmartAutomationNotificationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 19/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class AddSmartAutomationNotificationVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var tfTimeConfig: UITextField!
    @IBOutlet weak var btnStartTimeHour: UIButton!
    @IBOutlet weak var btnStartTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeHour: UIButton!
    @IBOutlet weak var btnEndTimeMinute: UIButton!
    @IBOutlet weak var tfNameSmart: UITextField!
    @IBOutlet weak var btnSelectDeviceDropDown: UIButton!
    
    //MARK: - Properties
    
    var listDeviceSupport: [RGBDevice] = []
    var selectedLocation: RGBLocation?
    var selectedAutomationType: RGBAutomationEventType?
    let dropDownDevice = DropDown()
    let chooseHourStartTimeDropDown = DropDown()
    let chooseMinuteStartTimeDropDown = DropDown()
    let chooseHourEndTimeDropDown = DropDown()
    let chooseeMinuteEndTimeDropDown = DropDown()
    var listSmartTriggerEventType: [RGBSmartTriggerEventType] = []
    @Published var selectedDevice: RGBDevice?
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
    }

    //MARK: - Action

    @IBAction func btnAddSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let selectedAutomationType = selectedAutomationType, let deviceID = selectedDevice?.uuid, let elementID = selectedDevice?.elementIDS?.first, let nameSmart = tfNameSmart.text else {return}
        var timeJob: [Int]? = nil
        if startTime == 0 || endTime == 0 {
            timeJob = nil
        } else {
            guard let startTime = startTime, let endTime = endTime else {return}
            timeJob = [startTime, endTime]
        }
        // With the Notification type, it will have a Trigger, it will push a notification every time it detects a change in the state that we have set, for example here I am passing in [.OPENCLOSE_MODE_CLOSE, .OPENCLOSE_MODE_OPEN], you can get One of them only closes or only opens to push notifications, for example
        // The timeJob value is the time we specify to allow it to operate within that period and beyond that period it will be inactive. For timeConfig, this is the delay time we set between notifications.
        let trigger = RGBSmartTrigger(automationEventType: selectedAutomationType,
                                      triggerCmdValues: listSmartTriggerEventType,
                                      triggerElementId: elementID,
                                      deviceId: deviceID,
                                      timeJob: timeJob,
                                      timeConfig: Int(tfTimeConfig.text!),
                                      triggerType: .OWNER)
        //TODO: - addSmartAutomation
        RGCore.shared.smart.addSmartAutomation(smartTitle: nameSmart ,
                                               automationType: .TYPE_NOTIFICATION,
                                               triggers: [trigger],
                                               commands: [],
                                               initSmartCompletionHandler: nil,
                                               addTriggerCompletionHandler: nil,
                                               addCommandCompletionHandler: nil) { response, error in
                self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnClickedSelectDeviceDropDown(_ sender: Any) {
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
    //MARK: - DropDown
    
    func selectDeviceDropDown() {
        dropDownDevice.backgroundColor = .darkGray
        dropDownDevice.textColor = .white
        dropDownDevice.anchorView = btnSelectDeviceDropDown
        dropDownDevice.dataSource = listDeviceSupport.map{$0.label ?? ""}
        dropDownDevice.selectionAction = { [weak self] (index, item) in
            self?.btnSelectDeviceDropDown.setTitle(item, for: .normal)
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
}
