//
//  DeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore

class DeviceVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet weak var lbGetListSuccess: UILabel!
    
    @IBOutlet weak var tbListAllDevice: UITableView!
    
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    var listDevice: [RGBDevice] = []
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbListAllDevice.delegate = self
        tbListAllDevice.dataSource = self
        viewEmpty.isHidden = true
        lbGetListSuccess.isHidden = true
        // Use Notification to monitor device list changes and refresh the list
        RGBNotificationEvent.addObserverNotification(event: .REFRESH_DEVICE_LIST, observer: self, selector: #selector(self.prepareData))
    }
    
    @objc func prepareData () {
        self.listDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation ?? []
        tbListAllDevice.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDevice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        let device = listDevice[indexPath.row]
        cell.lbNameLocation.text = device.label
        // When a device is added to a room group, the groupID field will indicate which room group the device is in
        if let groupID = device.groupID,
           let group = RGCore.shared.user.selectedLocation?.groups.first(where: {$0.uuid == groupID}) {
            cell.lbDescLocation.text = group.label
        } else {
            cell.lbDescLocation.text = "Chưa có nhóm phòng"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listDevice[indexPath.row].productType?.productCategoryType == .DOOR_SENSOR {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogSensorDeviceVC") as! LogSensorDeviceVC
            vc.device = listDevice[indexPath.row]
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceControlVC") as! DeviceControlVC
            vc.device = listDevice[indexPath.row]
            vc.selectedLocation = selectedLocation
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
       
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    //MARK: - Action

    @IBAction func swOnOffAllDevice(_ sender: UISwitch) {
        if let onValue = sender.isOn == true ? 1 : 0 {
            let value = RGBValueOnOff(on: onValue)
            // This part is used to send control commands to all
            //TODO: - sendControlMessage
            let groupAllDevice = RGBGroup(elementID: 49152)
            RGCore.shared.device.sendControlMessage(groupAllDevice, productType: .ALL, value: value)
        }
    }
    
    @IBAction func btnGetListAllDevice(_ sender: Any) {
        //TODO: Get list location
        RGCore.shared.user.setSelectedLocation(locationId: selectedLocation?.uuid ?? "")
        listDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation ?? []
        tbListAllDevice.reloadData()
        lbGetListSuccess.isHidden = false
        if listDevice.count == 0 {
            viewEmpty.isHidden = false
        } else {
            viewEmpty.isHidden = true
        }
    }
    @IBAction func btnAddDevice(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDeviceVC") as! AddDeviceVC
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
}
