

import Foundation

struct hospitalArray: Codable{
    let doctorList: [doctorDetail]
    let hospitalName: String?
    let latitude: String?
    let longitude: String?
}

struct doctorDetail: Codable{
    let firstName: String?
    let lastName: String?
    let middleName: String?
    let specialist: String?
    let age: String?
    let dob: String?
    let expert: String?
    let gender: String?
    let rating: String?
    let achievement : String?
    let awards : String?
    let email : String?
    let availableHours: [String]?

}

class AppointmentModel {
    let patientId: String?
    let pFirstname: String?
    let pLastname: String?
    let pMiddlename: String?
    let doctorName: String?
    let doctorEmail: String?
    let hospitalName: String?
    let medicalEmergency: String?
    let date: String?
    let time: String?
    let medicalHistory: Bool?
    let status: String?
    let patientEmail: String?
    let bookingDate: Double?
    let documentId: String?


    init(patientId: String?,
         pFirstname: String?,
         pLastname: String?,
         pMiddlename: String?,
         doctorName: String?,
         doctorEmail: String?,
         hospitalName: String?,
         medicalEmergency: String?,
         date: String?,
         time: String?,
         medicalHistory: Bool?,
         status: String?, patientEmail: String?, bookingDate: Double, documentId: String?) {
        self.patientId = patientId
        self.pFirstname = pFirstname
        self.pLastname = pLastname
        self.pMiddlename = pMiddlename
        self.doctorName = doctorName
        self.hospitalName = hospitalName
        self.medicalEmergency = medicalEmergency
        self.date = date
        self.time = time
        self.medicalHistory = medicalHistory
        self.status = status
        self.doctorEmail = doctorEmail
        self.patientEmail = patientEmail
        self.bookingDate = bookingDate
        self.documentId = documentId
    }
}

struct UserDataModel: Codable {
    let dob: String?
    let email: String?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let gender: String?
    let password: String?
    let userType: String?
    let specialist : String?
    let expert : String?
    let rating : String?
    let achievement : String?
    let awards : String?
    let availableHours : [String]?
    let AppointmentDetail : [AppointmentDetail]?
    let ApproveAppointmentDetail : [ApproveAppointmentDetail]?
}

struct AppointmentDetail: Codable {
    let patientId: String?
    let pFirstname: String?
    let pLastname: String?
    let pMiddlename: String?
    let doctorName: String?
    let hospitalName: String?
    let medicalEmergency: String?
    let date: String?
    let time: String?
    let medicalHistory: Bool?
    let status: String?
    let doctorEmail: String?
    let bookingDate: Double?
    let documentId: String?
    let patientEmail: String?
}

struct ApproveAppointmentDetail: Codable {
    let patientId: String?
    let pFirstname: String?
    let pLastname: String?
    let pMiddlename: String?
    let doctorName: String?
    let hospitalName: String?
    let medicalEmergency: String?
    let date: String?
    let time: String?
    let medicalHistory: Bool?
    let status: String?
    let doctorEmail: String?
    let bookingDate: Double?
    let documentId: String?
    let patientEmail: String?
}

struct MedicalDetail: Codable{
    var firstname: String?
    var middlename: String?
    var lastname: String?
    var email: String?
    var dob: String?
    var gender: String?
    var phoneNo: String?
    var address: String?
    var weight: String?
    var height: String?
    var medication: String?
    var medicalProblem: String?
    var patientId: String?
}




struct PrescriptionModel {
    var chatId: String
    var doctorName: String
    var doctorEmail: String
    var patientEmail: String
    var patientName: String
    var prescription: String
    var dateSent: Double
    
    init(data: [String: Any]) {
        self.chatId = data["chatId"] as? String ?? ""
        self.doctorName = data["doctorName"] as? String ?? ""
        self.doctorEmail = data["doctorEmail"] as? String ?? ""
        self.patientEmail = data["patientEmail"] as? String ?? ""
        self.prescription = data["prescription"] as? String ?? ""
        self.patientName = data["patientName"] as? String ?? ""
        self.dateSent = data["dateSent"] as? Double ?? 0.0
    }
  
    
    
       func getDate() -> Date {
           return Date(timeIntervalSince1970: dateSent)
       }
       
       func getDateAsString() -> String {
           let date = getDate()
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM d, yyyy"
           return formatter.string(from: date)
       }
       
       func getTimeAsString() -> String {
           let date = getDate()
           let formatter = DateFormatter()
           formatter.dateFormat = "h:mm a"
           return formatter.string(from: date)
       }
       
       func getDateString() -> String {
           return "\(getDateAsString()) at \(getTimeAsString())"
       }

  
}

