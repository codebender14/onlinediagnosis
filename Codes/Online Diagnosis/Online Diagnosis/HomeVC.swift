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
