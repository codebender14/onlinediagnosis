//
//  MedicalHistory.swift
//  Online Diagnosis
//
//

import UIKit

class MedicalHistory: UIViewController {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var middlename: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var medication: UITextField!
    @IBOutlet weak var medicalProblem: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    let datePicker = UIDatePicker()
    
    var gender = ""
    var patientId = ""
    var doctorViewMedical = false
//    var editBool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dob.inputView =  datePicker
        self.showDatePicker()
        
        male.setImage(UIImage(named: "circle"), for: .normal)
        male.setImage(UIImage(named: "fillCircle"), for: .selected)
        
        female.setImage(UIImage(named: "circle"), for: .normal)
        female.setImage(UIImage(named: "fillCircle"), for: .selected)
        self.editBtn.setTitle("Submit", for: .normal)

        if doctorViewMedical{
            self.editBtn.isHidden = true
            self.firstname.isUserInteractionEnabled = false
            self.male.isUserInteractionEnabled = false
            self.female.isUserInteractionEnabled = false
            self.middlename.isUserInteractionEnabled = false
            self.lastname.isUserInteractionEnabled = false
            self.address.isUserInteractionEnabled = false
            self.dob.isUserInteractionEnabled = false
            self.phoneNo.isUserInteractionEnabled = false
            self.weight.isUserInteractionEnabled = false
            self.height.isUserInteractionEnabled = false
            self.medication.isUserInteractionEnabled = false
            self.medicalProblem.isUserInteractionEnabled = false
        }
        self.getMedicalData()
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

                    self.gender = item.gender ?? ""
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
    
    func getMedicalData(){
        if !doctorViewMedical {
            self.patientId = UserDefaultsManager.shared.getDocumentId()
        }
        FireStoreManager.shared.getMedicalDetail(patientId: self.patientId) { querySnapshot in
            
            print(querySnapshot.documents)
            if querySnapshot.documents.count == 0{
                if !self.doctorViewMedical {
                    self.getProfileData()
                }
            }
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    
                    let item = try document.data(as: MedicalDetail.self)

                    self.firstname.text = item.firstname ?? ""
                    self.middlename.text = item.middlename ?? ""
                    self.lastname.text = item.lastname ?? ""
                    self.dob.text = item.dob ?? ""
                    self.phoneNo.text = item.phoneNo ?? ""
                    self.address.text = item.address ?? ""
                    self.weight.text = item.weight ?? ""
                    self.height.text = item.height ?? ""
                    self.medication.text = item.medication ?? ""
                    self.medicalProblem.text = item.medicalProblem ?? ""

                    self.editBtn.setTitle("Update", for: .normal)

//                    self.firstname.isUserInteractionEnabled = false
//                    self.male.isUserInteractionEnabled = false
//                    self.female.isUserInteractionEnabled = false
//                    self.middlename.isUserInteractionEnabled = false
//                    self.lastname.isUserInteractionEnabled = false
//                    self.address.isUserInteractionEnabled = false
//                    self.dob.isUserInteractionEnabled = false
//                    self.phoneNo.isUserInteractionEnabled = false
//                    self.weight.isUserInteractionEnabled = false
//                    self.height.isUserInteractionEnabled = false
//                    self.medication.isUserInteractionEnabled = false
//                    self.medicalProblem.isUserInteractionEnabled = false
                    
                    self.gender = item.gender ?? ""
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
    
    @IBAction func onMedicalHistory(_ sender: Any) {
//        if editBool{
//            self.firstname.isUserInteractionEnabled = true
//            self.male.isUserInteractionEnabled = true
//            self.female.isUserInteractionEnabled = true
//            self.middlename.isUserInteractionEnabled = true
//            self.lastname.isUserInteractionEnabled = true
//            self.address.isUserInteractionEnabled = true
//            self.dob.isUserInteractionEnabled = true
//            self.phoneNo.isUserInteractionEnabled = true
//            self.weight.isUserInteractionEnabled = true
//            self.height.isUserInteractionEnabled = true
//            self.medication.isUserInteractionEnabled = true
//            self.medicalProblem.isUserInteractionEnabled = true
//            self.editBool = false
//
//        } else{
            if validate(){
                
                FireStoreManager.shared.addMedicalDetail(firstname: self.firstname.text ?? "", middlename: self.middlename.text ?? "", lastname: self.lastname.text ?? "", dob: self.dob.text ?? "", gender: self.gender, phoneNo: self.phoneNo.text ?? "", address: self.address.text ?? "", weight: self.weight.text ?? "", height: self.height.text ?? "", medication: self.medication.text ?? "", medicalProblem: self.medicalProblem.text ?? "", patientId: UserDefaultsManager.shared.getDocumentId()) { success in
                    if success{
                        var msg = ""
                        if self.editBtn.titleLabel?.text == "Edit"{
                            msg = "updated"
                        } else {
                            msg = "added"
                        }
                        showOkAlertAnyWhereWithCallBack(message: "Medical detail \(msg) successfully") {
                            
                            DispatchQueue.main.async {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                        }
                    }
                    
//                    self.firstname.isUserInteractionEnabled = false
//                    self.male.isUserInteractionEnabled = false
//                    self.female.isUserInteractionEnabled = false
//                    self.middlename.isUserInteractionEnabled = false
//                    self.lastname.isUserInteractionEnabled = false
//                    self.address.isUserInteractionEnabled = false
//                    self.dob.isUserInteractionEnabled = false
//                    self.phoneNo.isUserInteractionEnabled = false
//                    self.weight.isUserInteractionEnabled = false
//                    self.height.isUserInteractionEnabled = false
//                    self.medication.isUserInteractionEnabled = false
//                    self.medicalProblem.isUserInteractionEnabled = false
//                    self.editBool = false
                  
                }
            }
        //}

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
        
        if(self.phoneNo.text!.isEmpty) {
             showAlerOnTop(message: "Please enter phone no.")
            return false
        }
        
        if !isValidPhoneNumber(self.phoneNo.text ?? "") {
            showAlerOnTop(message: "Please enter valid phone no")
            return false
        }
        
        if(self.address.text!.isEmpty) {
             showAlerOnTop(message: "Please enter address")
            return false
        }
        
        if(self.weight.text!.isEmpty) {
             showAlerOnTop(message: "Please enter weight")
            return false
        }
        
        if(self.height.text!.isEmpty) {
             showAlerOnTop(message: "Please enter height")
            return false
        }
        
        if(self.medication.text!.isEmpty) {
             showAlerOnTop(message: "Please enter any medication")
            return false
        }
        
        if(self.medicalProblem.text!.isEmpty) {
             showAlerOnTop(message: "Please enter medical problem")
            return false
        }
        
        return true
    }
}

extension MedicalHistory {
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

    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }

}
