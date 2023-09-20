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
    
    @IBAction func onMedicalHistory(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

}
