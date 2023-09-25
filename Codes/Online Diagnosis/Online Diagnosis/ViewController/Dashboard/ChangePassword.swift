

import UIKit

class ChangePassword: UIViewController {
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!

    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        if validate(){
            if(self.oldpassword.text! != self.password) {
                showAlerOnTop(message: "Please enter correct current password")
                return
            }
            else {
                let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let userdata = ["password": self.newpassword.text ?? ""]
                FireStoreManager.shared.changePassword(documentid: documentid, userData: userdata) { success in
                    if success {
                        showAlerOnTop(message: "Password Updated Successfully")
                    }
                }
            }
        }
    }
    
    func validate() ->Bool {
        
        if(self.oldpassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter current password.")
            return false
        }
        if(self.newpassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter new password.")
            return false
        }
        if(self.confirmPassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter confirm password.")
            return false
        }
        
           if(self.newpassword.text! != self.confirmPassword.text!) {
             showAlerOnTop(message: "Password doesn't match")
            return false
        }
        
        
        return true
    }
    
    
    @IBAction func onShowHidePassword(_ sender: UIButton) {
        
        if(sender.tag == 1) {
            let buttonImageName = oldpassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.oldpassword.isSecureTextEntry.toggle()
        }
       
        if(sender.tag == 2) {
            let buttonImageName = newpassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.newpassword.isSecureTextEntry.toggle()
        }
        
        if(sender.tag == 3) {
            let buttonImageName = confirmPassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.confirmPassword.isSecureTextEntry.toggle()
        }
       
    }
    
    
}
