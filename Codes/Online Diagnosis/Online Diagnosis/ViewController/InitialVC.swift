//

import UIKit
import LocalAuthentication

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LoginVC" ) as! LoginVC
                
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    @IBAction func onSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpVC" ) as! SignUpVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
