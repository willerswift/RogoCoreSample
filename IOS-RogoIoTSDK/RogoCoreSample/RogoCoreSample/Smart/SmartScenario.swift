//
//  SmartScenario.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 05/02/2024.
//

import UIKit
import RogoCore

class SmartScenario: UIBaseVC {

    //MARK: - Outlet
    
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Action
    
    @IBAction func btnEditSmartScenario(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartScenarioVC") as! EditSmartScenarioVC
        vc.selectedLocation = selectedLocation
        vc.listSmart = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .scenario})
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteSmart(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteSmartVC") as! DeleteSmartVC
        vc.selectedLocation = selectedLocation
        vc.listSmart = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .scenario})
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnGetListSmartScenario(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetListSmartScenarioVC") as! GetListSmartScenarioVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddSmartScenario(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartScenarioVC") as! AddSmartScenarioVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
