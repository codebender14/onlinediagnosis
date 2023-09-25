//
//  AppointmentHistory.swift
//  Online Diagnosis
//
//

import UIKit
import FirebaseFirestore

class AppointmentHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var appointmentData : [AppointmentDetail] = []
    var approveAppointmentData : [ApproveAppointmentDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            self.getApproveAppointmentList()
        } else {
            self.getAppointmentList()
        }
        
    }
    
    func getAppointmentList() {
        self.appointmentData.removeAll()
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
                        self.appointmentData.append(appointmentDetail)
                    }
                
            }

            print(self.appointmentData)
            self.tableView.reloadData()
        }
    }
    
    func getApproveAppointmentList(){
        self.approveAppointmentData.removeAll()

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
                        
                        // Create an instance of your custom model
                        let appointmentDetail = ApproveAppointmentDetail(patientId: patientId, pFirstname: pFirstname, pLastname: pLastname, pMiddlename: pMiddlename, doctorName: doctorName, hospitalName: hospitalName, medicalEmergency: medicalEmergency, date: date, time: time, medicalHistory: medicalHistory, status: status, doctorEmail: doctorEmail, bookingDate: bookingDate, documentId: document.documentID, patientEmail: patientEmail)
                        
                        // Add the custom model object to the array
                        self.approveAppointmentData.append(appointmentDetail)
                    }
                
            }

            print(self.approveAppointmentData)
            self.tableView.reloadData()
        }
    }

}

extension AppointmentHistory {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            return self.approveAppointmentData.count
        } else {
            return self.appointmentData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            let data = approveAppointmentData[indexPath.row]
            cell.titleLbl.text = "Patient Name : \(data.pFirstname ?? "")"
            cell.doctorName.text = "Doctor Name : \(data.doctorName ?? "")"
            cell.date.text = data.date
            cell.time.text = data.time

        }
        else {
            let data = appointmentData[indexPath.row]
            cell.titleLbl.text = "Patient Name : \(data.pFirstname ?? "")"
            cell.doctorName.text = "Doctor Name : \(data.doctorName ?? "")"
            cell.date.text = data.date
            cell.time.text = data.time
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.patient.rawValue{
            let data = self.appointmentData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            
            vc.viewAppointment = true
            vc.appointmentList = data
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let data = self.approveAppointmentData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            
            vc.approveAppointmentData = data
            vc.viewApproveAppointment = true
            vc.viewAppointment = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
