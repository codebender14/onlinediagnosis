//
//  LoginVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBAction func LoginBTN(_ sender: UIButton) {
        guard let mail = EmailTF.text, !mail.isEmpty else {
            self.displayAlert(message: "Please enter your email.")
            return
        }
        
        guard let password = PasswordTF.text, !password.isEmpty else {
            self.displayAlert(message: "Please enter password.")
            return
        }
        
        Auth.auth().signIn(withEmail: mail, password: password) {
            authResult, error in
            if let error = error {
                self.displayAlert(message: error.localizedDescription)
            } else {
                // User data added successfully
                print("Successful sign in")
                let login = self.storyboard?.instantiateViewController(withIdentifier: "prehome") as! UserTabBarVC
                self.navigationController?.pushViewController(login, animated: true)
            }
        }
        
        
    }
    @IBAction func ForgotBTN(_ sender: UIButton) {
        let forgot = self.storyboard?.instantiateViewController(withIdentifier: "forgot")as! ForgotVC
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Helper method to display an alert
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
