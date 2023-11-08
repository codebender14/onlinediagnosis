import UIKit
import Foundation
import FirebaseFirestore
 
class ChatVC: UIViewController {

    
    @IBOutlet weak var meetingButton: UIButton!
    @IBOutlet weak var chatContainer: UIView!
    let id = getEmail()
    @IBOutlet weak var textView: TextViewWithPlaceholder!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var addImages: UIButton!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var sendMessageView: UIView!
    var chatID = ""
    var messages = [MessageModel]()
    var senderId = getEmail()
    var senderName = UserDefaultsManager.shared.getName()
    var pataintEmail = ""
    var patientName = ""
 
    @IBOutlet weak var prescriptionButton: UIButton!
    
   
    
    func shortMessages() {
        messages = messages.sorted(by: {
            $0.getDate().compare($1.getDate()) == .orderedAscending
        })
    }
    
    func getMessages() {
       FireStoreManager.shared.getLatestMessages(chatID: chatID) { (documents, error) in
            if let error = error {
                // Handle the error
                print("Error retrieving messages: \(error)")
            } else if let documents = documents {
                // Create an array to store MessageModel instances
                var messages = [MessageModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    // Create a MessageModel instance from Firestore data
                    let message = MessageModel(data: data)
                    
                    // Append the message to the array
                    messages.append(message)
                }
                
                self.messages = messages
                self.shortMessages()
                self.reloadData()
                
            }
        }
    }


 
  

}

extension ChatVC {
 
    @IBAction func onSend(_ sender: Any) {
        
        
        if(isDoctor()) {
            
            if self.messages.filter({$0.messageType == 4}).count != 0 {
                
                showAlerOnTop(message: "You have already sent a prescription, and this chat cannot continue.")
                
                return
            }
        }else {
            
            if self.messages.filter({$0.messageType == 4}).count != 0 {
                
                showAlerOnTop(message: "You have already received prescription, and this chat cannot continue.")
                
                return
            }
        }
        
        
        
        
        if(self.textView.text.isEmpty) {
          
           showAlerOnTop(message: "Please enter Text")
        }
        guard let text = self.textView.text else {
            return
        }

        let msgText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !msgText.isEmpty else {
            return
        }
 
        self.textView.text = ""
        
        self.sendTextMessage(text:msgText)

    }
    
    func getTime()-> Double {
        return Double(Date().millisecondsSince1970)
    }
    
    func sendTextMessage(text: String) {
        self.view.endEditing(true)
        
     
        FireStoreManager.shared.saveChat(userEmail: getEmail().lowercased(), text:text, time: getTime(), chatID: chatID)
        
      
       // self.getMessages()
       // self.tableView.reloadData()
 
    }
    
    
}


 
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let message = messages[indexPath.row]
        
        if(message.messageType == 1) {
            if message.sender ==  senderId {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderTextMessageBubble") as! CometChatSenderTextMessageBubble
                cell.setData(message: message)
                cell.message.textColor = UIColor.white
                return cell
                
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatReceiverTextMessageBubble") as! CometChatReceiverTextMessageBubble
                cell.setData(message: message)
                cell.message.textColor = UIColor.black
                return cell
               
            }
        }
        
        
        if(message.messageType == 2) {
            
            if(isDoctor()){
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderTextMessageBubble") as! CometChatSenderTextMessageBubble
                var msgModel = message
                msgModel.text = "Payment Request Sent Of $\(message.text)"
                cell.setData(message: msgModel)
                cell.message.textColor = UIColor.green
                return cell
                
            }else {
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PaymetRequestCell") as! PaymetRequestCell
                cell.setData(message: message,vc:self)
                return cell
                
            }
         }
        
        
        
        if(message.messageType == 3) {
            
            if(isDoctor()){
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderTextMessageBubble") as! CometChatSenderTextMessageBubble
                var msgModel = message
                msgModel.text = "Payment received of \(message.text) ✅"
                cell.setData(message: msgModel)
                cell.message.textColor = UIColor.green
                return cell
                
            }else {
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatReceiverTextMessageBubble") as! CometChatReceiverTextMessageBubble
                var msgModel = message
                msgModel.text = "Payment sent of \(message.text)  ✅"
                cell.setData(message: msgModel)
                cell.message.textColor = UIColor.orange
                return cell
                
            }
         }
        
        
        if(message.messageType == 4) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell") as! PrescriptionCell
            cell.setData(message: message,vc:self)
            return cell
        
         }
       
        return UITableViewCell()
    }

 
   
}
 


