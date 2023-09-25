

import UIKit

class DoctorDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var specialization: UILabel!
    @IBOutlet weak var expert: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var achievement: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!

    var doctordetail : doctorDetail!
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

    var hospitalName = ""
    
    var availableHours = [String]()
    var timeStamp = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupView()
        
    }


    func setupView(){
        self.name.text = "\(doctordetail?.firstName ?? "") \(doctordetail?.lastName ?? "")"
        self.specialization.text = "Specialization : \(doctordetail.specialist ?? "")"
        self.dob.text = "Dob : \(doctordetail.dob ?? "")"
        self.expert.text = "Expertise : \(doctordetail.expert ?? "")"
//        self.age.text = "age : \(doctordetail.age ?? "")"
        self.gender.text = "Gender : \(doctordetail.gender ?? "")"
        self.achievement.text = doctordetail.achievement ?? ""
        self.awards.text = doctordetail.awards ?? ""

        self.date.inputView =  datePicker
        self.time.inputView =  datePicker
        self.availableHours = doctordetail.availableHours ?? ["Monday 10 am - 2 pm","Tuesday 11 am - 5 pm","Wednesday 8 am - 2 pm","Thursday 12 am - 4 pm","Friday 9 am - 12 pm","Saturday 8 am - 6 pm","Sunday 10 am - 12 pm"]
        self.showDatePicker()
        self.showOpeningTimePicker()

    }
    
    @IBAction func onBook(_ sender: Any) {
        if(date.text!.isEmpty) {
            showAlerOnTop(message: "Please select date")
            return
        }

        if(self.time.text!.isEmpty) {
            showAlerOnTop(message: "Please select time")
            return
        }
        else {
            let documentId = UserDefaultsManager.shared.getDocumentId()
            let data = AppointmentModel(patientId: documentId, pFirstname: "", pLastname: "", pMiddlename: "", doctorName: self.name.text ?? "", doctorEmail: doctordetail.email ?? "", hospitalName: self.hospitalName, medicalEmergency: "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: false, status: "Pending", patientEmail: UserDefaultsManager.shared.getEmail(), bookingDate: self.timeStamp, documentId: "")
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            vc.doctorDetailData = data
            vc.viewAppointment = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DoctorDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        cell.titleLbl.text = availableHours[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DoctorDetailVC" ) as! DoctorDetailVC
//
//        self.navigationController?.pushViewController(vc, animated: true)


    }
}

extension DoctorDetailVC{
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
            date.inputAccessoryView = toolbar
            // add datepicker to textField
            date.inputView = datePicker
            
        }
        
        @objc func doneHolydatePicker() {
            //For date formate
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            date.text = formatter.string(from: datePicker.date)
            timeStamp = getTime(date: datePicker.date)
            //dismiss date picker dialog
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker() {
            self.view.endEditing(true)
        }
    
    func getTime(date:Date)-> Double {
            return Double(date.millisecondsSince1970)
        }
    
    func showOpeningTimePicker() {
        //Formate Date
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneOpingTimePicker))
        doneButton.tintColor = .black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        cancelButton.tintColor = .black
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        time.inputAccessoryView = toolbar
        // add datepicker to textField
        time.inputView = timePicker
       
    }
    
    @objc func doneOpingTimePicker() {
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        time.text = formatter.string(from: timePicker.date)
       // txtOpeingTime.textFieldDidChange(txtOpeingTime)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }

}
