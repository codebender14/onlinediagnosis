//
//  PatientHome.swift
//  Online Diagnosis
//
//

import UIKit

class PatientHome: UIViewController {
    @IBOutlet weak var username: UILabel!
    var appointmentData : [AppointmentDetail] = []

    @IBOutlet weak var prescriptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(prescriptionViewTapped))
        prescriptionView.addGestureRecognizer(tapGesture)
        prescriptionView.isUserInteractionEnabled = true
        
        username.text = UserDefaultsManager.shared.getName()

        self.getProfileData()
        // Do any additional setup after loading the view.
    }
    
    
      @objc func prescriptionViewTapped() {
          
          let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PrescriptionList" ) as! PrescriptionList
          self.navigationController?.pushViewController(vc, animated: true)
    
      }
    
    
    func getProfileData(){
        FireStoreManager.shared.getProfile(email: UserDefaultsManager.shared.getEmail()) { querySnapshot in
            
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    
                    let item = try document.data(as: UserDataModel.self)
                    self.appointmentData = item.AppointmentDetail ?? []
                }catch let error {
                    print(error)
                }
            }
        
        }
    }

    @IBAction func onAppointmentHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AppointmentHistory" ) as! AppointmentHistory
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @IBAction func onMedicalHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MedicalHistory" ) as! MedicalHistory
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
