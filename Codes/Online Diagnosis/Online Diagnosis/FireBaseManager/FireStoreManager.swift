
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift


class FireStoreManager {
   
   public static let shared = FireStoreManager()
   var hospital = [String]()

   var db: Firestore!
   var dbRef : CollectionReference!
   var prescription : CollectionReference!
   var lastMessages : CollectionReference!
   var chatDbRef : CollectionReference!
   
   init() {
       let settings = FirestoreSettings()
       Firestore.firestore().settings = settings
       db = Firestore.firestore()
       dbRef = db.collection("Users")
       prescription = db.collection("Prescription")
       lastMessages = db.collection("LastMessages")
       chatDbRef = db.collection("Chat")
     
   }
   
   func signUp(firstName:String,middleName:String,lastName:String,dob:String,gender:String,email:String,password:String,userType:String) {
       
       self.checkAlreadyExistAndSignup(firstName:firstName,middleName:middleName,lastName:lastName,dob:dob,gender:gender,email:email,password:password,userType:userType)
   }
   
   func doctorsignUp(firstName:String,middleName:String,lastName:String,dob:String,gender:String,email:String,password:String,userType:String, specialist : String, expert: String, rating: String, achievement : String, awards: String, availableHours : [String]) {
       
       self.doctorcheckAlreadyExistAndSignup(firstName:firstName,middleName:middleName,lastName:lastName,dob:dob,gender:gender,email:email,password:password,userType:userType, specialist : specialist, expert: expert, rating: rating, achievement : achievement, awards: awards, availableHours : availableHours)
   }
   
