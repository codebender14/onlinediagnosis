//
//  DoctorHome.swift
//  Online Diagnosis
//
//

import UIKit

class DoctorHome: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var appointmentData : [AppointmentDetail] = []
    var upcomingData : [AppointmentDetail] = []
//    var newData : [AppointmentDetail] = []

    var sectionData = ["Upcoming Appointment", "New Appointments"]
    
    var newData: [ApproveAppointmentDetail] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        username.text = UserDefaultsManager.shared.getName()

        self.getAppointmentList()
        self.getApproveAppointmentList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAppointmentHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AppointmentHistory" ) as! AppointmentHistory
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAppointmentList(){
        let email = UserDefaultsManager.shared.getEmail()
        self.upcomingData.removeAll()
        FireStoreManager.shared.getProfile(email: email) { querySnapshot in
            
            var itemsArray = [self.upcomingData]
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    let item = try document.data(as: UserDataModel.self)
                    itemsArray.append(item.AppointmentDetail ?? [])
                    
                    print(itemsArray)
                 
                }catch let error {
                    print(error)
                }
            }
            self.upcomingData = itemsArray[1]
            self.tableView.reloadData()

        }
    }
    
    func getApproveAppointmentList(){
        let email = UserDefaultsManager.shared.getEmail()
        self.newData.removeAll()
        FireStoreManager.shared.getProfile(email: email) { querySnapshot in
            
            var itemsArray = [self.newData]
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    let item = try document.data(as: UserDataModel.self)
                    itemsArray.append(item.ApproveAppointmentDetail ?? [])
                    
                    print(itemsArray)
                 
                }catch let error {
                    print(error)
                }
            }
            self.newData = itemsArray[1]
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
            cell.doctorName.text = keyValuePair.doctorName
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
                cell.doctorName.text = keyValuePair.doctorName
                cell.date.text = keyValuePair.date
                cell.time.text = keyValuePair.time
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
            vc.viewAppointment = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let data = self.newData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAppointment" ) as! BookAppointment
            vc.approveAppointmentData = data
            vc.viewApproveAppointment = true
            vc.viewAppointment = true
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
        let userdata = ["patientId": self.upcomingData[tag].patientId ?? "", "pFirstname": self.upcomingData[tag].pFirstname ?? "", "pLastname": self.upcomingData[tag].pLastname ?? "", "pMiddlename": self.upcomingData[tag].pMiddlename ?? "", "doctorName": self.upcomingData[tag].doctorName ?? "", "doctorEmail": UserDefaultsManager.shared.getEmail(), "hospitalName": self.upcomingData[tag].hospitalName ?? "", "medicalEmergency": self.upcomingData[tag].medicalEmergency ?? "", "date": self.upcomingData[tag].date ?? "", "time": self.upcomingData[tag].time ?? "", "medicalHistory": true, "status": self.upcomingData[tag].status ?? ""] as [String : Any]
        
        //        FireStoreManager.shared.updateAppointmentArrayValuesByKeys(documentID: documentId, arrayField: "AppointmentDetail", indexToUpdate: tag, newValue: ["patientId": self.upcomingData[tag].patientId ?? "", "pFirstname": self.upcomingData[tag].pFirstname ?? "", "pLastname": self.upcomingData[tag].pLastname ?? "", "pMiddlename": self.upcomingData[tag].pMiddlename ?? "", "doctorName": self.upcomingData[tag].doctorName ?? "", "doctorEmail": UserDefaultsManager.shared.getEmail(), "hospitalName": self.upcomingData[tag].hospitalName ?? "", "medicalEmergency": self.upcomingData[tag].medicalEmergency ?? "", "date": self.upcomingData[tag].date ?? "", "time": self.upcomingData[tag].time ?? "", "medicalHistory": true, "status": status] as [String : Any], completion: { success in
        //                            if success{
        //                                showAlerOnTop(message: "Appointment \(status) successfully")
        //                                self.getAppointmentList()
        //                                self.navigationController?.popViewController(animated: true)
        //                            }
        //                        })
        
        FireStoreManager.shared.updateAppointmentOfPatient(email: UserDefaultsManager.shared.getEmail(), documentid: documentId, userData: userdata, patientId: self.upcomingData[tag].patientId ?? "", pFirstname: self.upcomingData[tag].pFirstname ?? "", pLastname: self.upcomingData[tag].pLastname ?? "", pMiddlename: self.upcomingData[tag].pMiddlename ?? "", doctorName: self.upcomingData[tag].doctorName ?? "", doctorEmail: UserDefaultsManager.shared.getEmail(), hospitalName: self.upcomingData[tag].hospitalName ?? "", medicalEmergency: self.upcomingData[tag].medicalEmergency ?? "", date: self.upcomingData[tag].date ?? "", time: self.upcomingData[tag].time ?? "", medicalHistory: true, status: self.upcomingData[tag].status ?? "", updatedStatus: status) { success in
            if success {
                showOkAlertAnyWhereWithCallBack(message: "Appointment \(status) successfully") {
                    
                    self.getAppointmentList()
                    self.getApproveAppointmentList()
                    
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }
            }
        }
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
