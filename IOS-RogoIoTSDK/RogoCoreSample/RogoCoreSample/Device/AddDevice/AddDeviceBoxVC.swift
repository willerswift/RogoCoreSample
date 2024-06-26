//
//  AddDeviceBoxVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit
import RogoCore

class AddDeviceBoxVC: UIBaseVC {

    //MARK: - Outlet
    
    @IBOutlet weak var btnGenCode: UIButton!
    
    @IBOutlet weak var pinCodeView: VKPinCodeView!
    
    @IBOutlet weak var lbTimeOut: UILabel!
    
    @IBOutlet weak var lbNoti: UILabel!
    
    @IBOutlet weak var lbNoti2: UILabel!
    
    @IBOutlet weak var viewPinCode: UIView!
    
    //MARK: - Properties
    
    var timeRemaining: Int = 120
    
    var timer: Timer!
    
    var selectedLocation: RGBLocation?
    
    var addBoxComplete: Bool = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup UI pin code
        pinCodeView.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        pinCodeView.length = 6
        pinCodeView.onSettingStyle = {
            UnderlineStyle(textColor: .white, lineColor: .white , lineWidth: 1)
        }
        self.pinCodeView.isHidden = true
        self.lbTimeOut.isHidden = true
    }
    
    func addDeviceBox() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
        let loadingView = ViewLoadingPopup.loadNib()
        RGUIPopup.showPopupWith(contentView: loadingView)
        
        guard let selectedLocationId = selectedLocation?.uuid else {
            return
        }
        if timeRemaining > 0 {
            // We will create a code and then enter that code into the Box app to proceed with adding the device box to the account
            //TODO: - generatePlayboxActiveCode
            RGCore.shared.device.generatePlayboxActiveCode(locationId: selectedLocationId) { activeCode, error in
                
                guard let pinCode = activeCode?.code else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    self?.btnGenCode.isHidden = true
                    self?.pinCodeView.isHidden = false
                    self?.lbTimeOut.isHidden = false
                    self?.pinCodeView.setText(pinCode)
                    RGUIPopup.hide()
                }
                
            } didAddDeviceCompletion: { deviceBox, error in
                self.checkError(error: error, dismiss: true)
            }
        } else {
            
            //Hiển thị add thất bại
            DispatchQueue.main.async {
                self.pinCodeView.isHidden = true
                self.lbTimeOut.isHidden = true
                UIView.animate(withDuration: 1) {
                    self.lbNoti.text = "Add device failed"
                    self.lbNoti2.text = "Please check the device again or hard reset the device before starting again"
                }
            }
        }
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            DispatchQueue.main.async {
                self.pinCodeView.isHidden = true
                self.lbTimeOut.isHidden = true
                UIView.animate(withDuration: 1) {
                    if self.addBoxComplete == false {
                        self.lbNoti.text = "Add device failed"
                        self.lbNoti2.text = "Please check the device again or hard reset the device before starting again"
                    }
                }
            }
        }
        
        lbTimeOut.text = "\(timeRemaining)"
    }
    
    //MARK: -Action

    @IBAction func btnStartAddDeviceBox(_ sender: Any) {
        addDeviceBox()
    }
}
