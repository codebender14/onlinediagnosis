

import Foundation

struct hospitalArray: Codable{
    let doctorList: [doctorDetail]
    let hospitalName: String?
    let latitude: String?
    let longitude: String?
}

struct doctorDetail: Codable{
    let name: String?
    let specialist: String?
    let age: String?
    let dob: String?
    let expert: String?
    let gender: String?
    let rating: String?

}

class AppointmentModel {
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

    init(patientId: String?,
         pFirstname: String?,
         pLastname: String?,
         pMiddlename: String?,
         doctorName: String?,
         hospitalName: String?,
         medicalEmergency: String?,
         date: String?,
         time: String?,
         medicalHistory: Bool?,
         status: String?) {
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
}


