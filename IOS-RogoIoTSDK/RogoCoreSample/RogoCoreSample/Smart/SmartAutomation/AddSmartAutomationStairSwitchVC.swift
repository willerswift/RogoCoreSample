//
//  AddSmartAutomationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 07/03/2024.
//

import UIKit
import RogoCore
import DropDown
import Combine

class AddSmartAutomationStairSwitchVC: UIBaseVC {
    
    //MARK: - Outlet
    @IBOutlet weak var tfSmartName: UITextField!
    @IBOutlet weak var heightSelectElementSecond: NSLayoutConstraint!
    @IBOutlet weak var heightSelectElementFirst: NSLayoutConstraint!
    @IBOutlet weak var viewSelectElementSecond: UIView!
    @IBOutlet weak var viewSelectElementFirst: UIView!
    @IBOutlet weak var viewAddAutomationStairSwitch: UIView!
    @IBOutlet weak var btnSecondDeviceDropDown: UIButton!
    @IBOutlet weak var btnFirstDeviceDropDown: UIButton!
    @IBOutlet weak var collectionViewSelectElementSecond: UICollectionView!
    @IBOutlet weak var collectionViewSelectElemenFirst: UICollectionView!
    //MARK: - Properties
    var triggerElemetIdSecond: Int?
    var triggerElementIdFirst: Int?
    var targetElementIds = [""]
    var selectedIndexFirst: Int?
    var selectedIndexSecond: Int?
    var listDeviceSupport: [RGBDevice] = []
    @Published var selectedDeviceFirst: RGBDevice?
    @Published var selectedDeviceSecond: RGBDevice?
    var selectedLocation: RGBLocation?
    var selectedAutomationType: RGBAutomationEventType?
    let dropDownAutomationType = DropDown()
    let dropDownFirstDevice = DropDown()
    let dropDownSecondDevice = DropDown()
    let listSmartAutomationType: [RGBAutomationEventType] = [.StairSwitch, .Notification, .SelfReverse, .StateChange]
   
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        viewSelectElementFirst.isHidden = true
        viewSelectElementSecond.isHidden = true
        btnSecondDeviceDropDown.isEnabled = false
        collectionViewSelectElemenFirst.delegate = self
        collectionViewSelectElemenFirst.dataSource = self
        collectionViewSelectElementSecond.delegate = self
        collectionViewSelectElementSecond.dataSource = self
        collectionViewSelectElemenFirst.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        collectionViewSelectElementSecond.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "SmartElementCell")
        heightSelectElementFirst.constant = 0.0
        heightSelectElementSecond.constant = 0.0
        self.$selectedDeviceFirst
            .sink { dv in
                self.collectionViewSelectElemenFirst.reloadData()
            }.store(in: &self.subscriptions)
        self.$selectedDeviceSecond
            .sink { dv in
                self.collectionViewSelectElementSecond.reloadData()
            }.store(in: &self.subscriptions)
    }
    
    //MARK: - Action
    
    @IBAction func btnAddSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let selectedAutomationType = selectedAutomationType, let triggerElementIdFirst = triggerElementIdFirst, let deviceIDFirst = selectedDeviceFirst?.uuid, let triggerElemetIdSecond = triggerElemetIdSecond, let deviceIDSecond = selectedDeviceSecond?.uuid else {return}
        // The Smart Automation Stair Switch type will have 2 Triggers, a simple example is the 2 switch buttons of your stairs. When successfully adding these 2 triggers they will automatically synchronize their states with each other.
        let triggerFirst = RGBSmartTrigger(automationEventType: selectedAutomationType,
                                           triggerCmdValues: [],
                                           triggerElementId: triggerElementIdFirst,
                                           deviceId: deviceIDFirst,
                                           triggerType: .OWNER)
        let triggerSecond = RGBSmartTrigger(automationEventType: selectedAutomationType,
                                            triggerCmdValues: [],
                                            triggerElementId: triggerElemetIdSecond,
                                            deviceId: deviceIDSecond,
                                            triggerType: .EXT)
        guard let nameSmart = tfSmartName.text else {return}
        RGCore.shared.smart.addSmartAutomation(smartTitle: nameSmart,
                                               automationType: .TYPE_STAIR_SWITCH,
                                               triggers: [triggerFirst,triggerSecond],
                                               commands: [],
                                               initSmartCompletionHandler: nil,
                                               addTriggerCompletionHandler: nil,
                                               addCommandCompletionHandler: nil) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnClickedSelectFirstDevice(_ sender: Any) {
        selectFirstDeviceDropDown()
        dropDownFirstDevice.show()
    }
    @IBAction func btnClickedSelectSecondDevice(_ sender: Any) {
        selectSecondDeviceDropDown()
        dropDownSecondDevice.show()
    }
    
    //MARK: - DropDown
    func selectFirstDeviceDropDown() {
        dropDownFirstDevice.backgroundColor = .darkGray
        dropDownFirstDevice.textColor = .white
        dropDownFirstDevice.anchorView = btnFirstDeviceDropDown
        dropDownFirstDevice.dataSource = listDeviceSupport.map{$0.label ?? ""}
        dropDownFirstDevice.selectionAction = { [weak self] (index, item) in
            self?.btnFirstDeviceDropDown.setTitle(item, for: .normal)
            self?.btnSecondDeviceDropDown.isEnabled = true
            self?.collectionViewSelectElemenFirst.reloadData()
            self?.selectedDeviceFirst = self?.listDeviceSupport[index]
            self?.listDeviceSupport.remove(at: index)
            if self?.selectedDeviceFirst?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElementFirst.isHidden = false
                self?.heightSelectElementFirst.constant = 150.0
            }
        }
    }
    func selectSecondDeviceDropDown() {
        dropDownSecondDevice.backgroundColor = .darkGray
        dropDownSecondDevice.textColor = .white
        dropDownSecondDevice.anchorView = btnSecondDeviceDropDown
        dropDownSecondDevice.dataSource = listDeviceSupport.map{$0.label ?? ""}
        dropDownSecondDevice.selectionAction = { [weak self] (index, item) in
            self?.btnSecondDeviceDropDown.setTitle(item, for: .normal)
            self?.collectionViewSelectElementSecond.reloadData()
            self?.selectedDeviceSecond = self?.listDeviceSupport[index]
            if self?.selectedDeviceSecond?.elementIDS?.count ?? 1 > 1 {
                self?.viewSelectElementSecond.isHidden = false
                self?.heightSelectElementSecond.constant = 150.0
            }
        }
    }
}

extension AddSmartAutomationStairSwitchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSelectElemenFirst {
            return selectedDeviceFirst?.elementIDS?.count ?? 0
        } else {
            return selectedDeviceSecond?.elementIDS?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as! SmartElementCell
        var listElementValues: Dictionary<String, RGBDeviceElementInfo>.Values? = nil
        if collectionView == collectionViewSelectElemenFirst {
            let isSelected = indexPath.row == selectedIndexFirst
            cell.viewSelectElement.backgroundColor = isSelected ? .yellow : .white
            listElementValues = selectedDeviceFirst?.elementInfos?.values
        } else {
            let isSelected = indexPath.row == selectedIndexSecond
            cell.viewSelectElement.backgroundColor = isSelected ? .yellow : .white
            listElementValues = selectedDeviceSecond?.elementInfos?.values
        }
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
        if collectionView == collectionViewSelectElemenFirst {
            guard let listElementFirst = selectedDeviceFirst?.elementInfos?.keys.map({ String($0)}) else {
                return
            }
            triggerElementIdFirst = Int(listElementFirst[indexPath.row])
            selectedIndexFirst = indexPath.row
        } else {
            guard let listElementSecond = selectedDeviceSecond?.elementInfos?.keys.map({ String($0)}) else {
                return
            }
            triggerElemetIdSecond = Int(listElementSecond[indexPath.row])
            selectedIndexSecond = indexPath.row
        }
        collectionView.reloadData()
    }
    
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}
