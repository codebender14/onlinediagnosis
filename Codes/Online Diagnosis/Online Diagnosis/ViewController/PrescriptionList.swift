 
import UIKit
import FirebaseFirestore

class PrescriptionList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var prescriptionModel : [PrescriptionModel] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
       
        FireStoreManager.shared.getPrescriptions(patientEmail:UserDefaultsManager.shared.getEmail().lowercased() ) { prescriptionModel in
             
            self.prescriptionModel = prescriptionModel
            
            self.tableView.reloadData()
        }
    }
    
}

extension PrescriptionList {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        self.prescriptionModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        
        let data = self.prescriptionModel[indexPath.row]
        
        cell.titleLbl.text = "Patient Name : \(data.patientName )"
        cell.doctorName.text = "Doctor Name : \(data.doctorName )"
        cell.date.text = data.dateSent.epochToReadableDate()
        cell.time.text = data.dateSent.epochToReadableTime()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionVC") as! PrescriptionVC
        vc.prescriptionModel = self.prescriptionModel[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
         
    }
}


extension Double {
    func epochToReadableDate() -> String {
        let epochTimestampInSeconds = self / 1000.0 // Convert milliseconds to seconds
        let date = Date(timeIntervalSince1970: epochTimestampInSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func epochToReadableDateAndTime() -> String {
        let epochTimestampInSeconds = self / 1000.0 // Convert milliseconds to seconds
        let date = Date(timeIntervalSince1970: epochTimestampInSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
     
        return dateFormatter.string(from: date)
    }
    
    func epochToReadableTime() -> String {
        let epochTimestampInSeconds = self / 1000.0 // Convert milliseconds to seconds
        let date = Date(timeIntervalSince1970: epochTimestampInSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
