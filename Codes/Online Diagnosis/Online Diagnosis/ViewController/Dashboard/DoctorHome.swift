//
//  DoctorHome.swift
//  Online Diagnosis
//
//

import UIKit
import UserNotifications

class DoctorHome: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var appointmentData : [AppointmentDetail] = []
    var upcomingData : [AppointmentDetail] = []
    var newData : [ApproveAppointmentDetail] = []

    var sectionData = ["Upcoming Appointment", "New Appointments"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        username.text = UserDefaultsManager.shared.getName()

        self.getAppointmentList()
        self.getApproveAppointmentList()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onAppointmentHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AppointmentHistory" ) as! AppointmentHistory
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getAppointmentList(){
        self.upcomingData.removeAll()
        FireStoreManager.shared.getAppointments { querySnapshot in
            print(querySnapshot.documents)
            for document in querySnapshot.documents {
                // Convert Firestore data to your custom model
                 let data = document.data()
                    if let patientId = data["patientId"] as? String,
                       let pFirstname = data["pFirstname"] as? String,
                       let pLastname = data["pLastname"] as? String,
                       let pMiddlename = data["pMiddlename"] as? String,
                       let hospitalName = data["hospitalName"] as? String,
                       let medicalEmergency = data["medicalEmergency"] as? String,
                       let date = data["date"] as? String,
                       let time = data["time"] as? String,
                       let medicalHistory = data["medicalHistory"] as? Bool,
                       let status = data["status"] as? String,
                       let doctorEmail = data["doctorEmail"] as? String,
                       let bookingDate = data["bookingDate"] as? Double,
                       let doctorName = data["doctorName"] as? String,
                       let documentId = data["documentId"] as? String,
                       let patientEmail = data["patientEmail"] as? String{
                        
                        // Create an instance of your custom model
                        let appointmentDetail = AppointmentDetail(patientId: patientId, pFirstname: pFirstname, pLastname: pLastname, pMiddlename: pMiddlename, doctorName: doctorName, hospitalName: hospitalName, medicalEmergency: medicalEmergency, date: date, time: time, medicalHistory: medicalHistory, status: status, doctorEmail: doctorEmail, bookingDate: bookingDate, documentId: document.documentID, patientEmail: patientEmail)
                        
                        // Add the custom model object to the array
                        self.upcomingData.append(appointmentDetail)
                    }
            }

            print(self.upcomingData)
            self.tableView.reloadData()
        }
    }
    
    func getApproveAppointmentList(){
        self.newData.removeAll()
        FireStoreManager.shared.getApproveAppointments { querySnapshot in
            print(querySnapshot.documents)
            for document in querySnapshot.documents {
                // Convert Firestore data to your custom model
                 let data = document.data()
                    if let patientId = data["patientId"] as? String,
                       let pFirstname = data["pFirstname"] as? String,
                       let pLastname = data["pLastname"] as? String,
                       let pMiddlename = data["pMiddlename"] as? String,
                       let hospitalName = data["hospitalName"] as? String,
                       let medicalEmergency = data["medicalEmergency"] as? String,
                       let date = data["date"] as? String,
                       let time = data["time"] as? String,
                       let medicalHistory = data["medicalHistory"] as? Bool,
                       let status = data["status"] as? String,
                       let doctorEmail = data["doctorEmail"] as? String,
                       let bookingDate = data["bookingDate"] as? Double,
                       let doctorName = data["doctorName"] as? String,
                       let documentId = data["documentId"] as? String,
                       let patientEmail = data["patientEmail"] as? String {
                        
                        // Create an instance of your custom model, patientEmail: <#String?#>
                        let appointmentDetail = ApproveAppointmentDetail(patientId: patientId, pFirstname: pFirstname, pLastname: pLastname, pMiddlename: pMiddlename, doctorName: doctorName, hospitalName: hospitalName, medicalEmergency: medicalEmergency, date: date, time: time, medicalHistory: medicalHistory, status: status, doctorEmail: doctorEmail, bookingDate: bookingDate, documentId: document.documentID, patientEmail: patientEmail)
                        
                        // Add the custom model object to the array
                        self.newData.append(appointmentDetail)
                    }
            }

            print(self.newData)
            self.tableView.reloadData()
        }
    }
}

