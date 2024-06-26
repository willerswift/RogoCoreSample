//
//  EditSmartAutomationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/03/2024.
//

import UIKit
import RogoCore
import DropDown

class EditSmartAutomationVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnSelectTypeAutomation: UIButton!
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    let listSmartAutomationType: [RGBAutomationEventType] = [.StairSwitch, .Notification, .SelfReverse, .StateChange]
    
    let dropDownAutomationType = DropDown()
    
    var selectedAutomationType: RGBAutomationEventType?
    
    let listAutomation = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .automation})
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectCommandTypeDropDown() {
        dropDownAutomationType.backgroundColor = .darkGray
        dropDownAutomationType.textColor = .white
        dropDownAutomationType.anchorView = btnSelectTypeAutomation;
        dropDownAutomationType.dataSource = ["Stair Swich", "Notification", "Self Reverse", "Advance"]
        dropDownAutomationType.selectionAction = { [weak self] (index, item) in
            self?.btnSelectTypeAutomation.setTitle(item, for: .normal)
            self?.selectedAutomationType = self?.listSmartAutomationType[index]
        }
    }
    //MARK: - Action

    @IBAction func btnClickedSelectAutomationType(_ sender: Any) {
        selectCommandTypeDropDown()
        dropDownAutomationType.show()
    }
    @IBAction func btnConfirmTypeAutomation(_ sender: Any) {
        if selectedAutomationType == .StairSwitch {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartAutomationStairSwitchVC") as! EditSmartAutomationStairSwitchVC
            vc.selectedLocation = selectedLocation
            guard let listAutomation = listAutomation else {return}
            vc.listStaỉrSwitch = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_STAIR_SWITCH.rawValue})
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else if selectedAutomationType == .Notification {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartAutomationNotificationVC") as! EditSmartAutomationNotificationVC
            vc.selectedLocation = selectedLocation
            guard let listAutomation = listAutomation else {return}
            vc.listNotification = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_NOTIFICATION.rawValue})
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else if selectedAutomationType == .SelfReverse {
           //Edit Self Reverse: Edit trigger, edit timeJob, edit timeConfig same
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartAutomationAdvanceVC") as! EditSmartAutomationAdvanceVC
            vc.selectedLocation = selectedLocation
            guard let listAutomation = listAutomation else {return}
            let listStairSwitch = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_STAIR_SWITCH.rawValue})
            let listNotifications = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_NOTIFICATION.rawValue})
            let listSelfReverse = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_SELF_REVERSE.rawValue})
            vc.listAdvance = Array(Set(listAutomation).subtracting(listNotifications + listStairSwitch + listSelfReverse))
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        }
    }
}
