//
//  GetListSmartScenarioVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 06/02/2024.
//

import UIKit
import RogoCore

class GetListSmartScenarioVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet weak var lbGetListSuccess: UILabel!
    
    @IBOutlet weak var tbListScenario: UITableView!
    
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    var listScenario: [RGBSmart]?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbListScenario.delegate = self
        tbListScenario.dataSource = self
        lbGetListSuccess.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScenario?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        //        let content = listContents[indexPath.row]
        let smartScenario = listScenario?[indexPath.row]
        cell.lbNameLocation.text = smartScenario?.label
        cell.lbDescLocation.text = "Scenario"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let smart = listScenario?[indexPath.row] else {return}
        //TODO: - activeSmart
        // Use to activate the Smart Scenario we created
        RGCore.shared.smart.activeSmart(smart: smart) { response, error in
            self.checkError(error: error, dismiss: false)
        }
        self.lbGetListSuccess.text = "Active smart"
        self.lbGetListSuccess.textColor = UIColor.systemYellow
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.lbGetListSuccess.text = "Get list smart scenario success - Select a smart to active"
            self.lbGetListSuccess.textColor = UIColor.white
        }
    }
    
    //MARK: - Action

    @IBAction func btnGetListSchedule(_ sender: Any) {
        // Smart has 3 types we call them: Schedule, Scenario and Automation, here I am retrieving the list of Scenario
        listScenario = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .scenario})
        tbListScenario.reloadData()
        lbGetListSuccess.isHidden = false
        if listScenario?.count == 0 {
            viewEmpty.isHidden = false
        } else {
            viewEmpty.isHidden = true
        }
    }
    
    //MARK: -Layout
    
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
}
