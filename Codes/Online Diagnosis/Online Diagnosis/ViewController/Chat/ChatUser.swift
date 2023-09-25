//import UIKit
//
//class ChatUser: UIViewController, UITableViewDataSource,UITableViewDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    var request : RentRequest!
//    // Define a data source array to hold the fetched RentRequest objects
//    var bookingHistory: [RentRequest] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the data source for the tableView
//        tableView.dataSource = self
//        tableView.delegate = self
//        self.tableView.showsVerticalScrollIndicator = false
//        // Register the cell class for reuse
//        tableView.register(UINib(nibName: "BookingHistory", bundle: nil), forCellReuseIdentifier: "BookingHistory")
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.bookingHistory = CoreDataHelper.shared.getMyBookings()
//        self.tableView.reloadData()
//    }
//    // Fetch the user's booking history using a Core Data fetch request
//
//
//    // MARK: - UITableViewDataSource Methods
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bookingHistory.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistory", for: indexPath) as! BookingHistory
//        // Configure the cell with data from the RentRequest object at the current indexPath
//        let booking = bookingHistory[indexPath.row]
//        cell.setData(request: booking,isFromChat: true )
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let booking = bookingHistory[indexPath.row]
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
//        vc.request = booking
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}
