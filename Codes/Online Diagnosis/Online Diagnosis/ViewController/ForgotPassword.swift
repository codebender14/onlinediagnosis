//
//  ForgotPassword.swift
//  Online Diagnosis
//
//

import UIKit

class ForgotPassword: UIViewController {
    @IBOutlet weak var email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onSend(_ sender: Any) {
        if(email.text!.isEmpty) {
            showAlerOnTop(message: "Please enter your email id.")
            return
        }
        else{
            FireStoreManager.shared.getPassword(email: self.email.text!.lowercased(), password: "") { password in
                self.forgotPassword(password: password)
            }
        }
    }

    func forgotPassword(password: String) {
        let body = "<H1> Your password is \(password) </H1>"
        
        // Show a loading spinner
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .medium
        loadingIndicator.center =  self.view.center
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        // Call the sendEmail function and handle its response
        ForgetPasswordManager.sendEmail(emailTo: self.email.text ?? "", body: body) { success in
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                if success {
                    showAlerOnTop(message: "Please check your email box for password")
                } else {
                    showAlerOnTop(message: "Error sending email")
                }
            }
        }
    }
}
