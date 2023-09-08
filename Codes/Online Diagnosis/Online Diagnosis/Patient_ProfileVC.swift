//
//  Patient_ProfileVC.swift
//  Online Diagnosis
//
//  Created by Naga Akhil Chaparala on 9/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Patient_ProfileVC: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getDataFromDB()
    }
    

    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var middlename: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
    
    @IBOutlet weak var emailID: UITextField!
    
    @IBAction func patient_logoutBTN(_ sender: UIButton) {
        let logout = self.storyboard?.instantiateViewController(withIdentifier: "loggedout")as! LoginSignUpVC
        self.navigationController?.pushViewController(logout, animated: true)
    }
    
    @IBAction func edit_details(_ sender: UIButton) {
    }
    
    @IBAction func changepasswordBTN(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getDataFromDB() {
        let usersProfile = self.db.collection("users").document((Auth.auth().currentUser?.email)!)
        
        usersProfile.getDocument {
            (document, error) in
            if let document = document, document.exists {
                let userDetails = document.data()!
                
                self.firstname.text = userDetails["firstName"] as? String
                self.lastname.text = userDetails["lastName"] as? String
                self.middlename.text = userDetails["middleName"] as? String
                self.emailID.text = userDetails["email"] as? String
            }
        }
    }

}
