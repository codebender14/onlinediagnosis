//
//  ViewController.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit

class LoginSignUpVC: UIViewController {

    
    @IBAction func LoginBTN(_ sender: UIButton) {
        
        let Login = self.storyboard?.instantiateViewController(withIdentifier: "login")as! LoginVC
        self.navigationController?.pushViewController(Login, animated: true)
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

