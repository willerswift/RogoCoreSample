//
//  SmartAutomation.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 05/02/2024.
//

import UIKit
import RogoCore

class SmartAutomation: UIBaseVC {

    //MARK: - Outlet
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK: - Action

    @IBAction func btnEditSmartAutomation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSmartAutomationVC") as! EditSmartAutomationVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddSmartAutomation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSmartAutomationVC") as! AddSmartAutomationVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnGetListSmartAutomation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetListSmartAutomationVC") as! GetListSmartAutomationVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteSmart(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteSmartVC") as! DeleteSmartVC
        vc.selectedLocation = selectedLocation
        vc.listSmart = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .automation})
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
