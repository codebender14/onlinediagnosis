
import UIKit

class BookAppointment: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var HospitalName: UILabel!
    @IBOutlet weak var medicalEmergency: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var medicalHistory: UISwitch!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var viewMedical: UIButton!

    var viewAppointment = false
    var doctorViewAppointment = false
    var medicalBool = false
    var viewApproveAppointment = false
    var doctorDetailData : AppointmentModel?
    var approveAppointmentData : ApproveAppointmentDetail?
    var appointmentList : AppointmentDetail?
    let existingTime = Date()
    let calendar = Calendar.current
    let hoursToAdd = 1
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var timeStamp = Double()
    var doctorAvailableHour = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMedical.isHidden = true
        datePicker.minimumDate = Date()
        self.medicalHistory.addTarget(self, action: #selector(self.switchValueChanged(_:)), for: .valueChanged)
        
        self.date.inputView =  datePicker
        self.time.inputView =  datePicker
        self.showDatePicker()
        self.showOpeningTimePicker()

        
        if viewAppointment && !viewApproveAppointment{
            if doctorViewAppointment {
                self.viewMedical.isHidden = false
                self.medicalHistory.isHidden = true
                self.disableUserInteraction()
                self.pendingAppointmentData(doctorView: true)
            } else {
                self.pendingAppointmentData(doctorView: false)
            }
        } else if viewApproveAppointment {
            self.disableUserInteraction()
            self.viewApproveAppointementData()
        } else {
            saveBtn.setTitle("Submit", for: .normal)
            deleteBtn.isHidden = true
            self.getDoctorAvailableHour(hospitalName: doctorDetailData?.hospitalName ?? "", doctorEmail: doctorDetailData?.doctorEmail ?? "")
            self.firstName.text = UserDefaultsManager.shared.getName()
            self.middleName.text = UserDefaultsManager.shared.getMiddleName()
            self.lastName.text = UserDefaultsManager.shared.getLastName()
            self.doctorName.text = "Doctor Name : \(doctorDetailData?.doctorName ?? "")"
            self.HospitalName.text = "Hospital Name : \(doctorDetailData?.hospitalName ?? "")"
            self.date.text = doctorDetailData?.date ?? ""
            self.time.text = doctorDetailData?.time ?? ""
            self.date.isUserInteractionEnabled = false
            self.time.isUserInteractionEnabled = false
            self.status.text = doctorDetailData?.status ?? "Pending"
            if doctorDetailData?.medicalHistory == true {
                self.medicalHistory.isOn = true
                self.medicalBool = true
            }else {
                self.medicalHistory.isOn = false
                self.medicalBool = false
            }
        }
    }
    
    func disableUserInteraction(){
        self.firstName.isUserInteractionEnabled = false
        self.middleName.isUserInteractionEnabled = false
        self.lastName.isUserInteractionEnabled = false
        self.medicalEmergency.isUserInteractionEnabled = false
        self.medicalHistory.isUserInteractionEnabled = false
        self.date.isUserInteractionEnabled = false
        self.time.isUserInteractionEnabled = false
        saveBtn.isHidden = true
        deleteBtn.isHidden = true
    }
    
    func viewApproveAppointementData(){
        self.viewMedical.isHidden = false
        self.medicalHistory.isHidden = true
        self.doctorName.text = "Doctor Name : \(approveAppointmentData?.doctorName ?? "")"
        self.HospitalName.text = "Hospital Name : \(approveAppointmentData?.hospitalName ?? "")"
        self.date.text = approveAppointmentData?.date ?? ""
        self.time.text = approveAppointmentData?.time ?? ""
        self.status.text = approveAppointmentData?.status ?? "Pending"
        self.firstName.text = approveAppointmentData?.pFirstname ?? ""
        self.lastName.text = approveAppointmentData?.pLastname ?? ""
        self.middleName.text = approveAppointmentData?.pMiddlename ?? ""
        if approveAppointmentData?.medicalHistory == true {
            self.viewMedical.setTitle("Yes", for: .normal)
            self.medicalBool = true
        }else {
            self.viewMedical.setTitle("No", for: .normal)
            self.medicalBool = false
        }
        self.medicalEmergency.text = approveAppointmentData?.medicalEmergency ?? ""
    }
    
    func pendingAppointmentData(doctorView: Bool) {
        self.getDoctorAvailableHour(hospitalName: appointmentList?.hospitalName ?? "", doctorEmail: appointmentList?.doctorEmail ?? "")
        self.doctorName.text = "Doctor Name : \(appointmentList?.doctorName ?? "")"
        self.HospitalName.text = "Hospital Name : \(appointmentList?.hospitalName ?? "")"
        self.date.text = appointmentList?.date ?? ""
        self.time.text = appointmentList?.time ?? ""
        self.status.text = appointmentList?.status ?? "Pending"
        self.firstName.text = appointmentList?.pFirstname ?? ""
        self.lastName.text = appointmentList?.pLastname ?? ""
        self.middleName.text = appointmentList?.pMiddlename ?? ""
        self.medicalEmergency.text = appointmentList?.medicalEmergency ?? ""
        if doctorView{
            if appointmentList?.medicalHistory == true {
                self.viewMedical.setTitle("Yes", for: .normal)
                self.medicalBool = true
            }else {
                self.viewMedical.setTitle("No", for: .normal)
                self.medicalBool = false
            }
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.medicalHistory.isOn = true
            self.medicalBool = true
        }else {
            self.medicalHistory.isOn = false
            self.medicalBool = false
        }
    }
    
    @IBAction func onDelete(_ sender: Any){
        // Create an alert controller
                let alertController = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete appointment?", preferredStyle: .alert)

                // Add a "Logout" action to the alert
                let logoutAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in

                    self.deleteAppointment()
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                // Add the actions to the alert controller
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)

                // Present the alert
        self.present(alertController, animated: false, completion: nil)
    }
    
    func deleteAppointment(){
        
            let document = self.appointmentList?.documentId ?? ""
    let data = AppointmentModel.init(patientId: document, pFirstname: self.firstName.text ?? "", pLastname: self.lastName.text ?? "", pMiddlename: self.middleName.text ?? "", doctorName: appointmentList?.doctorName, doctorEmail: self.appointmentList?.doctorEmail, hospitalName: appointmentList?.hospitalName, medicalEmergency: self.medicalEmergency.text ?? "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: medicalBool, status: self.status.text ?? "", patientEmail: UserDefaultsManager.shared.getEmail(), bookingDate: appointmentList?.bookingDate ?? 0.0, documentId: appointmentList?.documentId ?? "")
    
            FireStoreManager.shared.deleteAppointmentDetail(apppointId: document) { success in
                if success{
                    
                    FireStoreManager.shared.deleteDoctorAppointmentDetail(bookingDate: self.appointmentList?.bookingDate ?? 0.0, patientId: self.appointmentList?.patientId ?? "", status: self.appointmentList?.status ?? "", doctorEmail: self.appointmentList?.doctorEmail ?? "", data: data) { success in
                        
                        if success{
                            showOkAlertAnyWhereWithCallBack(message: "Appointment deleted successfully") {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            showOkAlertAnyWhereWithCallBack(message: "Appointment deleted successfully") {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
    //    }
        
        // Create the second button (e.g., Cancel)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                // Handle the Cancel button tap (if needed)
//                print("Cancel button tapped")
//            }
//
//            // Add the buttons to the alert controller
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//
//            // Present the alert controller
//            self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onBook(_ sender: Any) {
        if viewAppointment {
            self.viewAppointment = false
            if isValid(){
                let documentId = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let data = AppointmentModel.init(patientId: documentId, pFirstname: self.firstName.text ?? "", pLastname: self.lastName.text ?? "", pMiddlename: self.middleName.text ?? "", doctorName: appointmentList?.doctorName, doctorEmail: self.appointmentList?.doctorEmail, hospitalName: appointmentList?.hospitalName, medicalEmergency: self.medicalEmergency.text ?? "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: medicalBool, status: self.status.text ?? "", patientEmail: UserDefaultsManager.shared.getEmail(), bookingDate: appointmentList?.bookingDate ?? 0.0, documentId: appointmentList?.documentId ?? "")
                
                self.updateAppointmentData(data: data)

            }
        } else if isValid(){
                let documentId = UserDefaults.standard.string(forKey: "documentId") ?? ""
            let appointmentDataValue = AppointmentModel.init(patientId: documentId, pFirstname: self.firstName.text ?? "", pLastname: self.lastName.text ?? "", pMiddlename: self.middleName.text ?? "", doctorName: doctorDetailData?.doctorName, doctorEmail: self.doctorDetailData?.doctorEmail, hospitalName: doctorDetailData?.hospitalName, medicalEmergency: self.medicalEmergency.text ?? "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: medicalBool, status: self.status.text ?? "", patientEmail: UserDefaultsManager.shared.getEmail(), bookingDate: doctorDetailData?.bookingDate ?? 0.0, documentId: doctorDetailData?.documentId ?? "")
                
            self.callFirebaseData(data: appointmentDataValue)

            }
        }
    
    func callFirebaseData(data: AppointmentModel){
        var dateComponents = DateComponents()
        dateComponents.hour = hoursToAdd
        var formattedNewTime = String()
        
        if let newTime = calendar.date(byAdding: dateComponents, to: existingTime) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" // Adjust the date format as needed
            formattedNewTime = dateFormatter.string(from: newTime)
            print("Existing Time: \(existingTime)")
            print("New Time: \(formattedNewTime)")
        } else {
            print("Error adding hours to the existing time.")
        }
        
        
        FireStoreManager.shared.addNewAppointmentDetail(email: UserDefaultsManager.shared.getEmail(), data: data) { success in
            
            if success{
                
                CalendarManager.shared.requestAccess { success, err in
                    if success{
                        DispatchQueue.main.async {
                            CalendarManager.shared.createEvent(title: "Appointment for \(self.medicalEmergency.text ?? "") with \(self.doctorDetailData?.doctorName ?? "") booked", date: self.date.text ?? "", fromTo: "\(self.time.text ?? "") - \(formattedNewTime)")
                            
                            FireStoreManager.shared.addNewAppointmentDetailForDoctor(email: self.doctorDetailData?.doctorEmail ?? "", data: data) { success in
                                if success {
                                    showOkAlertAnyWhereWithCallBack(message: "Appointment booked successfully") {
                                        
                                        DispatchQueue.main.async {
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                        
                                        self.saveBtn.setTitle("Submit", for: .normal)
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    if let error = err{
                        print(err)
                    }
                }
                
                
            }
        }
    }
    
    func updateAppointmentData(data: AppointmentModel){
        var dateComponents = DateComponents()
        dateComponents.hour = hoursToAdd
        var formattedNewTime = String()
        
        if let newTime = calendar.date(byAdding: dateComponents, to: existingTime) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" // Adjust the date format as needed
            formattedNewTime = dateFormatter.string(from: newTime)
            print("Existing Time: \(existingTime)")
            print("New Time: \(formattedNewTime)")
        } else {
            print("Error adding hours to the existing time.")
        }
        
        FireStoreManager.shared.updateAppointmentDetail(appointDocumentID: data.documentId ?? "", email: UserDefaultsManager.shared.getEmail(), data: data) { success in
            if success{
                CalendarManager.shared.createEvent(title: "Appointment for \(self.medicalEmergency.text ?? "") with \(self.doctorDetailData?.doctorName ?? "") booked", date: self.date.text ?? "", fromTo: "\(self.time.text ?? "") - \(formattedNewTime)")
                showOkAlertAnyWhereWithCallBack(message: "Appointment updated successfully") {
                    
                        self.navigationController?.popToRootViewController(animated: true)
                                        
                }
            }
        }
        }
}

extension BookAppointment {
    
    func isValid() -> Bool{
        if(self.firstName.text!.isEmpty) {
            showAlerOnTop(message: "Please enter first name.")
            return false
        }
//        if(self.middleName.text!.isEmpty) {
//            showAlerOnTop(message: "Please enter middle name.")
//            return false
//        }
        if(self.lastName.text!.isEmpty) {
            showAlerOnTop(message: "Please enter last name.")
            return false
        }
        if(self.medicalEmergency.text!.isEmpty) {
            showAlerOnTop(message: "Please enter medical emergency.")
            return false
        }
        return true
    }
    
    
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
        formatter.dateFormat = "MM/dd/yyyy"
        date.text = formatter.string(from: datePicker.date)
        self.convertTimeForDate(selectedDate: datePicker.date)
        timeStamp = getTime(date: datePicker.date)
        self.time.text = ""
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

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}


extension BookAppointment {
    func getDayOfWeek(for date: Date) -> String {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return "Unknown"
            }
    }

    func convertTimeForDate(selectedDate: Date){
        // Usage
        let dayOfWeek = getDayOfWeek(for: selectedDate)
        print("The selected date falls on a \(dayOfWeek).")
        
        if let indexValue = self.doctorAvailableHour.firstIndex(where: { $0.contains(dayOfWeek) }) {
            let availableTime = self.doctorAvailableHour[indexValue] ?? ""
            let components = availableTime.components(separatedBy: " ")

            if components.count >= 3 {
                let separatedString = components[1...].joined(separator: " ")
                if let timeSlot = self.convertTimeFormat(separatedString, selectedDate: selectedDate) {
                    print(timeSlot)
                }
            }
        }
        
    }
    
    func convertTimeFormat(_ timeString: String, selectedDate: Date) -> String? {
        let components = timeString.components(separatedBy: " - ")
        
        if components.count == 2 {
            let startTime = components[0]
            let endTime = components[1]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h a"
            
            if let startDate = dateFormatter.date(from: startTime), let endDate = dateFormatter.date(from: endTime) {
                dateFormatter.dateFormat = "HHmm"
                
                timePicker.minimumDate = startDate
                timePicker.maximumDate = endDate
                

                let formattedStartTime = dateFormatter.string(from: startDate)
                let formattedEndTime = dateFormatter.string(from: endDate)
                return "\(formattedStartTime) - \(formattedEndTime)"
            }
        }
        
        return nil
    }
    
    
    func getDoctorAvailableHour(hospitalName: String, doctorEmail: String){
            FireStoreManager.shared.getAllDoctorList(hospitalName: hospitalName) { querySnapshot in
                
                var doctorList = [doctorDetail]()
                var itemsArray = [doctorList]
                print(querySnapshot.documents)
                for (_,document) in querySnapshot.documents.enumerated() {
                    do {
                        let item = try document.data(as: hospitalArray.self)
                        itemsArray.append(item.doctorList ?? [])
                        print(itemsArray)
                        
                    }catch let error {
                        print(error)
                    }
                }
                if itemsArray.count > 0{
                    doctorList = itemsArray[1]
                }
                
                if let index = doctorList.firstIndex(where: { dictionary in
                    if let email = dictionary.email, email.contains(doctorEmail)
                    {
                        return true
                    }
                    return false
                }) {
                    self.doctorAvailableHour = doctorList[index].availableHours ?? []
                }
                print(self.doctorAvailableHour)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"

                if let date = dateFormatter.date(from: self.date.text ?? "") {
                    print("Converted Date: \(date)")
                    self.convertTimeForDate(selectedDate: date)
                }
                
            }
    }
    
    
   
}
