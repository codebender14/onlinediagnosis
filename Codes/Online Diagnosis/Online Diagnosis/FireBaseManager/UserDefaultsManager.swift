 
import Foundation

class UserDefaultsManager  {
    
    static  let shared =  UserDefaultsManager()
    
    func clearUserDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()

            dictionary.keys.forEach
            {
                key in   defaults.removeObject(forKey: key)
            }
    }
        
    
    func isLoggedIn() -> Bool{
        
        let email = getEmail()
        
        if(email.isEmpty) {
            return false
        }else {
           return true
        }
      
    }
     
    func getEmail()-> String {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        print(email)
       return email
    }
    
    func getName()-> String {
       return UserDefaults.standard.string(forKey: "firstName") ?? ""
    }
    
    func getMiddleName()-> String {
       return UserDefaults.standard.string(forKey: "middleName") ?? ""
    }
    
    func getLastName()-> String {
       return UserDefaults.standard.string(forKey: "lastName") ?? ""
    }
    
    func getUserType()-> String {
       return UserDefaults.standard.string(forKey: "userType") ?? ""
    }
    
    func getDocumentId()-> String {
       return UserDefaults.standard.string(forKey: "documentId") ?? ""
    }
    
    func saveData(name:String, middleName: String, lastname: String, email:String, userType: String) {
        
        UserDefaults.standard.setValue(name, forKey: "firstName")
        UserDefaults.standard.setValue(middleName, forKey: "middleName")
        UserDefaults.standard.setValue(lastname, forKey: "lastName")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(userType, forKey: "userType")
    }
  
    func clearData(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "middleName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "documentId")
    }
}
