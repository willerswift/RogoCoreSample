//
//  VirtualGroupControlDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 27/03/2024.
//

import UIKit
import RogoCore

class VirtualGroupControlDeviceVC: UIBaseVC {

    //MARK: - Outlet
    @IBOutlet weak var prgKelvin: UISlider!
    @IBOutlet weak var prgBrightness: UISlider!
    @IBOutlet weak var swOnOff: UISwitch!
    @IBOutlet weak var viewControlOnOff: UIView!
    @IBOutlet weak var viewControlBrightness: UIView!
    @IBOutlet weak var viewControlColor: UIView!
    @IBOutlet weak var viewControlKelvin: UIView!
    @IBOutlet weak var gradientSlider: GradientSlider!
    //MARK: - Properties
    
    var selectedGroup: RGBGroup?
    var listFeatures = [Int]()
    var listDeviceGroup: [RGBDevice] = []
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let groupMembers = selectedGroup?.groupMembers else {return}
        for member in groupMembers {
            if let device = RGCore.shared.user.selectedLocation?.allDevicesInLocation.first(where: {$0.uuid == member.deviceID}) {
                self.listDeviceGroup.append(device)
            }
        }
        for device in listDeviceGroup {
            if let features = device.features {
                let extractedFeatures = features.compactMap { $0 }
                listFeatures.append(contentsOf: extractedFeatures)
            }
        }
    }
    
    func deviceCommnadType() {
        if listFeatures.contains(RGBCommandType.COLOR_LIST_HSV.rawValue) {
            viewControlColor.isHidden = false }
        if listFeatures.contains(RGBCommandType.COLOR_HSL.rawValue) {
            viewControlColor.isHidden = false }
        if listFeatures.contains(RGBCommandType.COLOR_HSV.rawValue) {
            viewControlColor.isHidden = false }
        if listFeatures.contains(RGBCommandType.ONOFF.rawValue) {
            viewControlOnOff.isHidden = false }
        if listFeatures.contains(RGBCommandType.BRIGHTNESS.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
        if listFeatures.contains(RGBCommandType.KELVIN.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
        if listFeatures.contains(RGBCommandType.BRIGHTNESS_KELVIN.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
    }
    
    //MARK: - Action

    @IBAction func prgBrightnessHandle(_ sender: UISlider) {
        let valueKelvin = prgKelvin.value
        let valueBrightness = prgBrightness.value
        let value = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        guard let selectedGroup = selectedGroup else {return}
        //TODO: - sendControlMessage
        RGCore.shared.device.sendControlGroupMessageWith(selectedGroup.uuid ?? "", productType: .LIGHT, value: value)
    }
    @IBAction func prgKelvinHandle(_ sender: UISlider) {
        let valueBrightness = prgBrightness.value
        let valueKelvin = prgKelvin.value
        let value = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        guard let selectedGroup = selectedGroup else {return}
        //TODO: - sendControlMessage
        RGCore.shared.device.sendControlGroupMessageWith(selectedGroup.uuid ?? "", productType: .LIGHT, value: value)
    }
    @IBAction func switchOnOffDevice(_ sender: UISwitch) {
        if let onValue = sender.isOn == true ? 1 : 0 {
            let value = RGBValueOnOff(on: onValue)
            guard let selectedGroup = selectedGroup else {return}
            //TODO: - sendControlMessage
            RGCore.shared.device.sendControlGroupMessageWith(selectedGroup.uuid ?? "", productType: .ALL, value: value)
        }
    }
}
