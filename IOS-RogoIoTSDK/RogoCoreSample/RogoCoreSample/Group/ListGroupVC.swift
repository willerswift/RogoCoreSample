//
//  ListGroupVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 16/01/2024.
//

import UIKit
import RogoCore

class ListGroupVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlet
    
    @IBOutlet weak var viewEmpty: UIView!
    
    @IBOutlet weak var tbListGroup: UITableView!
    
    @IBOutlet weak var lbGetListSuccess: UILabel!
    
    //MARK: - Properties
    
    var groupType: RGBGroupType?
    
    var selectedLocation: RGBLocation?
    
    var listGroup: [RGBGroup]?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmpty.isHidden = true
        tbListGroup.delegate = self
        tbListGroup.dataSource = self
        lbGetListSuccess.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGroup?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        //        let content = listContents[indexPath.row]
        let group = listGroup?[indexPath.row]
        cell.lbNameLocation.text = group?.label
        cell.lbDescLocation.text = group?.roomType.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if groupType == .VirtualGroup {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VirtualGroupControlDeviceVC") as! VirtualGroupControlDeviceVC
            UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
            vc.selectedGroup = listGroup?[indexPath.row]
        }
    }
    //MARK: - Action
    
    @IBAction func btnGetListGroup(_ sender: Any) {
        //TODO: Get list group
        listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType == groupType}
        tbListGroup.reloadData()
        lbGetListSuccess.isHidden = false
        if listGroup?.count == 0 {
            viewEmpty.isHidden = false
        } else {
            viewEmpty.isHidden = true
        }
    }
    
    //MARK: -Layout
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
       
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
