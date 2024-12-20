//
//  SignUpVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore

class SignUpVC: UIBaseVC {
    
    //MARK: -Outlet
    
    @IBOutlet weak var tfVerifyCode: UITextField!
    
    @IBOutlet weak var lbErrorVerify: UILabel!
    
    @IBOutlet weak var viewVerifyEmail: UIView!
    
    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    //MARK: -Properties
    
    //MARK: -Life Cycle
    
    override func viewDidLoad() {
        //        viewVerifyEmail.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: -Action
    
    @IBAction func btnSignUp(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            RGUIPopup.showPopupWith(contentView: viewLoading)
        }
        //TODO: - signUp
        // When registering, I entered my email, username, phone number and password, then there will be another step to verify the email so I can use the email to log in.
        RGCore.shared.auth.signUp(tfEmail.text ?? "",
                                  username: tfUserName.text ?? "",
                                  phone: tfPhoneNumber.text,
                                  password: tfPassword.text ?? "") { response, error in
            self.checkError(error: error, dismiss: false)
            if error == nil {
                DispatchQueue.main.async {
                    self.viewVerifyEmail.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.viewVerifyEmail.isHidden = true
                }
            }
        }
    }
    
    @IBAction func btnVerify(_ sender: Any) {
        guard let verifyCode = tfVerifyCode.text else {
            return
        }
        //TODO: - verifyRogoAuthenCode
        // The verification code will be sent to the email you are using to register, enter it and verify.
        RGCore.shared.auth.verifyAuthenCode(code: "\(verifyCode)") { response, error in
            self.checkError(error: error, dismiss: false)
            if error == nil {
                DispatchQueue.main.async {
                    self.viewVerifyEmail.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.viewVerifyEmail.isHidden = true
                }
            }
        }
    }
    
    
    @IBAction func btnResendVerify(_ sender: Any) {
        //TODO: - requestRogoVerifyCode
        // In case verification fails or there is an error that you want to verify again, use this function
        RGCore.shared.auth.requestVerifyCode(email: tfEmail.text ?? "") { response, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.lbErrorVerify.text = "Resend verify success"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.lbErrorVerify.text = ""
                    }
                }
            }
        }
    }
}
