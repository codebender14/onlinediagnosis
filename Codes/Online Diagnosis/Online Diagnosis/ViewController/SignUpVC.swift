//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var middlename: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    let datePicker = UIDatePicker()

    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dob.inputView =  datePicker
        self.showDatePicker()
        
        male.setImage(UIImage(named: "circle"), for: .normal)
        male.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        female.setImage(UIImage(named: "circle"), for: .normal)
        female.setImage(UIImage(named: "fillCircle"), for: .selected)

    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if validate(){
            FireStoreManager.shared.signUp(firstName: self.firstname.text ?? "", middleName: self.middlename.text ?? "", lastName: self.lastname.text ?? "", dob: self.dob.text ?? "", gender: gender, email: self.email.text ?? "", password: self.password.text ?? "", userType: "Patient")
        }
        
    }

    @IBAction func onLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LoginVC" ) as! LoginVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onMaleFemaleClick(_ sender: UIButton){
        
        if sender == male{
            male.isSelected = true
            female.isSelected = false
            gender = "male"
        }else{
            male.isSelected = false
            female.isSelected = true
            gender = "female"
        }
        
    }
    
    func validate() ->Bool {
        
        if(self.firstname.text!.isEmpty) {
             showAlerOnTop(message: "Please enter first name.")
            return false
        }
        if(self.middlename.text!.isEmpty) {
             showAlerOnTop(message: "Please enter middle name.")
            return false
        }
        if(self.lastname.text!.isEmpty) {
            showAlerOnTop(message: "Please enter last name.")
           return false
       }
        
        if(self.dob.text!.isEmpty) {
            showAlerOnTop(message: "Please enter dob.")
           return false
       }
        if(self.gender == "") {
            showAlerOnTop(message: "Please select gender")
           return false
       }
        if(self.email.text!.isEmpty) {
             showAlerOnTop(message: "Please enter email.")
            return false
        }
        
        if !email.text!.emailIsCorrect() {
            showAlerOnTop(message: "Please enter valid email id")
            return false
        }
        
        if(self.password.text!.isEmpty) {
             showAlerOnTop(message: "Please enter password.")
            return false
        }
        
        if(self.confirmPassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter confirm password.")
            return false
        }
        
           if(self.password.text! != self.confirmPassword.text!) {
             showAlerOnTop(message: "Password doesn't match")
            return false
        }
        
        if(self.password.text!.count < 5 || self.password.text!.count > 10 ) {
            
             showAlerOnTop(message: "Password  length shoud be 5 to 10")
            return false
        }
        
        
        return true
    }
    @IBAction func showDatepicker(_ sender: UIButton) {
        self.showDatePicker()
    }
}

extension SignUpVC{
        func showDatePicker() {
            //Formate Date
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            
            //done button & cancel button
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneHolydatePicker))
            doneButton.tintColor = .black
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
            cancelButton.tintColor = .black
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            // add toolbar to textField
            dob.inputAccessoryView = toolbar
            // add datepicker to textField
            dob.inputView = datePicker
            
        }
        
        @objc func doneHolydatePicker() {
            //For date formate
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            dob.text = formatter.string(from: datePicker.date)
            //dismiss date picker dialog
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker() {
            self.view.endEditing(true)
        }

}
