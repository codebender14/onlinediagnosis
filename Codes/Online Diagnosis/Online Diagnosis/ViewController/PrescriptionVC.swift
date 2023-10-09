 

import UIKit
 
class PrescriptionVC: UIViewController {
    
    @IBOutlet weak var prescriptionTextView: UITextView!
    
    var prescriptionModel : PrescriptionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        prescriptionTextView.isEditable = false
        
        let prescription =  prescriptionModel.prescription
        
        // Create a formatted prescription string
        let prescriptionText = """
            Date Sent: \(prescriptionModel.dateSent.epochToReadableDateAndTime())
            
            Doctor Email: \(prescriptionModel.doctorEmail)
            
            Doctor Name: \(prescriptionModel.doctorName)
            
            Patient Email: \(prescriptionModel.patientEmail)
            
            Patient Name: \(prescriptionModel.patientName)
            
            Prescription Details:
            
            
            
            \(prescription)
            """
        
        // Set the prescription text to the UILabel
        prescriptionTextView.text = prescriptionText
    }
}
