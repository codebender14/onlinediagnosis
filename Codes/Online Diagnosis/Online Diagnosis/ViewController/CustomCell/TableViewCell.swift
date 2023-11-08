

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var expert: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!

    @IBOutlet weak var patientMedicalView: UIView!
    @IBOutlet weak var AcceptView: UIView!

    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var medicalLbl: UILabel!
    @IBOutlet weak var patientLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
