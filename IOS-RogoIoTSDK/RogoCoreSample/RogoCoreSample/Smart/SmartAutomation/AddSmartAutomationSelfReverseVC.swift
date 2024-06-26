//
//  AddSmartAutomationSelfReverse.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 19/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class AddSmartAutomationSelfReverseVC: UIBaseVC {

    //MARK: - Outlet
    @IBOutlet weak var btnSelectState: UIButton!
    @IBOutlet weak var tfReverseTime: UITextField!
    @IBOutlet weak var tfNameSmart: UITextField!
    @IBOutlet weak var heightSelectElement: NSLayoutConstraint!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var tfTimeReverse: UITextField!
    @IBOutlet weak var btnStartTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeMinute: UIButton!
    @IBOutlet weak var btnEndTimeHour: UIButton!
    @IBOutlet weak var btnStartTimeHour: UIButton!
    @IBOutlet weak var btnSelectDeviceDropDown: UIButton!
    @IBOutlet weak var collectionViewSelectElement: UICollectionView!
    
    //MARK: - Properties
    @Published var selectedDevice: RGBDevice?
    @Published var hourStartTime: Int = 0
    @Published var minuteStartTime: Int = 0
    @Published var hourEndTime: Int = 0
    @Published var minuteEndTime: Int = 0
    var listState: [RGBSmartTriggerEventType] = [.ON, .OFF]
    var selectedState: RGBSmartTriggerEventType?
    var listDeviceSupport: [RGBDevice] = []
    var selectedLocation: RGBLocation?
    var selectedAutomationType: RGBAutomationEventType?
    let dropDownDevice = DropDown()
    let chooseHourStartTimeDropDown = DropDown()
    let chooseHourEndTimeDropDown = DropDown()
    let chooseMinuteStartTimeDropDown = DropDown()
    let chooseeMinuteEndTimeDropDown = DropDown()
    let chooseStateDropDown = DropDown()
    var triggerElementId: Int?
    var selectedIndex: Int?
    var startTime: Int?
    var endTime: Int?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        collectionViewSelectElement.delegate = self
        collectionViewSelectElement.dataSource = self
        collectionViewSelectElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        heightSelectElement.constant = 0.0
        viewSelectElement.isHidden = true
        self.$selectedDevice
            .sink { dv in
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
    }
    
    //MARK: - Action
    
    @IBAction func btnAddSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let selectedAutomationType = selectedAutomationType, let deviceID = selectedDevice?.uuid, let elementID = selectedDevice?.elementIDS?.first, let nameSmart = tfNameSmart.text, let selectedState = selectedState else {return}
        var timeJob: [Int]? = nil
        if startTime == 0 || endTime == 0 {
            timeJob = nil
        } else {
            guard let startTime = startTime, let endTime = endTime else {return}
            timeJob = [startTime, endTime]
        }
        // With Smart Automation SelfReverse, it will have a trigger. When we create it successfully, it will automatically reverse the state we have set. We can set timeJob and timeConfig similarly to the Notification type.
        let trigger = RGBSmartTrigger(automationEventType: selectedAutomationType,
                                      triggerCmdValues: [selectedState],
                                      triggerElementId: elementID,
                                      deviceId: deviceID,
                                      timeJob: timeJob,
                                      timeConfig: Int(tfReverseTime.text!),
                                      triggerType: .OWNER)
        //TODO: - addSmartAutomation
        RGCore.shared.smart.addSmartAutomation(smartTitle: nameSmart ,
                                               automationType: .TYPE_SELF_REVERSE,
                                               triggers: [trigger],
                                               commands: [],
                                               initSmartCompletionHandler: nil,
                                               addTriggerCompletionHandler: nil,
                                               addCommandCompletionHandler: nil) { response, error in
                self.checkError(error: error, dismiss: true)
        }
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
    @IBAction func btnClickedState(_ sender: Any) {
        selectStateDropDown()
        chooseStateDropDown.show()
    }
}
extension AddSmartAutomationSelfReverseVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    func selectStateDropDown() {
        chooseStateDropDown.anchorView = btnSelectState
        chooseStateDropDown.textColor = .white
        chooseStateDropDown.backgroundColor = UIColor(hex: "#292c37")
        chooseStateDropDown.dataSource = ["State On", "State Off"]
        chooseStateDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelectState.setTitle(item, for: .normal)
            self?.selectedState = self?.listState[index]
        }
    }
}
