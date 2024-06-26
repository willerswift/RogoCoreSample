//
//  GetListSmartAutomationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 26/02/2024.
//

import UIKit
import RogoCore

class GetListSmartAutomationVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlet
    
    @IBOutlet weak var lbGetListSuccess: UILabel!
    @IBOutlet weak var tbListAutomation: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    var listAutomation: [RGBSmart]?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmpty.isHidden = true
        tbListAutomation.delegate = self
        tbListAutomation.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listAutomation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        let smartAutomation = listAutomation?[indexPath.row]
        cell.lbNameLocation.text = smartAutomation?.label
        cell.lbDescLocation.text = "Automation"
        return cell
    }

    //MARK: - Action
    
    @IBAction func btnGetListAutomation(_ sender: Any) {
        // Get all Smart Automation for display
        listAutomation = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .automation})
        tbListAutomation.reloadData()
        lbGetListSuccess.isHidden = false
        if listAutomation?.count == 0 {
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
