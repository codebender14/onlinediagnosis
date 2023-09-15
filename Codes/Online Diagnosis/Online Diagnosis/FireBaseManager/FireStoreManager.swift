 
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
                            UserDefaultsManager.shared.saveData(name: name, email: email)
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
        
        dbRef.addDocument(data: data) { err in
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

}
