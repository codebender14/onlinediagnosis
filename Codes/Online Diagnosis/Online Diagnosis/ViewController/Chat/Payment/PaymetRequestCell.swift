 
import UIKit

class PaymetRequestCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var roundView: UIView!
    var vc : ChatVC!
    
    override  func awakeFromNib() {
        roundView.layer.cornerRadius = 10
        roundView.layer.borderColor = UIColor.lightGray.cgColor
        roundView.layer.borderWidth = 1

    }
    
    @IBAction func onMakePayment(_ sender: Any) {
        
        let vc2 = vc.storyboard?.instantiateViewController(withIdentifier: "PaymentScreen") as! PaymentScreen
        vc2.amountText = self.amount.text!
        vc2.chatID = vc.chatID
        vc2.modalPresentationStyle = .fullScreen
        vc.present(vc2, animated: true)
    }
    
    func setData(message:MessageModel,vc:ChatVC) {
      
        self.amount.text = "$" + message.text
        self.vc = vc
    }
    
    
}


 
