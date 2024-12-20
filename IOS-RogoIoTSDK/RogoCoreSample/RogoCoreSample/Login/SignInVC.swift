//
//  SignInVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore

class SignInVC: UIBaseVC {

    //MARK: -Outlet
    
    @IBOutlet weak var viewSignInSuccess: UIView!
    
    @IBOutlet weak var viewSelectedEmail: UIView!
    
    @IBOutlet weak var viewSelectedUserName: UIView!
    
    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    //MARK: -Properties
    
    var didSignIn: (()->())? = nil
    
    //MARK: -Life Cycle
    
    override func viewDidLoad() {
        viewSignInSuccess.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: -Action
    
    @IBAction func btnSelecEmail(_ sender: Any) {
        viewSelectedUserName.backgroundColor = UIColor.white
        viewSelectedEmail.backgroundColor = UIColor.green
        tfEmail.isEnabled = true
        tfUserName.text = nil
        self.lbError.text = "Selected: Sign in by Email"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.lbError.text = ""
        }
    }
    @IBAction func btnSelecUserName(_ sender: Any) {
        viewSelectedUserName.backgroundColor = UIColor.green
        viewSelectedEmail.backgroundColor = UIColor.white
        tfEmail.isEnabled = false
        tfEmail.text = nil
        self.lbError.text = "Selected: Sign in by User name"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.lbError.text = ""
        }
    }
    @IBAction func btnSignIn(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        // This part can use one of two things: email or username to complete the login. As for the phone number, we don't need to use it, so here I will pass it as nil.
        if tfEmail.isEnabled == true {
            // SignIn with Email
            RGCore.shared.auth.signInWithEmail(email: tfEmail.text ?? "" , password: tfPassword.text ?? "") { response, error in
                self.checkError(error: error, dismiss: false)
                DispatchQueue.main.async {
                    if error == nil {
                        self.viewSignInSuccess.isHidden = false
                        self.didSignIn!()
                    } else {
                        self.viewSignInSuccess.isHidden = true
                    }
                }
            }
        } else {
            // SignIn with Username
            RGCore.shared.auth.signInWithUsername(username: tfUserName.text ?? "", password: tfPassword.text ?? "") { response, error in
                self.checkError(error: error, dismiss: false)
                DispatchQueue.main.async {
                    if error == nil {
                        self.viewSignInSuccess.isHidden = false
                        self.didSignIn!()
                    } else {
                        self.viewSignInSuccess.isHidden = true
                    }
                }
            }
        }
        
        // Email
//        RGCore.shared.auth.signInWithEmail(email: email ?? "", password: password) { response, error in
    }
    
    @IBAction func btnLoadToOptionsLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsLocationVC") as! OptionsLocationVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