import UIKit
extension ChatVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 10)
        self.chatContainer.dropShadow()
       
        self.setTableView()
        self.setNameAndTitle()
        self.getMessages()
        
        self.prescriptionButton.isHidden =  false
       
    }

    
    func setNameAndTitle() {
        self.navigationController?.title = "Chat"
    }
    
    func setTableView() {
        self.registerCells()

        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
   
    
    func registerCells() {
        self.tableView.register(UINib(nibName: "CometChatSenderTextMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatSenderTextMessageBubble")
        self.tableView.register(UINib(nibName: "CometChatReceiverTextMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatReceiverTextMessageBubble")
        self.tableView.register(UINib(nibName: "PaymetRequestCell", bundle: nil), forCellReuseIdentifier: "PaymetRequestCell")
        self.tableView.register(UINib(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
    }
    
    func reloadData(){
        self.tableView.reloadData()
        self.tableView.scroll(to: .bottom, animated: true)
        self.updateTableContentInset()
    }
     
    
    //Add this function below
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
 
    }
}


func getChatID(email1: String, email2: String) -> String {
    let comparisonResult = email1.compare(email2)
    if comparisonResult == .orderedAscending {
        return email1 + email2
    } else {
        return email2 + email1
    }
}


struct MessageModel {
    var sender: String
    var dateSent: Double
    var chatId: String
    var text: String
    var senderName: String
    var messageType: Int
    
    // Add an initializer to create a MessageModel from Firestore data
    init(data: [String: Any]) {
        self.sender = data["sender"] as? String ?? ""
        self.dateSent = data["dateSent"] as? Double ?? 0.0
        self.chatId = data["chatId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
        self.messageType = data["messageType"] as? Int ?? 1
    }
    
    func getDate() -> Date {
        Date(timeIntervalSince1970: dateSent)
    }
    
    func getDataString() -> String {
        let date = Date(timeIntervalSince1970: dateSent)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}



extension FireStoreManager {
    
   
    
      func saveChat(userEmail:String, text:String,time:Double,chatID:String){
          
         let chatDbRef = self.db.collection("Chat")
         let lastMessages = self.db.collection("LastMessages")
          
          let sender = UserDefaultsManager.shared.getEmail()
          let senderName = UserDefaultsManager.shared.getName()
          
          let data = ["senderName" : senderName,"sender": sender,"messageType":1,"dateSent":time,"chatId":chatID,"text" : text] as [String : Any]
          
          let messagesCollection = chatDbRef.document(chatID).collection("Messages")
          messagesCollection.addDocument(data: data)
          
          lastMessages.document(chatID).setData(data)
          
      }
    
    func sendPaymentRequest(vc: UIViewController,amount: String, patientEmail: String, time: Double, chatID: String) {
        let chatDbRef = self.db.collection("Chat")
        let lastMessages = self.db.collection("LastMessages")
        
        let sender = UserDefaultsManager.shared.getEmail()
        let senderName = UserDefaultsManager.shared.getName()
        
        let data = [
            "senderName": senderName,
            "sender": sender,
            "messageType": 2,
            "dateSent": time,
            "chatId": chatID,
            "text": amount
        ] as [String: Any]
        
        let messagesCollection = chatDbRef.document(chatID).collection("Messages")
        
        // Check if there is an existing payment request in the messages
        messagesCollection.whereField("messageType", isEqualTo: 2).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error, if any
                print("Error checking for existing payment request: \(error.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty {
                    // A payment request already exists; show an alert to the user
                    DispatchQueue.main.async {
                        self.showPaymentRequestAlreadySentAlert(vc:vc)
                    }
                } else {
                    // No existing payment request; add the new message
                    messagesCollection.addDocument(data: data)
                    lastMessages.document(chatID).setData(data)
                }
            }
        }
    }
    
    
    
    func showPrescriptionAlreadySentAlert(vc:UIViewController) {
            let alertController = UIAlertController(title: "Prescription Already Sent", message: "You have already sent a prescription for this patient.", preferredStyle: .alert)

            // Add an "OK" action
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            // Present the alert controller
        vc.present(alertController, animated: true, completion: nil)
        }
    
    
    func sendPrescripton(patientName:String,vc: UIViewController,prescription: String,time: Double, chatID: String,patientEmail:String,completionHandler: @escaping () -> Void) {
        
        let sender = UserDefaultsManager.shared.getEmail()
        let senderName = UserDefaultsManager.shared.getName()
        
        let data = [
            "senderName": senderName,
            "sender": sender,
            "messageType": 4,
            "dateSent": time,
            "chatId": chatID,
            "text": prescription
        ] as [String: Any]
        
        let messagesCollection = chatDbRef.document(chatID).collection("Messages")
        
        
        let prescriptionRef = self.prescription.document(patientEmail).collection("Prescriptions")
        
        // Check if there is an existing payment request in the messages
        messagesCollection.whereField("messageType", isEqualTo: 4).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error, if any
                print("Error checking for existing Prescription request: \(error.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty {
                    // A payment request already exists; show an alert to the user
                    DispatchQueue.main.async {
                        self.showPrescriptionAlreadySentAlert(vc:vc)
                    }
                } else {
                    // No existing payment request; add the new message
                    messagesCollection.addDocument(data: data)
                    self.lastMessages.document(chatID).setData(data)
                    
                    let prescriptionData = [
                        "doctorName": senderName,
                        "doctorEmail": sender,
                        "dateSent": time,
                        "chatId": chatID,
                        "patientEmail" : patientEmail,
                        "patientName" : patientName,
                        "prescription": prescription,
                        "documentID" : Int(time).description
                    ] as [String: Any]
                    
                    prescriptionRef.document(Int(time).description).setData(prescriptionData)
                    
                    completionHandler()
                }
            }
        }
    }
    
    
    
    func makePaymentDone(vc: UIViewController,amount: String, time: Double, chatID: String, completionHandler: @escaping () -> Void) {
        let chatDbRef = self.db.collection("Chat")
        let lastMessages = self.db.collection("LastMessages")
        
        let sender = UserDefaultsManager.shared.getEmail()
        let senderName = UserDefaultsManager.shared.getName()
        
        let data = [
            "senderName": senderName,
            "sender": sender,
            "messageType": 3,
            "dateSent": time,
            "chatId": chatID,
            "text": amount
        ] as [String: Any]
        
        let messagesCollection = chatDbRef.document(chatID).collection("Messages")
        
        // Check if there is an existing payment request in the messages
        messagesCollection.whereField("messageType", isEqualTo: 3).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error, if any
                print("Error checking for existing payment request: \(error.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty {
                    // A payment request already exists; show an alert to the user
                    DispatchQueue.main.async {
                        self.showPaymentAlreadySentAlert(vc:vc)
                    }
                } else {
                    // No existing payment request; add the new message
                    messagesCollection.addDocument(data: data)
                    lastMessages.document(chatID).setData(data)
                    completionHandler()
                }
            }
        }
    }

    func showPaymentRequestAlreadySentAlert(vc: UIViewController) {
        let alertController = UIAlertController(
            title: "Payment Request Already Sent",
            message: "A payment request has already been sent in this chat.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showPaymentAlreadySentAlert(vc: UIViewController) {
        let alertController = UIAlertController(
            title: "Payment Already Done",
            message: "A payment has already been done in this chat.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        vc.present(alertController, animated: true, completion: nil)
    }

    
      
      func getLatestMessages(chatID: String, completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
          let chatDbRef = self.db.collection("Chat")
          let messagesCollection = chatDbRef.document(chatID).collection("Messages")
          
          // Query the last 1000 messages
          let query = messagesCollection.order(by: "dateSent", descending: true).limit(to: 1000)
          
          // Add a snapshot listener to the query
          query.addSnapshotListener { (querySnapshot, error) in
              if let error = error {
                  print("Error fetching documents: \(error)")
                  completionHandler(nil, error)
                  return
              }
              
              // Handle the snapshot data
              let documents = querySnapshot?.documents
              completionHandler(documents, nil)
          }
      }
      
      func getChatList(completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
          let lastMessages = self.db.collection("LastMessages")
          let query = lastMessages.order(by: "dateSent", descending: true).limit(to: 1000)
          
          // Add a snapshot listener to the query
          query.addSnapshotListener { (querySnapshot, error) in
              if let error = error {
                  print("Error fetching documents: \(error)")
                  completionHandler(nil, error)
                  return
              }
              
              // Handle the snapshot data
              let documents = querySnapshot?.documents
              completionHandler(documents, nil)
          }
      }
    
    
}


 
extension Double{
    func getTimeOnly() ->String {
        
        let date = Date(milliseconds : Int64(self))
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d HH:mm"
            return "\(dateFormatter.string(from: date))"
    }
}



extension UITableView {
    
    
    enum Position {
      case top
      case bottom
    }
    
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
}



extension UIView {
    func maskedCorners(corners: UIRectCorner, radius: CGFloat) {
           
                self.clipsToBounds = true
                self.layer.cornerRadius = radius
                var masked = CACornerMask()
                if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
                if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
                if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
                if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
                self.layer.maskedCorners = masked
            }
    
    func dropShadow(scale: Bool = true , height:Int = 3 , shadowRadius:CGFloat = 3) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: height)
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
             
}


