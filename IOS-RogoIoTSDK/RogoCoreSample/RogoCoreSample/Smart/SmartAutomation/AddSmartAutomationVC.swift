//
//  AddSmartAutomationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 19/03/2024.
//

import UIKit
import RogoCore
import DropDown

class AddSmartAutomationVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnAutomationTypeDropDown: UIButton!
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    let listSmartAutomationType: [RGBAutomationEventType] = [.StairSwitch, .Notification, .SelfReverse, .StateChange]
    
    let dropDownAutomationType = DropDown()
    
    var selectedAutomationType: RGBAutomationEventType?
    
    var listDeviceSupport: [RGBDevice] = []
    
    var listAllDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   // With smart Automation, they are divided into 4 types, you will use 1 of those 4 types to proceed with Smart Automation.
    func selectCommandTypeDropDown() {
        dropDownAutomationType.backgroundColor = .darkGray
        dropDownAutomationType.textColor = .white
        dropDownAutomationType.anchorView = btnAutomationTypeDropDown;
        dropDownAutomationType.dataSource = ["Stair Swich", "Notification", "Self Reverse", "Advance"]
        dropDownAutomationType.selectionAction = { [weak self] (index, item) in
            self?.btnAutomationTypeDropDown.setTitle(item, for: .normal)
            self?.selectedAutomationType = self?.listSmartAutomationType[index]
            self?.getListDeviceSupport()
        }
    }
    // Here I am retrieving the list of devices that support the RGBAutomationEventType type that I have chosen to add.
    func getListDeviceSupport () {
        guard let selectedAutomationType = selectedAutomationType else {return}
        //MARK: - getListDevicesSupport
        guard let listAllDevice = listAllDevice else {return}
        listDeviceSupport = RGCore.shared.automation.getListDevicesSupport(automationType: selectedAutomationType, from: listAllDevice)
        print("automation type: \(selectedAutomationType), device support count: \(listDeviceSupport.count)")
    }
  
    //MARK: - Action

    @IBAction func btnSelectAutomationType(_ sender: Any) {
        selectCommandTypeDropDown()
        dropDownAutomationType.show()
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if selectedAutomationType == .StairSwitch {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartAutomationStairSwitchVC") as! AddSmartAutomationStairSwitchVC
            vc.selectedLocation = selectedLocation
            vc.listDeviceSupport = listDeviceSupport
            vc.selectedAutomationType = selectedAutomationType
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else if selectedAutomationType == .Notification {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartAutomationNotificationVC") as! AddSmartAutomationNotificationVC
            vc.selectedLocation = selectedLocation
            vc.listDeviceSupport = listDeviceSupport
            vc.selectedAutomationType = selectedAutomationType
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else if selectedAutomationType == .SelfReverse {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartAutomationSelfReverseVC") as! AddSmartAutomationSelfReverseVC
            vc.selectedLocation = selectedLocation
            vc.listDeviceSupport = listDeviceSupport
            vc.selectedAutomationType = selectedAutomationType
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartAutomationAdvanceVC") as! AddSmartAutomationAdvanceVC
            vc.selectedLocation = selectedLocation
            vc.listDeviceSupport = listDeviceSupport
            vc.selectedAutomationType = selectedAutomationType
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        }
    }
}
