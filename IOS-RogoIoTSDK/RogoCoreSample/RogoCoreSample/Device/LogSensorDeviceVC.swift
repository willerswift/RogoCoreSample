//
//  LogSensorDeviceVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 27/03/2024.
//

import UIKit
import RogoCore

class LogSensorDeviceVC: UIBaseVC, UITableViewDataSource, UITableViewDelegate {
   
    //MARK: - Outlet
    
    @IBOutlet weak var lbNameDeviceDoorSensor: UILabel!
    @IBOutlet weak var lbCurrentState: UILabel!
    @IBOutlet weak var tbListLockSensor: UITableView!
    
    //MARK: - Properties
    
    var listLogs: [RGBLog] = [] {
        didSet {
            self.tbListLockSensor.reloadData()
        }
    }
    
    var device: RGBDevice?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbListLockSensor.delegate = self
        tbListLockSensor.dataSource = self
        self.tbListLockSensor.register(UINib.init(nibName: "DoorSensorCell", bundle: nil),
                                     forCellReuseIdentifier: "DoorSensorCell")
        guard let selectedDevice = device else {return}
        lbNameDeviceDoorSensor.text = selectedDevice.label
        RGCore.shared.device.requestStateOf(device: selectedDevice)

        // subscribe device state change
        RGCore.shared.device.subscribeStateChangeOf(device: selectedDevice, observer: self) {[weak self] res , error in
            guard let self = self,
                  res != nil,
                  res!.deviceUUID?.uppercased() == selectedDevice.uuid?.uppercased(),
                  let states = res?.stateValues,
                  states.count > 0 else {
                      return
                  }

            self.updateElementWith(states: states)
            
            self.getLog()
        }
    }

    func updateElementWith(states: [RGBDeviceElementState]) {
        for state in states {
            
            if let currentState = state.commandValues.first(where: {$0.type == .EVENT_DOOR}) as? RGBValueOpenClose {
                if currentState.state == .open {
                    self.lbCurrentState.text = "State: Open"
                } else {
                    self.lbCurrentState.text = "State: Close"
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoorSensorCell", for: indexPath) as? DoorSensorCell else { fatalError("Wrong cell class dequeued") }
        
        let log = listLogs[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM"
        let stDate = log.logDateTime != nil
                        ? "\(formatter.string(from: log.logDateTime!))"
                        : ""
        cell.lbDate.text = "\(stDate)"
        
        if let state = (log.logValue as? RGBValueOpenClose)?.state {
            cell.lbStateDoor.text = state == .open ? "State: Open" : "State: Close"
        } else {
            cell.lbStateDoor.text = ""
        }
        return cell
    }
    
    
    func getLog() {
        var date = Date()
        
        date = Calendar.current.date(byAdding: .day, value: 0, to: date)!
        guard let device = device else {return}
        RGCore.shared.device.getSensorLogOf(device: device, dayToGetLog: date) { response, error in
            if error == nil,
               let logs = response, logs.count > 0 {
                self.listLogs = logs
                self.tbListLockSensor.reloadData()
            }
        }
    }
    
    
    //MARK: - Action
   

    //MARK: - Layout
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        let verticalPadding: CGFloat = 5
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
