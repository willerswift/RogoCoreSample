//
//  ForgotPasswordVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore

class ForgotPasswordVC: UIBaseVC {

    //MARK: -Outlet
    
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfCodeResetPass: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var viewCodeResetPass: UIView!
    //MARK: -Properties
    
    //MARK: -Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        viewCodeResetPass.isHidden = true
    }
    
    //MARK: -Action
    
    @IBAction func btnResetPassword(_ sender: Any) {
        guard let code = tfCodeResetPass.text, let newPass = tfNewPassword.text else {return}
        //TODO: - resetRogoPasswordWith
        RGCore.shared.auth.resetPasswordWith(code: code, newPassword: newPass) { response, error in
            self.checkError(error: error, dismiss: true)
        }
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        guard let email = tfEmail.text else {return}
        // TODO: - resetPassword
        RGCore.shared.auth.requestVerifyCode(email: email) { response, error in
            self.checkError(error: error, dismiss: false)
            DispatchQueue.main.async {
                self.viewCodeResetPass.isHidden = false
            }
        }
    }
}
