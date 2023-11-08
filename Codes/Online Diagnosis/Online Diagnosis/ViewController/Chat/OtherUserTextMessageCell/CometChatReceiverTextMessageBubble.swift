
import UIKit
class CometChatReceiverTextMessageBubble: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
     
    @IBOutlet weak var name: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageView.maskedCorners(corners: [.bottomRight , .topLeft , .topRight], radius: 12)
        messageView.dropShadow()
        self.messageView.backgroundColor = .white
        self.message.textColor = .black
    }
    
   
    func setData(message:MessageModel) {
      
        if(message.text.count < 8) {
            self.message.text = "   \(message.text)   "
        }else {
            self.message.text = message.text
        }
        self.name.text = message.senderName
        self.timeStamp.text = message.dateSent.getTimeOnly()
//
        
    }
   
}
 
