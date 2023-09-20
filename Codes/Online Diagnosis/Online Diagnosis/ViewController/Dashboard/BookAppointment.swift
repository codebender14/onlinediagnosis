
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

    var viewAppointment = false
    var viewApproveAppointment = false
    var appointmentData : AppointmentModel?
    var approveAppointmentData : ApproveAppointmentDetail?
    var appointmentList : AppointmentDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.date.isUserInteractionEnabled = false
        self.time.isUserInteractionEnabled = false
        
        if viewAppointment {
            self.firstName.isUserInteractionEnabled = false
            self.middleName.isUserInteractionEnabled = false
            self.lastName.isUserInteractionEnabled = false
            self.medicalEmergency.isUserInteractionEnabled = false
            saveBtn.setTitle("Done", for: .normal)
            if viewApproveAppointment {
                self.doctorName.text = "Doctor Name : \(approveAppointmentData?.doctorName ?? "")"
                self.HospitalName.text = "Hospital Name : \(approveAppointmentData?.hospitalName ?? "")"
                self.date.text = approveAppointmentData?.date ?? ""
                self.time.text = approveAppointmentData?.time ?? ""
                self.status.text = approveAppointmentData?.status ?? "Pending"
                self.firstName.text = approveAppointmentData?.pFirstname ?? ""
                self.lastName.text = approveAppointmentData?.pLastname ?? ""
                self.middleName.text = approveAppointmentData?.pMiddlename ?? ""
                self.medicalEmergency.text = approveAppointmentData?.medicalEmergency ?? ""
            } else {
                self.doctorName.text = "Doctor Name : \(appointmentList?.doctorName ?? "")"
                self.HospitalName.text = "Hospital Name : \(appointmentList?.hospitalName ?? "")"
                self.date.text = appointmentList?.date ?? ""
                self.time.text = appointmentList?.time ?? ""
                self.status.text = appointmentList?.status ?? "Pending"
                self.firstName.text = appointmentList?.pFirstname ?? ""
                self.lastName.text = appointmentList?.pLastname ?? ""
                self.middleName.text = appointmentList?.pMiddlename ?? ""
                self.medicalEmergency.text = appointmentList?.medicalEmergency ?? ""
            }
        } else {
            self.firstName.isUserInteractionEnabled = true
            self.middleName.isUserInteractionEnabled = true
            self.lastName.isUserInteractionEnabled = true
            self.medicalEmergency.isUserInteractionEnabled = true
            saveBtn.setTitle("Submit", for: .normal)

            self.doctorName.text = "Doctor Name : \(appointmentData?.doctorName ?? "")"
            self.HospitalName.text = "Hospital Name : \(appointmentData?.hospitalName ?? "")"
            self.date.text = appointmentData?.date ?? ""
            self.time.text = appointmentData?.time ?? ""
            self.status.text = appointmentData?.status ?? "Pending"
        }
    }
    
    @IBAction func onBook(_ sender: Any) {
        if viewAppointment {
            self.navigationController?.popViewController(animated: true)
        } else {
            if(self.firstName.text!.isEmpty) {
                showAlerOnTop(message: "Please enter first name.")
                return
            }
            if(self.middleName.text!.isEmpty) {
                showAlerOnTop(message: "Please enter middle name.")
                return
            }
            if(self.lastName.text!.isEmpty) {
                showAlerOnTop(message: "Please enter last name.")
                return
            }
            if(self.medicalEmergency.text!.isEmpty) {
                showAlerOnTop(message: "Please enter medical emergency.")
                return
            }
            
            else {
                let documentId = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let appointmentDataValue = AppointmentModel.init(patientId: documentId, pFirstname: self.firstName.text ?? "", pLastname: self.lastName.text ?? "", pMiddlename: self.middleName.text ?? "", doctorName: appointmentData?.doctorName, doctorEmail: self.appointmentData?.doctorEmail, hospitalName: appointmentData?.hospitalName, medicalEmergency: self.medicalEmergency.text ?? "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: true, status: self.status.text ?? "")
                
                FireStoreManager.shared.addNewAppointmentDetail(email: UserDefaultsManager.shared.getEmail(), data: appointmentDataValue) { success in
                    
                    if success{
                        FireStoreManager.shared.addNewAppointmentDetailForDoctor(email: self.appointmentData?.doctorEmail ?? "", data: appointmentDataValue) { success in
                            if success {
                                showOkAlertAnyWhereWithCallBack(message: "Appointment confirm successfully") {
                                    
                                    DispatchQueue.main.async {
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
}
