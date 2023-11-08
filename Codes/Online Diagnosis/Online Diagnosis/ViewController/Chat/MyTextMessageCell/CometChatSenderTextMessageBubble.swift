 import UIKit

class CometChatSenderTextMessageBubble: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageView.maskedCorners(corners: [.bottomLeft , .topLeft , .topRight], radius: 12)
        messageView.dropShadow()
    }
    
   
    func setData(message:MessageModel) {
      
        if(message.text.count < 8) {
            self.message.text = "   \(message.text)   "
        }else {
            self.message.text = message.text
        }
        
        self.timeStamp.text = UserDefaultsManager.shared.getName() + " " +  message.dateSent.getTimeOnly()
        
    }
    
}
    
    
 
