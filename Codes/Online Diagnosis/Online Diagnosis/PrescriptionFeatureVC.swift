//
//  PrescriptionFeatureVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit

class PrescriptionFeatureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GetStartedBTN(_ sender: UIButton) {
        let Home = self.storyboard?.instantiateViewController(withIdentifier: "home")as! HomeVC
        self.navigationController?.pushViewController(Home, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