func getEmail()->String {
    return  UserDefaultsManager.shared.getEmail()
}


extension ChatVC {
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
 

extension ChatVC {
    
    @IBAction func onPrescription(_ sender: Any) {
        
        if(isDoctor()) {
            showActionSheet()
        }else {
            showActionSheet()
        }
       
    }
    
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if !isDoctor(){
            
            actionSheet.addAction(UIAlertAction(title: "Ask For Prescription", style: .default) { _ in
                // Handle the "Ask For Payment" action here
              
                self.sendTextMessage(text:"Please Send Prescription 💊💊 ")
               
            })
            
        }
         
        if isDoctor(){
            // Add "Ask For Payment" button
            actionSheet.addAction(UIAlertAction(title: "Ask For Payment", style: .default) { _ in
                // Handle the "Ask For Payment" action here
                print("Ask For Payment pressed")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.showAmountAlert()
                })
            })
        }
         

        if isDoctor(){
            // Add "Add Prescription" button
            actionSheet.addAction(UIAlertAction(title: "Add Prescription", style: .default) { _ in
                // Handle the "Add Prescription" action here
                print("Add Prescription pressed")
                
                self.showPrescriptionAlert()
            })
        }
        // Add "Cancel" button
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        
          // Present the action sheet
          present(actionSheet, animated: true, completion: nil)
      }
    
    
    func showAmountAlert() {
        let alertController = UIAlertController(title: "Enter Amount", message: "Please enter an amount:", preferredStyle: .alert)

        
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .numberPad
        }

        // Create the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Handle the user's input here
            if let textField = alertController.textFields?.first,
               let amountText = textField.text {
                
                FireStoreManager.shared.sendPaymentRequest(vc:self, amount: amountText, patientEmail: self.pataintEmail, time: self.getTime(), chatID: self.chatID)
            }
            
        }

        // Create the "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add the actions to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
  
}
   
 

