//
//  GetListSmartScheduleVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 05/02/2024.
//

import UIKit
import RogoCore

class GetListSmartScheduleVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlet
    
    @IBOutlet weak var lbGetListSuccess: UILabel!
    
    @IBOutlet weak var tbListSchedule: UITableView!
    
    @IBOutlet weak var viewEmpty: UIView!
    //MARK: - Properties
    
    var selectedLocation: RGBLocation?
    
    var listSchedule: [RGBSmart]?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbListSchedule.delegate = self
        tbListSchedule.dataSource = self
        lbGetListSuccess.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSchedule?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        //        let content = listContents[indexPath.row]
        let smartSchedule = listSchedule?[indexPath.row]
        cell.lbNameLocation.text = smartSchedule?.label
        cell.lbDescLocation.text = "Schedule"
        return cell
    }
    //MARK: - Action

    @IBAction func btnGetListSchedule(_ sender: Any) {
        listSchedule = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .schedule})
        tbListSchedule.reloadData()
        lbGetListSuccess.isHidden = false
        if listSchedule?.count == 0 {
            viewEmpty.isHidden = false
        } else {
            viewEmpty.isHidden = true
        }
    }
    
    //MARK: - Layout
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