   func doctorcheckAlreadyExistAndSignup(firstName:String,middleName:String,lastName:String,dob:String,gender:String,email:String,password:String,userType:String, specialist : String, expert: String, rating: String, achievement : String, awards: String, availableHours : [String]) {
       
       doctorgetQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
            
           print(querySnapshot.count)
           
           if(querySnapshot.count > 0) {
               showAlerOnTop(message: "This Email is Already Registerd!!")
           }else {
               
               // Signup
               
               let data = ["firstName":firstName,"middleName":middleName,"lastName":lastName,"dob":dob,"gender":gender,"email":email,"password":password,"userType":userType, "specialist" : specialist, "expert": expert, "rating": rating, "achievement" : achievement, "awards": awards, "availableHours" : availableHours] as [String : Any]
               
               self.addDataToFireStore(data: data) { _ in
                   
                 
                   showOkAlertAnyWhereWithCallBack(message: "Doctor Registration Success!!") {
                        
                       DispatchQueue.main.async {
                           SceneDelegate.shared?.loginCheckOrRestart()
                       }
                      
                   }
                   
               }
              
           }
       }
   }
   
   func doctorgetQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
       let dbre = db.collection("Users")
       dbre.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
           
           if let err = err {
               
               showAlerOnTop(message: "Error getting documents: \(err)")
                           return
           }else {
               
               if let querySnapshot = querySnapshot {
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
       }
       
   }
   
   func login(email:String,password:String,completion: @escaping (Bool)->()) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
        
           print(querySnapshot?.count)

           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Email id not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")

                   if let pwd = document.data()["password"] as? String{

                       if(pwd == password) {

                           let name = document.data()["firstName"] as? String ?? ""
                           let middlename = document.data()["middleName"] as? String ?? ""
                           let lastname = document.data()["lastName"] as? String ?? ""
                           let email = document.data()["email"] as? String ?? ""
                           let userType = document.data()["userType"] as? String ?? ""
                           
                           UserDefaultsManager.shared.saveData(name: name, middleName: middlename, lastname: lastname, email: email, userType: userType)
                           completion(true)

                       }else {
                           showAlerOnTop(message: "Password doesn't match")
                       }


                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
       
   func getPassword(email:String,password:String,completion: @escaping (String)->()) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
        
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Email id not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")
                   if let pwd = document.data()["password"] as? String{
                           completion(pwd)
                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
   
   func checkAlreadyExistAndSignup(firstName:String,middleName:String,lastName:String,dob:String,gender:String,email:String,password:String,userType:String) {
       
       getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
            
           print(querySnapshot.count)
           
           if(querySnapshot.count > 0) {
               showAlerOnTop(message: "This Email is Already Registerd!!")
           }else {
               
               // Signup
               
               let data = ["firstName":firstName,"middleName":middleName,"lastName":lastName,"dob":dob,"gender":gender,"email":email,"password":password,"userType":userType] as [String : Any]
               
               self.addDataToFireStore(data: data) { _ in
                   
                 
                   showOkAlertAnyWhereWithCallBack(message: "Registration Success!!") {
                        
                       DispatchQueue.main.async {
                           SceneDelegate.shared?.loginCheckOrRestart()
                       }
                      
                   }
                   
               }
              
           }
       }
   }
   
   func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
       
       dbRef.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
           
           if let err = err {
               
               showAlerOnTop(message: "Error getting documents: \(err)")
                           return
           }else {
               
               if let querySnapshot = querySnapshot {
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
       }
       
   }
   
   func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
       let dbr = db.collection("Users")
       dbr.addDocument(data: data) { err in
                  if let err = err {
                      showAlerOnTop(message: "Error adding document: \(err)")
                  } else {
                      completionHandler("success")
                  }
    }
       
       
   }
   
   func getAllDoctorList(hospitalName:String,completionHandler:@escaping (QuerySnapshot) -> Void){
       
       
       let  query = db.collection("Hospital").whereField("hospitalName", isEqualTo: hospitalName)
       
       query.getDocuments { (snapshot, err) in
                   
           if let _ = err {
                 return
           }else {
               
               
               if let querySnapshot = snapshot {
                   return completionHandler(querySnapshot)
               }else {
                   return
               }
              
           }
       }
         
   }

   
   func getHospital(completionHandler:@escaping (QuerySnapshot) -> Void){
       
       
       let dbRef = db.collection("Hospital")
    
       dbRef.getDocuments { snap, error in
           
           if let _ = error {
               
           }else {
               
               if let querySnapshot = snap {
                   
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
          
       }


   }
   
    
    func getPrescriptionDetails(pataintEmail: String, documentId: String, completionHandler: @escaping (PrescriptionModel?) -> Void) {
        let dbRef = prescription.document(pataintEmail).collection("Prescriptions").document(documentId)
        
        dbRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Error getting prescription document: \(error)")
                completionHandler(nil)
            } else if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? [:]
                let prescriptionModel = PrescriptionModel(data: data)
                completionHandler(prescriptionModel)
            } else {
                print("Prescription document does not exist")
                completionHandler(nil)
            }
        }
    }
    
    
    func getPrescriptions(patientEmail: String, completionHandler: @escaping ([PrescriptionModel]) -> Void) {
        let dbRef = prescription.document(patientEmail).collection("Prescriptions")
        
        dbRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting prescription documents: \(error)")
                completionHandler([])
            } else {
                var prescriptions: [PrescriptionModel] = []
                
                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    let prescriptionModel = PrescriptionModel(data: data)
                    prescriptions.append(prescriptionModel)
                }
                
                completionHandler(prescriptions)
            }
        }
    }

    

    
    
   func addNewAppointmentDetail(email: String, data: AppointmentModel,completion: @escaping (Bool)->()) {
       let data = ["patientId": data.patientId ?? "",
                   "pFirstname": data.pFirstname ?? "",
                   "pLastname": data.pLastname ?? "",
                   "pMiddlename": data.pMiddlename ?? "",
                   "doctorName": data.doctorName ?? "",
                   "hospitalName": data.hospitalName ?? "",
                   "medicalEmergency": data.medicalEmergency ?? "",
                   "date": data.date ?? "",
                   "time": data.time ?? "",
                   "medicalHistory": data.medicalHistory ?? "",
                   "status": data.status ?? "",
                   "doctorEmail": data.doctorEmail ?? "",
                   "patientEmail": data.patientEmail ?? "",
                   "bookingDate": data.bookingDate ?? 0.0,
                   "documentId": data.documentId ?? ""] as [String : Any]
       let path = self.dbRef.document(UserDefaultsManager.shared.getDocumentId()).collection("Appoinments")
       path.addDocument(data: data) { error in
           if let error = error {
               // Handle the error here
               print("Error adding document: \(error.localizedDescription)")
           } else {
               // Document added successfully
               completion(true)
           }
       }
   }
   
   func addNewAppointmentDetailForDoctor(email: String, data: AppointmentModel,completion: @escaping (Bool)->()) {
       
       let data = ["patientId": data.patientId ?? "",
                    "pFirstname": data.pFirstname ?? "",
                    "pLastname": data.pLastname ?? "",
                    "pMiddlename": data.pMiddlename ?? "",
                    "doctorName": data.doctorName ?? "",
                    "hospitalName": data.hospitalName ?? "",
                    "medicalEmergency": data.medicalEmergency ?? "",
                    "date": data.date ?? "",
                    "time": data.time ?? "",
                    "medicalHistory": data.medicalHistory ?? "",
                   "status": data.status ?? "","doctorEmail": data.doctorEmail ?? "","patientEmail": data.patientEmail ?? "",
                   "bookingDate": data.bookingDate ?? 0.0,
                   "documentId" : data.documentId ?? ""] as [String : Any]
       
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
           
           print(querySnapshot?.count)
           
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Doctor email id not found!!")
           }else {
               
               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   let doctorDocumentID = document.documentID
                   let path = self.dbRef.document(doctorDocumentID).collection("Appoinments")
                   path.addDocument(data: data) { error in
                       if let error = error {
                           // Handle the error here
                           print("Error adding document: \(error.localizedDescription)")
                       } else {
                           // Document added successfully
                           completion(true)
                       }
                   }
                   
               }
           }
       }
   }
   
   func updateAppointmentDetail(appointDocumentID: String, email: String, data: AppointmentModel,completionHandler: @escaping (Bool)->()) {
       let data = ["patientId": data.patientId ?? "",
                   "pFirstname": data.pFirstname ?? "",
                   "pLastname": data.pLastname ?? "",
                   "pMiddlename": data.pMiddlename ?? "",
                   "doctorName": data.doctorName ?? "",
                   "hospitalName": data.hospitalName ?? "",
                   "medicalEmergency": data.medicalEmergency ?? "",
                   "date": data.date ?? "",
                   "time": data.time ?? "",
                   "medicalHistory": data.medicalHistory ?? "",
                   "status": data.status ?? "",
                   "doctorEmail": data.doctorEmail ?? "",
                   "patientEmail": data.patientEmail ?? "",
                   "bookingDate": data.bookingDate ?? 0.0,
                   "documentId": data.documentId ?? ""] as [String : Any]
       let query = self.dbRef.document(UserDefaultsManager.shared.getDocumentId()).collection("Appoinments")
       query.document(appointDocumentID).updateData(data) { success in
                   return completionHandler(true)
       }

   }
   
   func deleteAppointmentDetail(apppointId: String, completion: @escaping (Bool)->()) {
       let documentReference = self.dbRef.document(UserDefaultsManager.shared.getDocumentId()).collection("Appoinments").document(apppointId)
       
       documentReference.delete { error in
           if let error = error {
               print("Error deleting document: \(error.localizedDescription)")
           } else {
               completion(true)
               print("Document deleted successfully!")
           }
       }
   }
   
    func deleteDoctorAppointmentDetail(bookingDate: Double, patientId: String, status: String, doctorEmail: String, data: AppointmentModel, completion: @escaping (Bool)->()) {
        let reference = self.dbRef.whereField("email", isEqualTo: doctorEmail)
    
        reference.getDocuments { (querySnapshot, err) in
            
            print(querySnapshot?.count)
            
            if(querySnapshot?.count == 0) {
                showAlerOnTop(message: "Doctor email id not found!!")
            }else {
                var path = "ApproveAppointments"
                
                if status == "Pending".lowercased() {
                    path = "Appoinments"
                }
                
                for document in querySnapshot!.documents {
                    let doctorDocumentID = document.documentID
                    
                    self.dbRef.document(doctorDocumentID).collection(path)
                            .whereField("patientId", isEqualTo: patientId)
                            .getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    print("Error querying documents: \(error.localizedDescription)")
                                    return
                                }

                                guard let documents = querySnapshot?.documents else {
                                    print("No documents found with the specified email.")
                                    return
                                }
                                
                            let doctorDocumentID = document.documentID
                            let documentReference = self.dbRef.document(doctorDocumentID)

                            if status == "Pending".lowercased(){
                                documentReference.delete { error in
                                    if let error = error {
                                        print("Error deleting document: \(error.localizedDescription)")
                                    } else {
                                        completion(true)
                                        print("Document deleted successfully!")
                                    }
                                }
                            }

                            else {
                                self.deletePendingAppoinmentFromDoctor(bookingDate: bookingDate, doctorDocumentId: doctorDocumentID, doctorEmail: doctorEmail, data: data) { success in
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        
    }
    
    func deletePendingAppoinmentFromDoctor(bookingDate: Double, doctorDocumentId: String, doctorEmail: String, data: AppointmentModel, completion: @escaping (Bool)->()) {
        let data = ["patientId": data.patientId ?? "",
                    "pFirstname": data.pFirstname ?? "",
                    "pLastname": data.pLastname ?? "",
                    "pMiddlename": data.pMiddlename ?? "",
                    "doctorName": data.doctorName ?? "",
                    "hospitalName": data.hospitalName ?? "",
                    "medicalEmergency": data.medicalEmergency ?? "",
                    "date": data.date ?? "",
                    "time": data.time ?? "",
                    "medicalHistory": data.medicalHistory ?? "",
                    "status": "Cancelled".lowercased(),
                    "doctorEmail": data.doctorEmail ?? "",
                    "patientEmail": data.patientEmail ?? "",
                    "bookingDate": data.bookingDate ?? 0.0,
                    "documentId": data.documentId ?? ""] as [String : Any]

        let query = self.dbRef.document(doctorDocumentId).collection("ApproveAppointments").whereField("bookingDate", isEqualTo: bookingDate)

        query.getDocuments { querySnapshot, err in
            for document in querySnapshot!.documents {
                let appointDocumentID = document.documentID
                let documentReference = self.dbRef.document(doctorDocumentId).collection("ApproveAppointments").document(appointDocumentID)
                
                documentReference.setData(data) { success in
                    print("Document deleted successfully!")

                    completion(true)
                }
            }
        }
    }
    
    
   func addMedicalDetail(firstname: String?, middlename: String?, lastname: String?, dob: String?, gender: String?, phoneNo: String?, address: String?, weight: String?, height: String?, medication: String?, medicalProblem: String?,patientId: String?,completion: @escaping (Bool)->()) {
       
       let medicalData = ["firstname": firstname ?? "", "middlename": middlename ?? "", "lastname": lastname ?? "", "dob": dob ?? "", "gender": gender ?? "", "phoneNo": phoneNo ?? "", "address": address ?? "", "weight": weight ?? "", "height": height ?? "", "medication": medication ?? "", "medicalProblem": medicalProblem ?? "","patientId": UserDefaultsManager.shared.getDocumentId()] as [String : Any]
       
       let emailId = UserDefaultsManager.shared.getEmail()
       let medicalCollection = db.collection("MedicalReport")
       
       medicalCollection.document(emailId).setData(medicalData) { error in
           if let error = error {
               print("Error adding document: \(error.localizedDescription)")
           } else {
               completion(true)
               print("Document added successfully")
           }
       }
   }
   
    func getMedicalDetail(patientId: String,completionHandler:@escaping (QuerySnapshot) -> Void) {
       let  query = db.collection("MedicalReport").whereField("patientId", isEqualTo: patientId)
       
       query.getDocuments { snap, error in
           
           if let _ = error {
               
           }else {
               
               if let querySnapshot = snap {
                   
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
          
       }
  }
   
   func getProfile(email:String,completionHandler:@escaping (QuerySnapshot) -> Void) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { snap, error in
           
           if let _ = error {
               
           }else {
               
               if let querySnapshot = snap {
                   
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
          
       }
  }

   func getAppointments(completionHandler:@escaping (QuerySnapshot) -> Void) {
       
       let query = db.collection("Users").document(UserDefaultsManager.shared.getDocumentId()).collection("Appoinments")
               
       query.getDocuments { snap, error in
           
           if let _ = error {
               
           }else {
               
               if let querySnapshot = snap {
                   
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
          
       }
  }
    
    func getApproveAppointmentsForChat(completionHandler:@escaping (QuerySnapshot) -> Void) {
        
        
        var path = "ApproveAppointments"
        
        if UserDefaultsManager.shared.getUserType() == UserType.patient.rawValue{
            path = "Appoinments"
        }
        
        let query = db.collection("Users").document(UserDefaultsManager.shared.getDocumentId()).collection(path)
                
        query.getDocuments { snap, error in
            
            if let _ = error {
                
            }else {
                
                if let querySnapshot = snap {
                    
                    return completionHandler(querySnapshot)
                }else {
                    showAlerOnTop(message: "Something went wrong!!")
                }
               
            }
           
        }
   }
    

   
   func getApproveAppointments(completionHandler:@escaping (QuerySnapshot) -> Void) {
       
       let query = db.collection("Users").document(UserDefaultsManager.shared.getDocumentId()).collection("ApproveAppointments")
               
       query.getDocuments { snap, error in
           
           if let _ = error {
               
           }else {
               
               if let querySnapshot = snap {
                   
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
          
       }
  }
   func updateProfile(documentid:String, userData: [String:String] ,completion: @escaping (Bool)->()) {
       let  query = db.collection("Users").document(documentid)
       
       query.updateData(userData) { error in
           if let error = error {
               print("Error updating Firestore data: \(error.localizedDescription)")
               // Handle the error
           } else {
               print("Profile data updated successfully")
               completion(true)
               // Handle the success
           }
       }
   }
   
   func changePassword(documentid:String, userData: [String:String] ,completion: @escaping (Bool)->()) {
       let  query = db.collection("Users").document(documentid)
       
       query.updateData(userData) { error in
           if let error = error {
               print("Error updating Firestore data: \(error.localizedDescription)")
               // Handle the error
           } else {
               print("Profile data updated successfully")
               completion(true)
               // Handle the success
           }
       }
   }

    func updateAppointmentOfPatient(email: String, documentid:String, data: AppointmentModel,updatedStatus: String, documentId: String, completion: @escaping (Bool)->()) {
       
        let data = ["patientId": data.patientId ?? "",
                    "pFirstname": data.pFirstname ?? "",
                    "pLastname": data.pLastname ?? "",
                    "pMiddlename": data.pMiddlename ?? "",
                    "doctorName": data.doctorName ?? "",
                    "hospitalName": data.hospitalName ?? "",
                    "medicalEmergency": data.medicalEmergency ?? "",
                    "date": data.date ?? "",
                    "time": data.time ?? "",
                    "medicalHistory": data.medicalHistory ?? "",
                    "status": updatedStatus ,
                    "doctorEmail": data.doctorEmail ?? "",
                    "patientEmail": data.patientEmail ?? "",
                    "bookingDate": data.bookingDate ?? 0.0,
                    "documentId": data.documentId ?? ""] as [String : Any]
       
       
       let documentReference = self.dbRef.document(UserDefaultsManager.shared.getDocumentId()).collection("Appoinments").document(documentId ?? "")
       
       documentReference.delete { error in
           if let error = error {
               print("Error deleting document: \(error.localizedDescription)")
           } else {
               if updatedStatus != "Rejected"{
                   let path = self.dbRef.document(UserDefaultsManager.shared.getDocumentId()).collection("ApproveAppointments")
                   path.addDocument(data: data) { error in
                       if let error = error {
                           // Handle the error here
                           print("Error adding document: \(error.localizedDescription)")
                       } else {
                           // Document added successfully
                           completion(true)
                       }
                   }
               } else {
                   completion(true)
               }
           }
       }
   }
   
   func updateHospitalProfile(userData: [String:Any] ,completion: @escaping (Bool)->()) {
       let db = db.collection("Hospital")
       db.whereField("hospitalName", isEqualTo: "Elevate Holistics Medical Marijuana Doctors").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("err")
                   // Some error occured
               } else if querySnapshot!.documents.count != 1 {
                   showAlerOnTop(message: "Error in addition")
               } else {
                   
                   let document = querySnapshot!.documents.first
                   document?.reference.updateData([
                       "doctorList": FieldValue.arrayUnion([userData])
                   ])
                   completion(true)
               }
           }
       
   }
    
   func sendEmail(emailTo:String, body:String, completion: @escaping (Bool) -> Void) {
           
           let myAppPassword = "cwvpwhcwcvyucagx"
               let url = URL(string: "https://us-central1-booking-app-629cf.cloudfunctions.net/sendEmail")!
               let data = [
                   "subject": "Here Is your login Password For Online Diagnosis",
                   "loginMail": "nagaakhilch@gmail.com",
                   "emailFrom": "nagaakhilch@gmail.com",
                   "emailTo": emailTo,
                   "appPassword": myAppPassword,
                   "body":  body
               ]
               let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.httpBody = jsonData
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")

               let session = URLSession.shared
               let task = session.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Error sending email: \(error.localizedDescription)")
                       completion(false)
                       return
                   }

                   guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                       print("Error sending email: Invalid response")
                       completion(false)
                       return
                   }

                   print("Email sent successfully")
                   completion(true)
               }

               task.resume()
           }
    
    func approvePatientAppointment(status: String, patientID: String, bookingDate: Double, email: String, data: AppointmentModel,completionHandler: @escaping (Bool)->()) {
        let data = ["patientId": data.patientId ?? "",
                    "pFirstname": data.pFirstname ?? "",
                    "pLastname": data.pLastname ?? "",
                    "pMiddlename": data.pMiddlename ?? "",
                    "doctorName": data.doctorName ?? "",
                    "hospitalName": data.hospitalName ?? "",
                    "medicalEmergency": data.medicalEmergency ?? "",
                    "date": data.date ?? "",
                    "time": data.time ?? "",
                    "medicalHistory": data.medicalHistory ?? "",
                    "status": status,
                    "doctorEmail": data.doctorEmail ?? "",
                    "patientEmail": data.patientEmail ?? "",
                    "bookingDate": data.bookingDate ?? 0.0,
                    "documentId": data.documentId ?? ""] as [String : Any]
        
        let path = self.dbRef.document(patientID).collection("Appoinments").whereField("bookingDate", isEqualTo: bookingDate)
        
        path.getDocuments { querySnapshot, err in
                for document in querySnapshot!.documents {
                    print("doclogin = \(document.documentID)")
                    let appointmentdocumentID = document.documentID
                    
                    let path = self.dbRef.document(patientID).collection("Appoinments").document(appointmentdocumentID)
                    path.updateData(data) { success in
                            completionHandler(true)
                    }
            }
        }
    }
}
