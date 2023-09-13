//
//  HospitalListVC.swift
//  Online Diagnosis
//
//  Created by Naga Akhil Chaparala on 9/12/23.
//

import UIKit

class HospitalInfoVC: UIViewController {

    var hospitalName: String?
    // Add additional properties for hospital information here

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the UI elements
        title = "Hospital Info"

        let nameLabel = UILabel()
        nameLabel.text = hospitalName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add additional labels or UI elements for hospital information here

        view.addSubview(nameLabel)

        // Configure constraints for nameLabel and other UI elements
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            // Add constraints for other UI elements here
        ])
    }

    // You can add functions to populate hospital information here

}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


