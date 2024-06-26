//
//  ViewController.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 21/08/2023.
//

import UIKit
import RogoCore
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RGCore.shared.setCustomAuthenticate(customAuth: AuthenHandler.shared)
    }
    @IBOutlet weak var tfUsername: UILabel!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func btnSignIn(_ sender: Any) {
        // 1. Login
        NetworkClient.shared.login(phone: "\(tfUsername.text ?? "")",
                                   password: "\(tfPassword.text ?? "")") { info, error in
            // TODO: Handle error
            guard error == nil,
                  let fptToken = info?.fshLoginResponseData?.accessToken else {
                print(error?.localizedDescription)
                return
            }
            
            // 2. Request to rogo token
            self.requestGenRogoToken(fptToken: fptToken)
        }
    }
   
    
    @IBAction func btnSignUp(_ sender: Any) {
        // Sign up
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        // Forgot password
    }
    
    // 2. Request a FPT-Rogo session
    func requestGenRogoToken(fptToken: String) {
        
        NetworkClient.shared.generateRogoToken(fptToken: fptToken) { info, error in
            // TODO: Handle error
            guard error == nil,
                  let session = info?.data?.session else {
                print(error?.localizedDescription)
                return
            }
            
            self.getRogoToken(session: session)
        }
    }
    
    // 3. get rogo token
    func getRogoToken(session: FptRogoSession) {
        NetworkClient.shared.getRogoToken(session: session) { info, error in
            // TODO: Handle error
            guard error == nil,
                  let rogoToken = info?.data?.rogoToken else {
                print(error?.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(rogoToken, forKey: RG_ACCESS_TOKEN_KEY)
            RGCore.shared.refreshUserData { error in
                
                print(error)
            }
        }
    }

}

