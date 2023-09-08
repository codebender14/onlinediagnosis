//
//  SignUpVC.swift
//  Online Diagnosis
//
//  Created by Chaparala,Naga Akhil on 5/30/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {

    // Access Firestore database
    let db = Firestore.firestore()
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var middleNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var ConfirmPDTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func SignUpBTN(_ sender: UIButton) {
        // Get user input from text fields
        guard let firstName = firstNameTF.text,
            let middleName = middleNameTF.text,
            let lastName = lastNameTF.text,
            let email = emailTF.text,
            let password = passwordTF.text,
            let confirmPD = ConfirmPDTF.text else {
                // Handle invalid input
                displayAlert(message: "Please fill in all fields.")
                return
        }

        // Check if any field is empty
        if firstName.isEmpty {
            displayAlert(message: "Please enter your first name.")
            return
        } else if !self.isValidName(name: firstName) {
            displayAlert(message: "Please enter valid first name.")
            return
        }

        if lastName.isEmpty {
            displayAlert(message: "Please enter your last name.")
            return
        } else if !self.isValidName(name: lastName) {
            displayAlert(message: "Please enter valid last name.")
            return
        }

        if email.isEmpty && !self.validateEmail(enteredEmail: emailTF.text!){
            displayAlert(message: "Please enter your email ID.")
            return
        } else if !self.validateEmail(enteredEmail: emailTF.text!){
            displayAlert(message: "Please enter valid email ID.")
            return
        }

        if password.isEmpty && !self.isValidPassword() {
            displayAlert(message: "Please enter your password.")
            return
        } else if !self.isValidPassword() {
            displayAlert(message: "Please enter valid password.")
            return
        }
        
        if confirmPD.isEmpty && !self.isValidPassword() {
            displayAlert(message: "Please re-enter the password.")
            return
        } else if !self.isValidPassword(){
            displayAlert(message: "Please enter valid password.")
            return
        } else if !self.isPasswordConfirmationValid(passwordTextField: self.passwordTF, confirmPasswordTextField: self.ConfirmPDTF) {
            displayAlert(message: "The passwords do not match")
            return
        }

        // Create dictionary with user data
        let userData: [String: Any] = [
            "firstName": firstName,
            "middleName": middleName,
            "lastName": lastName,
            "email": email
        ]

        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error  in
            if let error = error {
                // Handle error
                print("Error in creating account: \(error)")
                self.displayAlert(message: "Error signing up.")
            } else {
                // User data added successfully
                print("Successful sign up")
            }
        }
        

        // Add user data to a collection
        self.db.collection("users").document(email).setData([
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "middleName": middleName
        ]) { error in
            if let error = error {
                // Handle error
                print("Error adding document: \(error)")
                self.displayAlert(message: "Error signing up.")
            } else {
                // User data added successfully
                //self.displayAlert(message: "Sign up successful.")
                let listfeature = self.storyboard?.instantiateViewController(withIdentifier: "findfeature")as! FindFeaturesVC
                self.navigationController?.pushViewController(listfeature, animated: true)
            }
        }
    }
    
    func isValidName(name: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func isValidPassword() -> Bool {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 8 characters total
            let password = passwordTF.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            let passwordRegx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: password)
    }
    
    
    func isPasswordConfirmationValid(passwordTextField: UITextField, confirmPasswordTextField: UITextField) -> Bool {
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return false
        }
        
        return password == confirmPassword
    }



    // Helper method to display an alert
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func HaveAccountBTN(_ sender: UIButton) {
        let Login = self.storyboard?.instantiateViewController(withIdentifier: "login")as! LoginVC
        self.navigationController?.pushViewController(Login, animated: true)
    }
}
