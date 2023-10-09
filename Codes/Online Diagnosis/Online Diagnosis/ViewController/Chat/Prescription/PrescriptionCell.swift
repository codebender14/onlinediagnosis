 
import UIKit

class PrescriptionCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var datTime: UILabel!
    @IBOutlet weak var prescriptionButton: UIButton!
    var chatVc : ChatVC!
    var messageModel : MessageModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.dropShadow()
        container.layer.cornerRadius = 10
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1
    }
    
    
    
    func setData(message:MessageModel,vc:ChatVC) {
        self.messageModel = message
        self.datTime.text = message.dateSent.getTimeOnly()
        self.chatVc = vc
    }

    @IBAction func onPrescription(_ sender: Any) {
        
        
        FireStoreManager.shared.getPrescriptionDetails(pataintEmail: chatVc.pataintEmail, documentId: Int(messageModel.dateSent).description) { prescriptionModel in
            let vc = self.chatVc.storyboard?.instantiateViewController(withIdentifier: "PrescriptionVC") as! PrescriptionVC
            vc.prescriptionModel = prescriptionModel
            vc.modalPresentationStyle = .fullScreen
            self.chatVc.present(vc, animated: true)
            
            
        }
        
        
      
        
    }
    
}
