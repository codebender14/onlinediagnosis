//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onLogin(_ sender: Any) {
            if(email.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your email id.")
                return
            }

            if(self.password.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your password.")
                return
            }
            else{
                // Sign in with an existing user
                FireStoreManager.shared.login(email: email.text?.lowercased() ?? "", password: password.text ?? "") { success in
                    if success{
                        if UserDefaults.standard.bool(forKey: "FirstTimeLogin") {
                            SceneDelegate.shared?.loginCheckOrRestart()
                        } else {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LaunchViewController" ) as! LaunchViewController
                            
                            self.navigationController?.pushViewController(vc, animated: true)

                        }
                        
                    }
                    
                }
            }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpVC" ) as! SignUpVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
