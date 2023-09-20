
import UIKit
import DropDown

class HospitalInfo: UIViewController, UITextFieldDelegate  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchDoctor: UITextField!
    @IBOutlet weak var hospitalName: UILabel!

    var doctorList : [doctorDetail] = []
    var specializationList : [String] = []
    var filterList : [doctorDetail] = []
    var searchBool = false
    var titleValue = ""
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchDoctor.delegate = self
        
        self.getDoctorList(hospitalName: titleValue)
    }
        
    func getDoctorList(hospitalName: String){
        FireStoreManager.shared.getAllDoctorList(hospitalName: hospitalName) { querySnapshot in
            
            var itemsArray = [self.doctorList]
            print(querySnapshot.documents)
            for (_,document) in querySnapshot.documents.enumerated() {
                do {
                    let item = try document.data(as: hospitalArray.self)
                    self.hospitalName.text = item.hospitalName ?? ""
                    itemsArray.append(item.doctorList ?? [])
                    print(itemsArray)
                    
                }catch let error {
                    print(error)
                }
            }
            if itemsArray.count > 0{
                self.doctorList = itemsArray[1]
            }
            
            self.specializationList = self.doctorList.map {$0.specialist ?? ""}
            print(self.specializationList)
            self.tableView.reloadData()
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Implement filtering logic here
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterData(withSearchText: searchText)
        return true
    }
    
    func filterData(withSearchText searchText: String) {
        
        if searchText.isEmpty {
            // If the search text is empty, show all items
            filterList = doctorList
            searchBool = false
        } else {
            // Use a case-insensitive search to filter items by name
            filterList = doctorList.filter { item in
                return item.specialist!.lowercased().contains(searchText.lowercased())
                   }
            searchBool = true
        }
        
        print(filterList)
        self.tableView.reloadData()
    }
}

extension HospitalInfo: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBool {
            return filterList.count
        }
        return self.doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        if searchBool{
            let data = self.filterList[indexPath.row]
            cell.titleLbl.text = "Name: \(data.firstName ?? "") \(data.lastName ?? "")"
            cell.speciality.text = "Specialization : \(data.specialist ?? "")"
            cell.dob.text = "Dob : \(data.dob ?? "")"
            cell.expert.text = "Expertise : \(data.expert ?? "")"
            cell.age.text = "age : \(data.age ?? "") Gender : \(data.gender ?? "")"
            cell.rating.text = "Rating : \(data.rating ?? "")"
        } else{
            let data = self.doctorList[indexPath.row]
            cell.titleLbl.text = "Name: \(data.firstName ?? "") \(data.lastName ?? "")"
            cell.speciality.text = "Specialization : \(data.specialist ?? "")"
            cell.dob.text = "Dob : \(data.dob ?? "")"
            cell.expert.text = "Expertise : \(data.expert ?? "")"
            cell.age.text = "age : \(data.age ?? "") Gender : \(data.gender ?? "")"
            cell.rating.text = "Rating : \(data.rating ?? "")"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBool {
            let data = self.filterList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DoctorDetailVC" ) as! DoctorDetailVC
                    
            vc.hospitalName = titleValue
            vc.doctordetail = data
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let data = self.doctorList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DoctorDetailVC" ) as! DoctorDetailVC
            vc.hospitalName = titleValue
            vc.doctordetail = data
            self.navigationController?.pushViewController(vc, animated: true)

        }



    }
}

extension HospitalInfo {
    //MARK:- Drop Down Region Methods
    func showDropDownMenu(textField:UITextField, dataSource:[String]) {
        
        self.view.endEditing(true)
        
        dropDown.anchorView = textField
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = .white
        dropDown.textColor = .black
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)! )
        
        self.dropDown.selectionAction = { (index: Int, item: String) in
            textField.placeholder = "Specialization"
            textField.text = item
//            textField.textFieldDidChange(textField)
            let doctorSpecialiation = self.specializationList[index]
            self.filterData(withSearchText: doctorSpecialiation)
        }
        dropDown.bounds.size.height = 150
        
        DispatchQueue.main.async {
            self.dropDown.show()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == searchDoctor{
            showDropDownMenu(textField: searchDoctor, dataSource: self.specializationList)
            return false
            
        } else {
            return true
        }
    }
}
