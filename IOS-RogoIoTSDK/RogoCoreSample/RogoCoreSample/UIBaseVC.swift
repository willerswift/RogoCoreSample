//
//  UIBaseVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 12/01/2024.
//

import UIKit
import Combine
import RogoCore

class UIBaseVC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lbError: UILabel!
    
    //MARK: - Properties
    
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func checkError(error: (Error)?, dismiss: Bool?) {
        DispatchQueue.main.async {
            if error == nil {
                // Phần check thành công thất bại đẩy popup
                let viewSuccess = ViewSuccessPopup.loadNib()
                RGUIPopup.showPopupWith(contentView: viewSuccess)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    RGUIPopup.hide()
                    if dismiss == true {
                        self.dismiss(animated: true)
                    } else {
                        return
                    }
                }
            } else {
                let viewFail = ViewFailPopup.loadNib()
                RGUIPopup.showPopupWith(contentView: viewFail)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    RGUIPopup.hide()
                }
                guard let error = error else {
                    return
                }
                self.lbError.text = "\(error)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    RGUIPopup.hide()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.lbError.text = ""
                }
            }
        }
    }
    //MARK: - Action

    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
