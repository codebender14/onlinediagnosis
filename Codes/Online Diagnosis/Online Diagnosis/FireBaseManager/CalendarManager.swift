import EventKit

class CalendarManager {
    
    static let shared = CalendarManager()
    
    private let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            completion(granted, error)
        }
    }
    
    func createEvent(title: String, date: String, fromTo: String) {
        let eventStore = EKEventStore()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let startDate = dateFormatter.date(from: date) else {
            print("Invalid date format")
            return
        }
        
        let timeStrings = fromTo.components(separatedBy: " - ")
        guard timeStrings.count == 2 else {
            print("Invalid time format")
            return
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        guard let startTime = timeFormatter.date(from: timeStrings[0]),
              let endTime = timeFormatter.date(from: timeStrings[1]) else {
            print("Invalid time format")
            return
        }
        
        let calendar = Calendar.current
        let startDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: startTime), minute: calendar.component(.minute, from: startTime), second: 0, of: startDate)!
        let endDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: endTime), minute: calendar.component(.minute, from: endTime), second: 0, of: startDate)!
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDateTime
        event.endDate = endDateTime
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event saved to calendar")
        } catch let error {
            print("Error saving event to calendar: \(error.localizedDescription)")
        }
    }
}
