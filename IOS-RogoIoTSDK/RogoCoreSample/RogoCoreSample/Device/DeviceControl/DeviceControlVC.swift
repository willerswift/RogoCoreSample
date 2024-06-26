//
//  DeviceControlVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/02/2024.
//

import UIKit
import RogoCore

struct SwitchElement {
    let elementId: Int
    var isOn: Bool
}

class DeviceControlVC: UIBaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    //MARK: - Outlet
    @IBOutlet weak var collectionvViewElement: UICollectionView!
    @IBOutlet weak var viewControlElement: UIView!
    @IBOutlet weak var prgKelvin: UISlider!
    @IBOutlet weak var prgBrightness: UISlider!
    @IBOutlet weak var swOnOff: UISwitch!
    @IBOutlet weak var lbDeviceName: UILabel!
    @IBOutlet weak var viewControlOnOff: UIView!
    @IBOutlet weak var viewControlBrightness: UIView!
    @IBOutlet weak var viewControlColor: UIView!
    @IBOutlet weak var viewControlKelvin: UIView!
    @IBOutlet weak var gradientSlider: GradientSlider!
    
    //MARK: - Properties
    var elements: [SwitchElement] = []
    var selectedIndexes: [Int] = []
    var selectedLocation: RGBLocation?
    
    var device: RGBDevice? {
        didSet {
            if let elementIDS = device?.elementIDS {
                for elementId in elementIDS {
                    let element = SwitchElement(elementId: elementId, isOn: false)
                    elements.append(element)
                }
            }
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbDeviceName.text = device?.label
        viewControlColor.isHidden = true
        viewControlKelvin.isHidden = true
        viewControlBrightness.isHidden = true
        viewControlOnOff.isHidden = true
        deviceCommnadType()
        guard let device = device else {return}
        // requestStateOf and subscribeStateChangeOf are used to check the current state of the device, for example simply checking if it is on or off
        //TODO: - requestStateOf
        RGCore.shared.device.requestStateOf(device: device)
        //TODO: - subscribeStateChangeOf
        RGCore.shared.device.subscribeStateChangeOf(device: device, observer: self) {[weak self] res , error in
            guard let self = self,
                  res != nil,
                  res!.deviceUUID?.uppercased() == device.uuid?.uppercased(),
                  let states = res?.stateValues,
                  states.count > 0 else {
                      return
                  }
            self.updateDeviceState(states: states)
        }
        gradientSlider?.hasRainbow = true
        gradientSlider?.continuous = false
        gradientSlider?.actionBlock = { [weak self] slider, newValue, finished in
            guard self != nil else {
                return
            }
            let newColor = UIColor(hue: newValue, saturation: 1, brightness: 1.0, alpha: 1.0)
            if finished == true {
                let valueColor = RGBHSVColor(color: newColor)
                //TODO: - sendControlMessage
                RGCore.shared.device.sendControlMessage(device, value: valueColor, elements: device.elementIDS!)
            }
        }
        guard let numberElement = device.elementInfos?.count else {return}
        if  numberElement > 1 {
            collectionvViewElement.dataSource = self
            collectionvViewElement.delegate = self
            collectionvViewElement.register(UINib.init(nibName: "SmartElementCell", bundle: nil),
                                           forCellWithReuseIdentifier: "SmartElementCell")
            viewControlElement.isHidden = false
            RGCore.shared.device.requestStateOf(device: device)
            // subscribe device state change
            RGCore.shared.device.subscribeStateChangeOf(device: device, observer: self) {[weak self] res , error in
                guard let self = self,
                      res != nil,
                      res!.deviceUUID?.uppercased() == device.uuid?.uppercased(),
                      let states = res?.stateValues,
                      states.count > 0 else {
                          return
                      }
                self.updateElementWith(states: states)
            }
        } else {
            viewControlElement.isHidden = true
        }
    }
    // After checking the device's status, update the UI
    func updateDeviceState(states: [RGBDeviceElementState]) {
        for state in states {
            if let stateValue = state.commandValues.first(where: {$0.type == .ONOFF}) as? RGBValueOnOff {
                
                swOnOff.isOn = stateValue.on == 1
            }
            if let stateBrightnessKelvin = state.commandValues.first(where: {$0.type == .BRIGHTNESS_KELVIN}) as? RGBValueBrightnessKelvin {
                prgBrightness.value = Float(stateBrightnessKelvin.b)
                prgKelvin.setValue(Float(stateBrightnessKelvin.k), animated: true)
            }
        }
    }
    
    func deviceCommnadType () {
        // Displays UI according to each device feature
        guard let deviceFeatures = device?.features else {
            return
        }
        if deviceFeatures.contains(RGBCommandType.COLOR_LIST_HSV.rawValue) {
            viewControlColor.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.COLOR_HSL.rawValue) {
            viewControlColor.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.COLOR_HSV.rawValue) {
            viewControlColor.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.ONOFF.rawValue) {
            viewControlOnOff.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.BRIGHTNESS.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.KELVIN.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
        if deviceFeatures.contains(RGBCommandType.BRIGHTNESS_KELVIN.rawValue) {
            viewControlKelvin.isHidden = false
            viewControlBrightness.isHidden = false }
    }
    // Update device status with each element
    // In a device there can be many elements, for example, if I have a 4-button switch, each button of the switch will be an element and each has its own on or off status.
    func updateElementWith(states: [RGBDeviceElementState]) {
        for state in states {
            if let elementId = state.element,
               let elementIndex = self.elements.firstIndex(where: { $0.elementId == elementId }),
               let stateValue = state.commandValues.first(where: {$0.type == .ONOFF}) as? RGBValueOnOff {

                self.elements[elementIndex].isOn = stateValue.on == 1
            }
        }
        
        collectionvViewElement.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return device?.elementInfos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartElementCell", for: indexPath) as? SmartElementCell else { fatalError("Wrong cell class dequeued") }
        let listElementValues = device?.elementInfos?.values
        var listElementLabel: [String] = []
        if let listElementValues = listElementValues {
            for elementValue in listElementValues {
                listElementLabel.append(elementValue.label ?? "")
            }
            if listElementLabel.count > 0, !listElementLabel.contains("") {
                cell.lbElement.text = listElementLabel[indexPath.row]
            } else {
                cell.lbElement.text = "Node \(indexPath.row + 1)"
            }
        }
        let element = elements[indexPath.row]
        cell.viewSelectElement.backgroundColor = element.isOn ? .systemYellow : .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SmartElementCell else {
            return
        }
        elements[indexPath.row].isOn = !elements[indexPath.row].isOn
        let onValue = elements[indexPath.row].isOn == true ? 1 : 0
        let value = RGBValueOnOff(on: onValue)
        collectionvViewElement.reloadItems(at: [indexPath])
        guard let device = device else {return}
        RGCore.shared.device.sendControlMessage(device,
                                                value: value,
                                                elements: [elements[indexPath.row].elementId])
    }
    //MARK: - Action
    
    // Send the corresponding control command to the device
    
    @IBAction func prgBrightnessHandle(_ sender: UISlider) {
        guard let device = device else { return }
        let elementIDS = (device.elementIDS)!
        let valueKelvin = prgKelvin.value
        let valueBrightness = prgBrightness.value
        let value = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        //TODO: - sendControlMessage
        RGCore.shared.device.sendControlMessage(device, value: value, elements: elementIDS)
    }
    @IBAction func prgKelvinHandle(_ sender: UISlider) {
        guard let device = device else { return }
        let elementIDS = (device.elementIDS)!
        let valueBrightness = prgBrightness.value
        let valueKelvin = prgKelvin.value
        let value = RGBValueBrightnessKelvin(Int(valueBrightness), Int(valueKelvin))
        //TODO: - sendControlMessage
        RGCore.shared.device.sendControlMessage(device, value: value, elements: elementIDS)
    }
    @IBAction func switchOnOffDevice(_ sender: UISwitch) {
        guard let device = device, let elementIDS = device.elementIDS else {return}
        if let onValue = sender.isOn == true ? 1 : 0 {
            if device.productType?.productCategoryType == .TV {
                //For TV devices, there is only a power button, not On or Off
                let valueObj = RGBIrTVRemoteCommand(command: .POWER)
                //TODO: - sendControlMessage
                RGCore.shared.device.sendControlMessage(device, value: valueObj, elements: elementIDS)
            } else {
                let value = RGBValueOnOff(on: onValue)
                //TODO: - sendControlMessage
                RGCore.shared.device.sendControlMessage(device, value: value, elements: elementIDS)
            }
        }
    }
    //MARK: - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 50.0)
    }
}

