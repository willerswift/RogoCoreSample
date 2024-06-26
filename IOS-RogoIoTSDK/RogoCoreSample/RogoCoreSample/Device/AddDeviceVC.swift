//
//  AddDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 17/01/2024.
//

import UIKit
import RogoCore

class AddDeviceVC: UIBaseVC {

    //MARK: - Outlet
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Action

    @IBAction func btnAddDeviceBox(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceBoxVC") as! AddDeviceBoxVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddDeviceBLE(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceBLEVC") as! AddDeviceBLEVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddDeviceZigbee(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceZigbeeVC") as! AddDeviceZigbeeVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddDeviceIR(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceIRVC") as! AddDeviceIRVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddIRRemote(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceIRRemoteVC") as! AddDeviceIRRemoteVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddIRRemoteTV(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceIRRemoteTVVC") as! AddDeviceIRRemoteTVVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnAddIRRemoteFan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceIRRemoteFanVC") as! AddDeviceIRRemoteFanVC
        vc.selectedLocation = selectedLocation
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
