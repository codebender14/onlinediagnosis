//
//  SignUpVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBOutlet weak var Firstname: UITextField!
    
    
    @IBOutlet weak var Lastname: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    
    
    @IBAction func Email(_ sender: UITextField) {
    }
    
    
    @IBAction func Register(_ sender: UIButton) {
        guard let Firstname = self.Firstname.text, !Firstname.isEmpty else{
            showAlertModal(title: "Alert", message: "First Name cannot be empty.")
            return
        }
        guard let Lastname = self.Lastname.text, !Lastname.isEmpty else{
            showAlertModal(title: "Alert", message: "Last Name cannot be empty.")
            return
        }
        guard let Email = self.Email.text, !Email.isEmpty else{
            showAlertModal(title: "Alert", message: "Email field cannot be empty.")
            return
        }
    }
    
    @IBAction func Login(_ sender: UIButton) {
        let LogiN = self.storyboard?.instantiateViewController(withIdentifier: "login")as! LoginVC
        self.navigationController?.pushViewController(LogiN, animated: true)
        
    }
    
    private func showAlertModal(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
}
