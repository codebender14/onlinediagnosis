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
        guard let name = self.name.text, let number = self.number.text, let cvv = self.cvv.text else {
            showAlert(message: "Please enter all the details")
            return
        }
        
        if name.isEmpty || number.isEmpty || cvv.isEmpty {
            showAlert(message: "Please enter all the details")
        } else if !isValidName(name) {
            showAlert(message: "Name should contain only alphabets and be less than 21 characters.")
        } else if !isValidCardNumber(number) {
            showAlert(message: "Card number should be 16 digits (0-9) only.")
        } else if !isValidCVV(cvv) {
            showAlert(message: "Security code should be 4 digits (0-9) only.")
        } else {
            FireStoreManager.shared.makePaymentDone(vc: self, amount: amountText, time: getTime(), chatID: self.chatID) {
                showOkAlertAnyWhereWithCallBack(message: "Payment Success 😊") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[A-Za-z]{1,21}$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }
    
    func isValidCardNumber(_ cardNumber: String) -> Bool {
        let cardNumberRegex = "^[0-9]{16}$"
        return NSPredicate(format: "SELF MATCHES %@", cardNumberRegex).evaluate(with: cardNumber)
    }
    
    func isValidCVV(_ cvv: String) -> Bool {
           let cvvRegex = "^[0-9]{3,4}$"
           return NSPredicate(format: "SELF MATCHES %@", cvvRegex).evaluate(with: cvv)
    }
    
    func getTime() -> Double {
        return Double(Date().millisecondsSince1970)
    }
}
