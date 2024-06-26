//
//  EditSmartAutomationStairSwitchVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/03/2024.
//

import UIKit
import RogoCore
import DropDown

class EditSmartAutomationStairSwitchVC: UIBaseVC {

    //MARK: - Outlet
    @IBOutlet weak var btnTriggerDropDown: UIButton!
    @IBOutlet weak var viewSelectElement: UIView!
    @IBOutlet weak var btnDeviceDropDown: UIButton!
    @IBOutlet weak var collectionViewElement: UICollectionView!
    @IBOutlet weak var btnDropDownSelectSmart: UIButton!
    @IBOutlet weak var tfSmartName: UITextField!
    
    //MARK: - Properties
    var selectedIndex: Int?
    var triggerElementId: Int?
    var selectedIndexes: [Int] = []
    var selectedLocation: RGBLocation?
    var listStaỉrSwitch: [RGBSmart] = []
    let selectSmartDropDown = DropDown()
    let selectTriggerDropDown = DropDown()
    let selectDeviceDropDown = DropDown()
    var listSmartName: [String] = []
    var listTrigger: [RGBSmartTrigger] = []
    @Published var selectedTrigger: RGBSmartTrigger?
    @Published var selectedSmart: RGBSmart?
    @Published var selectedDevice: RGBDevice?
    var targetElementIds = [""]
    var listDeviceSupport: [RGBDevice] = []
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        collectionViewElement.delegate = self
        collectionViewElement.dataSource = self
        collectionViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "SmartElementCell")
        for rgbSmart in listStaỉrSwitch {
            listSmartName.append(rgbSmart.label ?? "")
        }
        self.$selectedSmart
            .sink { dv in
//                guard let selectedSmartTrigger = self.selectedSmart?.triggers else {return}
//                self.listTrigger = selectedSmartTrigger
            }.store(in: &self.subscriptions)
        self.$selectedDevice
            .sink { dv in
                self.collectionViewElement.reloadData()
            }.store(in: &self.subscriptions)
        guard let listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation else {return}
        listDeviceSupport = RGCore.shared.automation.getListDevicesSupport(animationType: .StairSwitch, from: listAllDevice)
    }
    func selectSmartAutomationDropDown() {
        selectSmartDropDown.backgroundColor = .darkGray
        selectSmartDropDown.textColor = .white
        selectSmartDropDown.anchorView = btnDropDownSelectSmart
        selectSmartDropDown.dataSource = listSmartName
        selectSmartDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnDropDownSelectSmart.setTitle(item, for: .normal)
            self?.selectedSmart = self?.listStaỉrSwitch[index]
            self?.tfSmartName.text = self?.selectedSmart?.label
            guard let selectedSmartTrigger = self?.selectedSmart?.triggers else {return}
            self?.listTrigger = selectedSmartTrigger
        }
    }
    func selectTriggerAutomationDropDown() {
        var listTriggerName: [String] = []
        if listTrigger.count == 0 {
            listTriggerName = []
        } else if listTrigger.count == 1 {
            listTriggerName = ["Trigger 1"]
        } else {
            listTriggerName = ["Trigger 1", "Trigger 2"]
        }
        selectTriggerDropDown.backgroundColor = .darkGray
        selectTriggerDropDown.textColor = .white
        selectTriggerDropDown.anchorView = btnTriggerDropDown
        selectTriggerDropDown.dataSource = listTriggerName
        selectTriggerDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnTriggerDropDown.setTitle(listTriggerName[index], for: .normal)
            guard let listTrigger = self?.listTrigger, listTrigger.count > 0  else {return}
                self?.selectedTrigger = listTrigger[index]
            guard let device = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter({$0.uuid == self?.selectedTrigger?.devID}).first else {
                return
            }
            self?.btnDeviceDropDown.setTitle(device.label, for: .normal)
            self?.selectedDevice = device
            self?.collectionViewElement.reloadData()
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
    
    //MARK: - Action

    @IBAction func btnClickedUpdateSmart(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let nameSmart = tfSmartName.text, let selectedSmart = selectedSmart, let smartID = selectedSmart.uuid else {return}
        RGCore.shared.smart.updateSmartTitle(withSmartId: smartID,
                                             label: nameSmart) { response, error in
            if error == nil {
                let firstTrigger = selectedSmart.triggers?.first
//                 sửa thông tin của deviceID và elementID trong trigger rồi thả vào hàm update trigger
                guard var newTrigger = self.selectedTrigger else {return}
                newTrigger.devID = self.selectedDevice?.uuid
                newTrigger.elm = self.triggerElementId
                RGCore.shared.smart.updateSmartTrigger(to: selectedSmart,
                                                       trigger: newTrigger) { response, error in
                    self.checkError(error: error, dismiss: true)
                }
            }
        }
    }
    @IBAction func btnClickedSelectTrigger(_ sender: Any) {
        selectTriggerAutomationDropDown()
        selectTriggerDropDown.show()
    }
    @IBAction func btnClickedSelectSmart(_ sender: Any) {
        selectSmartAutomationDropDown()
        selectSmartDropDown.show()
    }
    @IBAction func btnClickedSelectNewDeviceDropDown(_ sender: Any) {
        selectNewDeviceDropDown()
        selectDeviceDropDown.show()
    }
}

extension EditSmartAutomationStairSwitchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedDevice?.elementInfos?.count ?? 0 > 1 {
            viewSelectElement.isHidden = false
            return selectedDevice?.elementInfos?.count ?? 0
        } else {
            viewSelectElement.isHidden = true
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? SmartElementCell else {
            return
        }
        guard let listElement = selectedDevice?.elementInfos?.keys.map({ String($0)}) else {
            return
        }
        triggerElementId = Int(listElement[indexPath.row])
        selectedIndex = indexPath.row
        collectionViewElement.reloadData()
    }
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}
