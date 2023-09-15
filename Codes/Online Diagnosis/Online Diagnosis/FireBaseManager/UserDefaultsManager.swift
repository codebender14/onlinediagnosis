 
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
    
    func getDepartment()-> String {
       return UserDefaults.standard.string(forKey: "department") ?? ""
    }
    
    func getUserType()-> String {
       return UserDefaults.standard.string(forKey: "userType") ?? ""
    }
    
    
    func saveData(name:String,email:String) {
        
        UserDefaults.standard.setValue(name, forKey: "firstName")
        UserDefaults.standard.setValue(email, forKey: "email")
    }
  
    
}
