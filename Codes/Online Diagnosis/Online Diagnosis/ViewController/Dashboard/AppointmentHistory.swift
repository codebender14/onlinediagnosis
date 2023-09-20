//
//  AppointmentHistory.swift
//  Online Diagnosis
//
//

import UIKit

class AppointmentHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var appointmentData : [AppointmentDetail] = []
    var approveAppointmentData : [ApproveAppointmentDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            self.getApproveAppointmentList()
        } else {
            self.getAppointmentList()
        }
    }
    

    func getAppointmentList(){
        let email = UserDefaultsManager.shared.getEmail()
        FireStoreManager.shared.getProfile(email: email) { querySnapshot in
            
            var itemsArray = [self.appointmentData]
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
            self.appointmentData = itemsArray[1]
            self.tableView.reloadData()

        }
    }
    
    func getApproveAppointmentList(){
        let email = UserDefaultsManager.shared.getEmail()
        FireStoreManager.shared.getProfile(email: email) { querySnapshot in
            
            var itemsArray = [self.approveAppointmentData]
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
            self.approveAppointmentData = itemsArray[1]
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
