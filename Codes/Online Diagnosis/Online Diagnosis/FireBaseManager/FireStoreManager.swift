 
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
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        dbRef = db.collection("Users")
       
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
                            let email = document.data()["email"] as? String ?? ""
                            let userType = document.data()["userType"] as? String ?? ""
                            
                            UserDefaultsManager.shared.saveData(name: name, email: email, userType: userType)
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
    
    func addNewAppointmentDetail(email: String, data: AppointmentModel,completion: @escaping (Bool)->()) {
        self.dbRef.whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("err")
                    // Some error occured
                } else if querySnapshot!.documents.count != 1 {
                    showAlerOnTop(message: "Error in addition")
                } else {

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
                                 "status": data.status ?? ""] as [String : Any]
                    
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "AppointmentDetail": FieldValue.arrayUnion([data])
                    ])
                    
                    completion(true)
                }
            }
        
    }
    
    func addNewAppointmentDetailForDoctor(email: String, data: AppointmentModel,completion: @escaping (Bool)->()) {
        self.dbRef.whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("err")
                    // Some error occured
                } else if querySnapshot!.documents.count != 1 {
                    showAlerOnTop(message: "Error in addition")
                } else {

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
                                 "status": data.status ?? ""] as [String : Any]
                    
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "AppointmentDetail": FieldValue.arrayUnion([data])
                    ])
                   
                    completion(true)
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

    func updateAppointmentOfPatient(email: String, documentid:String, userData: [String:Any],patientId: String?, pFirstname: String?,pLastname: String?,pMiddlename: String?, doctorName: String?,doctorEmail: String?, hospitalName: String?, medicalEmergency: String?, date: String?,time: String?,medicalHistory: Bool?,status: String?, updatedStatus: String, completion: @escaping (Bool)->()) {
        
        let dbre = db.collection("Users")

        dbre.whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("err")
                    // Some error occured
                } else if querySnapshot!.documents.count != 1 {
                    showAlerOnTop(message: "Error in addition")
                } else {
                    
                    let userOlddata = ["patientId": patientId ?? "", "pFirstname": pFirstname ?? "", "pLastname": pLastname ?? "", "pMiddlename": pMiddlename ?? "", "doctorName": doctorName ?? "", "hospitalName": hospitalName ?? "", "medicalEmergency": medicalEmergency ?? "", "date": date ?? "", "time": time ?? "", "medicalHistory": true, "status": "Pending"] as [String : Any]

                    
                                let document = querySnapshot!.documents.first
                                document?.reference.updateData([
                                    "AppointmentDetail": FieldValue.arrayRemove([userOlddata])
                                ])
                    
                    let userdata2 = ["patientId": patientId ?? "", "pFirstname": pFirstname ?? "", "pLastname": pLastname ?? "", "pMiddlename": pMiddlename ?? "", "doctorName": doctorName ?? "", "hospitalName": hospitalName ?? "", "medicalEmergency": medicalEmergency ?? "", "date": date ?? "", "time": time ?? "", "medicalHistory": true, "status": updatedStatus] as [String : Any]

                    if updatedStatus == "Accepted"{
                        document?.reference.updateData([
                            "ApproveAppointmentDetail": FieldValue.arrayUnion([userdata2])
                        ])
                    }
                                completion(true)
                            }
            }
    }

    
    func updateAppointmentArrayValuesByKeys(documentID: String, arrayField: String, indexToUpdate: Int, newValue: Any, completion: @escaping (Bool)->()) {
        // Step 1: Retrieve the document
        dbRef.document(documentID).getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            // Step 2: Modify the array element locally
            if var array = document.data()?[arrayField] as? [Any], indexToUpdate >= 0 && indexToUpdate < array.count {
                array[indexToUpdate] = newValue
                
                // Step 3: Update the Firestore document with the modified array
                var updatedData = [String: Any]()
                updatedData[arrayField] = array
                self.dbRef.document(documentID).setData(updatedData, merge: true) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        completion(true)
                        print("Document updated successfully")
                    }
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
}
