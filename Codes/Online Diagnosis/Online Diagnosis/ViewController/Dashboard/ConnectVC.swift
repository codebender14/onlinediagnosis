//

import UIKit

class ConnectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var appointmentData : [ApproveAppointmentDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllAppointments()
    }
    
    func getAllAppointments(){
        self.appointmentData.removeAll()

        FireStoreManager.shared.getApproveAppointmentsForChat { querySnapshot in
            

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
                       let patientEmail = data["patientEmail"] as? String
                {
                        if(status.lowercased() != "pending") {
                            
                            // Create an instance of your custom model
                            let appointmentDetail = ApproveAppointmentDetail(patientId: patientId, pFirstname: pFirstname, pLastname: pLastname, pMiddlename: pMiddlename, doctorName: doctorName, hospitalName: hospitalName, medicalEmergency: medicalEmergency, date: date, time: time, medicalHistory: medicalHistory, status: status, doctorEmail: doctorEmail, bookingDate: bookingDate, documentId: document.documentID, patientEmail: patientEmail)
                            
                            // Add the custom model object to the array
                            self.appointmentData.append(appointmentDetail)
                            
                        }
                       
                    }
                
            }

            print(self.appointmentData)
            self.tableView.reloadData()
        }
    }
}

extension ConnectVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        let data = appointmentData[indexPath.row]
        
        
        if UserDefaultsManager.shared.getUserType() == UserType.patient.rawValue{
            
            cell.titleLbl.text = "\(data.doctorName ?? "")"
            cell.doctorName.text = data.doctorEmail ?? ""

        }else {
            
            cell.titleLbl.text = "\(data.pFirstname ?? "") \(data.pLastname ?? "")"
            cell.doctorName.text = data.patientEmail ?? ""

        }
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let data = appointmentData[indexPath.row]
        vc.chatID = getChatID(email1: data.doctorEmail ?? "", email2: data.patientEmail ?? "")
        vc.pataintEmail = data.patientEmail ?? ""
        vc.patientName = (data.pFirstname ?? "") + " " + (data.pLastname ?? "")
                                                  
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
