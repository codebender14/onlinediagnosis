//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var middlename: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var medicalHistoryView: UIView!
    let datePicker = UIDatePicker()

    var gender = ""
    var password = ""
    var editBool = false
    var appointmentData : [AppointmentDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        self.firstname.isUserInteractionEnabled = false
        self.middlename.isUserInteractionEnabled = false
        self.lastname.isUserInteractionEnabled = false
        self.dob.isUserInteractionEnabled = false
        self.male.isUserInteractionEnabled = false
        self.female.isUserInteractionEnabled = false

        self.dob.inputView =  datePicker
        self.showDatePicker()
        
        male.setImage(UIImage(named: "circle"), for: .normal)
        male.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        female.setImage(UIImage(named: "circle"), for: .normal)
        female.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            self.medicalHistoryView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfileData()
    }
    
    @IBAction func onEdit(_ sender: Any) {
        if !editBool {
            self.editBtn.setTitle("Save", for: .normal)
            self.firstname.isUserInteractionEnabled = true
            self.middlename.isUserInteractionEnabled = true
            self.lastname.isUserInteractionEnabled = true
            self.dob.isUserInteractionEnabled = true
            self.male.isUserInteractionEnabled = true
            self.female.isUserInteractionEnabled = true
            editBool = true
        } else {
            if validate(){
                let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let userdata = ["dob": self.dob.text ?? "", "email": self.email.text ?? "", "firstName": self.firstname.text ?? "", "middleName": self.middlename.text ?? "", "lastName": self.lastname.text ?? "", "gender": self.gender, "password": self.password, "userType": "Patient"]
                FireStoreManager.shared.updateProfile(documentid: documentid, userData: userdata) { success in
                    if success {
                        showAlerOnTop(message: "Profile Updated Successfully")
                    }
                }
                editBool = false
                self.editBtn.setTitle("Edit Profile Details", for: .normal)
                self.firstname.isUserInteractionEnabled = false
                self.middlename.isUserInteractionEnabled = false
                self.lastname.isUserInteractionEnabled = false
                self.dob.isUserInteractionEnabled = false
                self.male.isUserInteractionEnabled = false
                self.female.isUserInteractionEnabled = false
            }
        }
    }
    
    func getProfileData(){
        FireStoreManager.shared.getProfile(email: UserDefaultsManager.shared.getEmail()) { querySnapshot in
            
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    
                    let item = try document.data(as: UserDataModel.self)

                    self.firstname.text = item.firstName ?? ""
                    self.middlename.text = item.middleName ?? ""
                    self.lastname.text = item.lastName ?? ""
                    self.dob.text = item.dob ?? ""
                    self.email.text = item.email ?? ""

                    self.appointmentData = item.AppointmentDetail ?? []
                    self.gender = item.gender ?? ""
                    self.password = item.password ?? ""
                    if item.gender == "male" {
                        self.male.isSelected = true
                    } else {
                        self.female.isSelected = true
                    }
                }catch let error {
                    print(error)
                }
            }
        
        }
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ChangePassword" ) as! ChangePassword
                
        vc.password = self.password
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func onAppointmentHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AppointmentHistory" ) as! AppointmentHistory
                
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func onMedicalHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MedicalHistory" ) as! MedicalHistory
                
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @IBAction func onSignOut(_ sender: Any) {
        // Create an alert controller
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                
                // Add a "Logout" action to the alert
                let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
                    UserDefaultsManager.shared.clearData()
                    SceneDelegate.shared!.loginCheckOrRestart()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                // Add the actions to the alert controller
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                
                // Present the alert
                present(alertController, animated: true, completion: nil)
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
//        if(self.middlename.text!.isEmpty) {
//             showAlerOnTop(message: "Please enter middle name.")
//            return false
//        }
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
        
        return true
    }
    
    @IBAction func showDatepicker(_ sender: UIButton) {
        self.showDatePicker()
    }
}

extension ProfileVC {
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
            formatter.dateFormat = "MM/dd/yyyy" 
            dob.text = formatter.string(from: datePicker.date)
            //dismiss date picker dialog
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker() {
            self.view.endEditing(true)
        }

}


// Add Doctor in Hospital in Firestore

extension ProfileVC {
    func addDoctorInHospital(){
        
        FireStoreManager.shared.getProfile(email: UserDefaultsManager.shared.getEmail()) { querySnapshot in
            
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    
                    let item = try document.data(as: UserDataModel.self)

                    let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                    
                    let userdata = ["firstName": item.firstName, "middleName": item.middleName, "lastName": item.lastName, "dob": item.dob, "gender": item.gender, "email": item.email, "userType": "Doctor", "specialist" : item.specialist, "expert": item.expert, "rating": item.rating, "achievement" : item.achievement, "awards": item.awards, "availableHours" : item.availableHours] as [String : Any]
                    
                    FireStoreManager.shared.updateHospitalProfile(userData: userdata) { success in
                        if success {
                            showAlerOnTop(message: "Profile Updated Successfully")
                        }
                    }
                    
                }catch let error {
                    print(error)
                }
            }
        
        }
    }
}