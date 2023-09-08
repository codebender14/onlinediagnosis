//
//  ViewController.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import LocalAuthentication

class LoginSignUpVC: UIViewController {

    
    @IBAction func LoginBTN(_ sender: UIButton) {
        
        let Login = self.storyboard?.instantiateViewController(withIdentifier: "login")as! LoginVC
        self.navigationController?.pushViewController(Login, animated: true)
        let context = LAContext()
        var error : NSError?
        let reason = "Login and FaceID for Security "
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){success , evaluateerror in
            if success{
                DispatchQueue.main.async {
                    return
                }
            }
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "FaceID authentication failed", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                }
                                     
            }
        }
    }
    else{
        let alertController = UIAlertController(title: "Error", message: "FaceID not available on this device", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OK)
        self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func SignUpBTN(_ sender: UIButton) {
        let SignUp = self.storyboard?.instantiateViewController(withIdentifier: "signup")as! SignUpVC
        self.navigationController?.pushViewController(SignUp, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

