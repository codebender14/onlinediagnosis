
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

    var appointmentData : AppointmentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doctorName.text = "Doctor Name : \(appointmentData?.doctorName ?? "")"
        self.HospitalName.text = "Hospital Name : \(appointmentData?.hospitalName ?? "")"
        self.date.text = appointmentData?.date ?? ""
        self.time.text = appointmentData?.time ?? ""
        self.status.text = appointmentData?.status ?? "Pending"

    }
    
    @IBAction func onBook(_ sender: Any) {
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
            let appointmentDataValue = AppointmentModel.init(patientId: documentId, pFirstname: self.firstName.text ?? "", pLastname: self.lastName.text ?? "", pMiddlename: self.middleName.text ?? "", doctorName: appointmentData?.doctorName, hospitalName: appointmentData?.hospitalName, medicalEmergency: self.medicalEmergency.text ?? "", date: self.date.text ?? "", time: self.time.text ?? "", medicalHistory: true, status: self.status.text ?? "")
            
            FireStoreManager.shared.addNewAppointmentDetail(email: UserDefaultsManager.shared.getEmail(), data: appointmentDataValue) { success in
                showAlerOnTop(message: "Appointment confirm successfully")
            }
        }
        
    }
}
