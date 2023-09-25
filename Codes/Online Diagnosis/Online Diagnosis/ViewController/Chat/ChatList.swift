 
import UIKit

class ChatList: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        container.dropShadow(shadowRadius:10)
    }
    
    func setData(message:MessageModel){
        
        print(message)
        self.name.text  = "Name - \(message.senderName)"
        self.email.text  = "Email - \(message.sender)"
        self.time.text  = message.dateSent.getTimeOnly()
        self.message.text  = message.text
    }
}
