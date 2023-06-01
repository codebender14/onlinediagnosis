//
//  ForgotVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ForgotVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTF: UITextField!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBOutlet weak var messageTV: UITextView!
    
    @IBAction func submitBtn(_ sender: UIButton) {
        guard let mail = emailTF.text, !mail.isEmpty else {
            self.displayAlert(message: "Please enter your mail.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: mail) { error in
            if let error = error {
                // Handle error
                print("Error adding document: \(error)")
                self.displayAlert(message: "Error in sending mail.")
            } else {
                self.messageTV.text = "An email with instructions to reset your password has been sent to your registered email address."
            }
        }
    }
    
    // Helper method to display an alert
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