func isDoctor()->Bool {
    
    let userType = UserDefaultsManager.shared.getUserType()
    if userType == UserType.doctor.rawValue{
         return true
    } else {
        return false
    }
}


extension ChatVC {
    
    
    func showPrescriptionAlert() {
           let alertController = UIAlertController(title: "Add Prescription", message: nil, preferredStyle: .alert)

           // Create a UITextView
           let textView = UITextView()
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.isScrollEnabled = true
           textView.text = "Prescription - \n"
           textView.autocorrectionType = .no
           textView.spellCheckingType = .no
           textView.smartDashesType = .no
           textView.smartQuotesType = .no
        
           alertController.view.addSubview(textView)

           // Constraints for the UITextView
           NSLayoutConstraint.activate([
               textView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 15),
               textView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -15),
               textView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60),
               textView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60),
               textView.heightAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
           ])

           // Add a "Cancel" action
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

           // Add a "Done" action
           alertController.addAction(UIAlertAction(title: "Done", style: .default) { _ in
               // Handle the "Done" action here
               if let prescription = textView.text , !prescription.isEmpty{
                   
                   FireStoreManager.shared.sendPrescripton(patientName: self.patientName, vc: self, prescription:prescription ,time: self.getTime(), chatID: self.chatID, patientEmail: self.pataintEmail.lowercased()) {
                       showOkAlertAnyWhereWithCallBack(message: "Prescription Sent ✅") {
                           self.tableView.scroll(to: .bottom, animated: true)
                       }
                   }
               }
           })

           // Present the alert controller
           present(alertController, animated: true, completion: nil)
       }
    
    
    
}
