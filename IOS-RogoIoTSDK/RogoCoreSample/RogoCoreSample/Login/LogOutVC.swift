//
//  LogOutVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore

class LogOutVC: UIBaseVC {

    //MARK: -Outlet
    
    //MARK: -Properties
    
    //MARK: -Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK: -Action
    
    @IBAction func btnConfirmLogOut(_ sender: Any) {
        DispatchQueue.main.async {
            let viewLoading = ViewLoadingPopup.loadNib()
            //TODO: - signOut
            RGUIPopup.showPopupWith(contentView: viewLoading)
            RGCore.shared.auth.signOut { response, error in
                self.checkError(error: error, dismiss: true)
            }
        }
    }
    
    @IBAction func btnCancelLogOut(_ sender: Any) {
        dismiss(animated: true)
    }
}
