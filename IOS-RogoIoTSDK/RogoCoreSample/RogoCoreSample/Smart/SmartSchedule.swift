//
//  SmartSchedule.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 05/02/2024.
//

import UIKit
import RogoCore

class SmartSchedule: UIBaseVC {
    
    //MARK: - Outlet
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Action
    
    @IBAction func btnGetListSchedule(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetListSmartScheduleVC") as! GetListSmartScheduleVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        
    }
    @IBAction func btnAddSchedule(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartScheduleVC") as! AddSmartScheduleVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnEditSchedule(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartScenarioVC") as! EditSmartScenarioVC
        vc.selectedLocation = selectedLocation
        vc.listSmart = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .schedule})
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteSchedule(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteSmartVC") as! DeleteSmartVC
        vc.selectedLocation = selectedLocation
        vc.listSmart = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .schedule})
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