extension DoctorHome {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count // Number of sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.upcomingData.count
        }
        else if section == 1 {
            return self.newData.count
        }
        return upcomingData.count // Number of rows in each section
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let sectionData = sectionData[indexPath.section]
        
        if sectionData == "Upcoming Appointment" {
            cell.patientMedicalView.isHidden = true
            cell.AcceptView.isHidden = false
        }
        if sectionData == "New Appointments" {
            cell.AcceptView.isHidden = true
            cell.patientMedicalView.isHidden = false
        }
        if indexPath.section == 0 {
            let keyValuePair = upcomingData[indexPath.row]
            cell.titleLbl.text = keyValuePair.pFirstname
            cell.doctorName.text = keyValuePair.medicalEmergency
            cell.date.text = keyValuePair.date
            cell.time.text = keyValuePair.time
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(self.appointmentStatus(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectAppointmentStatus(_:)), for: .touchUpInside)
        }
        
        if indexPath.section == 1 {
            if newData.count > 0{
                let keyValuePair = newData[indexPath.row]
                cell.titleLbl.text = keyValuePair.pFirstname
                cell.doctorName.text = keyValuePair.medicalEmergency
                cell.date.text = keyValuePair.date
                cell.time.text = keyValuePair.time
                
                cell.viewBtn.tag = indexPath.row
                cell.viewBtn.addTarget(self, action: #selector(self.viewMedicalReport(_:)), for: .touchUpInside)

                if keyValuePair.status != "cancelled".lowercased(){
                    cell.medicalLbl.isHidden = true
                    cell.patientLbl.isHidden = false
                    cell.viewBtn.isHidden = false

                } else {
                    cell.medicalLbl.isHidden = false
                    cell.patientLbl.isHidden = true
                    cell.viewBtn.isHidden = true

                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView()
        
        let label = UILabel()
        label.text = sectionData[section]
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 22.0)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0 // Set the desired height for the section header view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let data = self.upcomingData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            vc.appointmentList = data
            vc.doctorViewAppointment = true
            vc.viewAppointment = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let data = self.newData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            vc.approveAppointmentData = data
            vc.viewApproveAppointment = true
            vc.doctorViewAppointment = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @objc func viewMedicalReport(_ sender: UIButton) {
        let dataValue = self.newData[sender.tag]
        if dataValue.medicalHistory == false{
            showAlerOnTop(message: "Medical history is not allowed to show")
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MedicalHistory" ) as! MedicalHistory
            vc.patientId = dataValue.patientId ?? ""
            vc.doctorViewMedical = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func appointmentStatus(_ sender: UIButton) {
        let dataValue = self.upcomingData[sender.tag]
        
        self.updateAppointment(status: "Accepted", patientName: dataValue.pFirstname ?? "", doctorName: dataValue.doctorName ?? "", documentId: UserDefaultsManager.shared.getDocumentId(), tag: sender.tag)

    }
     
    @objc func rejectAppointmentStatus(_ sender: UIButton) {
        let data = self.upcomingData[sender.tag]
        self.updateAppointment(status: "Rejected", patientName: data.pFirstname ?? "", doctorName: data.doctorName ?? "", documentId: UserDefaultsManager.shared.getDocumentId(), tag: sender.tag)
    }
    
    func updateAppointment(status: String, patientName: String, doctorName: String, documentId: String, tag: Int){
        
        let data = AppointmentModel.init(patientId: self.upcomingData[tag].patientId ?? "", pFirstname: self.upcomingData[tag].pFirstname ?? "", pLastname: self.upcomingData[tag].pLastname ?? "", pMiddlename: self.upcomingData[tag].pMiddlename ?? "", doctorName: self.upcomingData[tag].doctorName ?? "", doctorEmail: UserDefaultsManager.shared.getEmail(), hospitalName: self.upcomingData[tag].hospitalName ?? "", medicalEmergency: self.upcomingData[tag].medicalEmergency ?? "", date: self.upcomingData[tag].date ?? "", time: self.upcomingData[tag].time ?? "", medicalHistory: self.upcomingData[tag].medicalHistory ?? true, status: self.upcomingData[tag].status ?? "", patientEmail: self.upcomingData[tag].patientEmail ?? "", bookingDate: self.upcomingData[tag].bookingDate ?? 0.0, documentId: self.upcomingData[tag].documentId ?? "")

        FireStoreManager.shared.updateAppointmentOfPatient(email: UserDefaultsManager.shared.getEmail(), documentid: documentId, data: data, updatedStatus: status, documentId: self.upcomingData[tag].documentId ?? "") { success in
            if success {
            
                self.approvePatientAppointment(patientData: data, status: status)
                
            }
        }
    }
    
    func approvePatientAppointment(patientData: AppointmentModel, status: String){
        FireStoreManager.shared.approvePatientAppointment(status: status, patientID: patientData.patientId ?? "", bookingDate: patientData.bookingDate ?? 0.0, email: patientData.patientEmail ?? "", data: patientData) { success in
            self.addNotification(date: patientData.date ?? "", time: patientData.time ?? "", patientName: patientData.pFirstname ?? "")
            showOkAlertAnyWhereWithCallBack(message: "Appointment \(status) successfully") {
                
                self.getAppointmentList()
                self.getApproveAppointmentList()
            }
            
        }
    }
    
    func addNotification(date: String, time: String, patientName: String){
        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Appointment"
        content.body = "You have appointment with \(patientName) within 5 minute"
        content.sound = UNNotificationSound.default
        
        // Set the date and time when you want the notification to be delivered
        // Example usage:
        if let dateComponents = convertDateAndTimeToComponents(dateString: date, timeString: time) {
            print(dateComponents)
            // Create a calendar trigger with the specified date and time
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Create a notification request with a unique identifier
            let identifier = "YourNotificationIdentifier"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // Add the notification request to the notification center
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        } else {
            print("Invalid date or time format")
        }
        
    }
    
    func convertDateAndTimeToComponents(dateString: String, timeString: String) -> DateComponents? {
        // Create a DateFormatter for the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Create a DateFormatter for the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Parse the date and time strings
        guard let date = dateFormatter.date(from: dateString), let time = timeFormatter.date(from: timeString) else {
            return nil // Invalid date or time format
        }

        // Create a Calendar instance
        let calendar = Calendar.current

        // Extract date components from the date and time
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        // Combine date and time components
        var finalDateComponents = DateComponents()
        finalDateComponents.year = dateComponents.year
        finalDateComponents.month = dateComponents.month
        finalDateComponents.day = dateComponents.day
        finalDateComponents.hour = timeComponents.hour
        finalDateComponents.minute = timeComponents.minute

        return finalDateComponents
    }
}

class CustomHeaderView: UIView {
    // Customize the appearance of your section header view here
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white // Set the background color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
