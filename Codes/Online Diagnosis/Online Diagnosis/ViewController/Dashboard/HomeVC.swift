

import UIKit

enum UserType : String {
    case patient = "Patient"
    case doctor = "Doctor"
}

class HomeVC: UIViewController {
    @IBOutlet weak var doctorContainer: UIView!
    @IBOutlet weak var patientContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let userType = UserDefaultsManager.shared.getUserType()
        
        if userType == UserType.patient.rawValue {
            self.patientContainer.isHidden = false
            self.doctorContainer.isHidden = true
        } else {
            self.patientContainer.isHidden = true
            self.doctorContainer.isHidden = false
        }
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
