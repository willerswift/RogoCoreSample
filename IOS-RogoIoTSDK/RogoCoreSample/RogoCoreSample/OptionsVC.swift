//
//  OptionsVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit

class OptionsVC: UIViewController {

    //MARK: -Outlet
    
    @IBOutlet weak var btnLogOutEnable: UIButton!
    
    //MARK: -Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnLogOutEnable.tintColor = UIColor.white
        btnLogOutEnable.isEnabled = false
        
    }
    
    //MARK: -Life Cycle
    
    //MARK: -Action
 
    @IBAction func btnSignIn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        vc.didSignIn = {
            self.btnLogOutEnable.tintColor = UIColor.yellow
            self.btnLogOutEnable.isEnabled = true
        }
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    @IBAction func btnLogOut(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogOutVC") as! LogOutVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
