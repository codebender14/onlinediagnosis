import UIKit
import Foundation
import FirebaseFirestore


class ChatVC: UIViewController {

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
        if message.sender ==  senderId {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderTextMessageBubble") as! CometChatSenderTextMessageBubble
            cell.setData(message: message)
            return cell
            
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatReceiverTextMessageBubble") as! CometChatReceiverTextMessageBubble
            cell.setData(message: message)
            return cell
           
        }
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
    
    // Add an initializer to create a MessageModel from Firestore data
    init(data: [String: Any]) {
        self.sender = data["sender"] as? String ?? ""
        self.dateSent = data["dateSent"] as? Double ?? 0.0
        self.chatId = data["chatId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
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
 
extension BookAppointment {
 
   
    @IBAction func onChat(_ sender: Any) {
    
        let userType = UserDefaultsManager.shared.getUserType()
        
        if let appointmentList = appointmentList {
            
            let chatId = "1234"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            self.navigationController?.pushViewController(vc, animated: true)
            vc.chatID = chatId
            
        }
        
      
        
        
        
        
        
//
//        if userType == UserType.patient.rawValue{
//
//        } else {
//
//        }
        
        
    
        
       
    }
}
