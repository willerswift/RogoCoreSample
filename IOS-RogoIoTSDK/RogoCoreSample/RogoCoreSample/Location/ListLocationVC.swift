//
//  ListLocationVC.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import RogoCore

class ListLocationVC: UIBaseVC, UITableViewDelegate, UITableViewDataSource {

    //MARK: -Outlet
    
    @IBOutlet weak var tbListLocation: UITableView!
    @IBOutlet weak var lbGetListSuccess: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK: -Properties
    
    var locationType: RGUILocationType? = nil
    
    var listLocation: [RGBLocation]?
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmpty.isHidden = true
        tbListLocation.delegate = self
        tbListLocation.dataSource = self
        lbGetListSuccess.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLocation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell else { fatalError("Wrong") }
        //        let content = listContents[indexPath.row]
        let location = listLocation?[indexPath.row]
        cell.lbNameLocation.text = location?.label
        cell.lbDescLocation.text = location?.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsDeviceVC") as! OptionsDeviceVC
        vc.selectedLocation = self.listLocation?[indexPath.row]
        UIApplication.shared.topMostViewController()?.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    //MARK: -Action
    
    @IBAction func btnGetListLocation(_ sender: Any) {
        //TODO: Get list location
        listLocation = RGCore.shared.user.locations
        tbListLocation.reloadData()
        lbGetListSuccess.isHidden = false
        if listLocation?.count == 0 {
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
