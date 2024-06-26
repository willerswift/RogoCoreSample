//
//  OptionsDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 17/01/2024.
//

import UIKit
import RogoCore

class OptionsDeviceVC: UIBaseVC {

    //MARK: - Outlet
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //MARK: - Action
    
    @IBAction func btnGetListAllDevice(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceVC") as! DeviceVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddDevice(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceVC") as! AddDeviceVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnEditDevice(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditDeviceVC") as! EditDeviceVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteDevice(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteDeviceVC") as! DeleteDeviceVC
        vc.selectedLocaiton = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnGetListAllGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListGroupVC") as! ListGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .Room
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupVC") as! AddGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .Room
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnEditGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditGroupVC") as! EditGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .Room
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteGroupVC") as! DeleteGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .Room
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VirtualGroupVC") as! VirtualGroupVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnSmartScenario(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmartScenario") as! SmartScenario
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnSmartSchedule(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmartSchedule") as! SmartSchedule
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnSmartAutomation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmartAutomation") as! SmartAutomation
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
