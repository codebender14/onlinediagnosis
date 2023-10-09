
import UIKit

class PaymentScreen: UIViewController {
   
   var amountText = ""
   var chatID = ""
   
   @IBOutlet weak var amount: UITextField!
   @IBOutlet weak var selectedCard: UILabel!
   @IBOutlet weak var name: UITextField!
   @IBOutlet weak var number: UITextField!
   @IBOutlet weak var cvv: UITextField!
   
   override func viewDidLoad() {
       super.viewDidLoad()
       self.amount.text = amountText
       
   }
   @IBAction func onPay(_ sender: Any) {
       let name = self.name.text!
       let number = self.number.text!
       let cvv = self.cvv.text!
       
       if name.isEmpty || number.isEmpty || cvv.isEmpty {
           showAlert(message: "Please enter all the details")
       } else {
           
         
           
           FireStoreManager.shared.makePaymentDone(vc: self, amount: amountText, time: getTime(), chatID: self.chatID) {
               
               showOkAlertAnyWhereWithCallBack(message: "Payment Success 😊") {
                   self.dismiss(animated: true)
               }
           }
            
       }
   }
   
   func showAlert(message:String) {
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
   
    func getTime()-> Double {
        return Double(Date().millisecondsSince1970)
    }
   
}
 
