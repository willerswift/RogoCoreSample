//
//  OptionsLocationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 12/01/2024.
//

import UIKit

class OptionsLocationVC: UIBaseVC {

    //MARK: -Outlet
    
    //MARK: -Properties
    
    //MARK: -Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //MARK: -Action
    
    @IBAction func btnGetListLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListLocationVC") as! ListLocationVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    
    @IBAction func btnAddLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocaitonVC") as! AddLocaitonVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    
    @IBAction func btnEditLocaiotn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditLocationVC") as! EditLocationVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    
    @IBAction func btnDeleteLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteLocaitonVC") as! DeleteLocaitonVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
