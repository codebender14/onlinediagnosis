//
//  HomeVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getUserName()
    }
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func prescriptionLBL(_ sender: UIButton) {
//        let prescriptionLT = self.storyboard?.instantiateViewController(withIdentifier: "prescriptions")as! PrescriptionVC
//        self.navigationController?.pushViewController(prescriptionLT, animated: true)
    }
    
    @IBAction func medicalhistoryLBL(_ sender: UIButton) {
//        let medicalHR = self.storyboard?.instantiateViewController(withIdentifier: "medicalhistory")as! MedicalHistoryVC
//        self.navigationController?.pushViewController(medicalHR, animated: true)
    }
    
    @IBAction func viewAppointmentsBTN(_ sender: UIButton) {
//        let viewappoint = self.storyboard?.instantiateViewController(withIdentifier: "appointments")as! AppointmentsVC
//        self.navigationController?.pushViewController(viewappoint, animated: true)
    }
    
    func getUserName() {
        
        let mail = Auth.auth().currentUser?.email!
        
        let userRef = db.collection("users").whereField("email", isEqualTo: mail!)

        
        
        userRef.getDocuments() {
            (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.userNameLbl.text?.append(document.data()["firstName"] as! String)
                    }
                }
        }
    }
}
