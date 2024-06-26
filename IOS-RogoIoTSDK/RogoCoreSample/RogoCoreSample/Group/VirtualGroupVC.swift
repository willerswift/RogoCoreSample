//
//  VirtualGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 05/02/2024.
//

import UIKit
import RogoCore

class VirtualGroupVC: UIBaseVC {

    //MARK: - Outlet
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Action

    @IBAction func btnGetVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListGroupVC") as! ListGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .VirtualGroup
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupVC") as! AddGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .VirtualGroup
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnEditVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditGroupVC") as! EditGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .VirtualGroup
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteGroupVC") as! DeleteGroupVC
        vc.selectedLocation = selectedLocation
        vc.groupType = .VirtualGroup
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnControlVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ControlVirtualGroupVC") as! ControlVirtualGroupVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnDeleteDeviceVirtualGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteDeviceVirtualGroupVC") as! DeleteDeviceVirtualGroupVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
