//
//  ProgramService.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 7/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import OAuthSwift
import RealmSwift
import JZCalendarWeekView

class ProgramService {
    
    enum packageState: String {
        case Available
        case NotAvailable
        case Finished
    }
    
    static var sharedInstance = ProgramService()
    
    static var selectedData = [UserTimeTable]()
    
    let defaults = UserDefaults.standard

    
    // Books Data

    func getBookIDs(_ books: [String]) -> ([[String:Any]]) {
        let realm = try! Realm()
        var lessonData: [[String: Any]] = [[:]]
        
        let shelve = realm.objects(Shelve.self).filter("GoogleID IN %@ OR GoodreadsID IN %@", books.self, books.self)
        
        var bookIDs = [String]()
        lessonData.removeAll()
        for i in 0..<shelve.count {
            bookIDs.append(shelve[i].InternalID!)
            let lessonSample = ["id":"\(shelve[i].InternalID!)","chapters":[["pages":"1-\(String(describing: shelve[i].Book!.pageCount.value!))"]]] as [String : Any]
            lessonData.append(lessonSample)
            
        }
        return lessonData
        
    }
    
    //Get and Save Data
    func getSelectedTime(_ time:JZBaseEvent, add: Bool = true) {
        switch add {
        case true:
            let isDuplicate = ProgramService.selectedData.filter{ $0.selectedTime == time }
            if isDuplicate.isEmpty { ProgramService.selectedData.append(UserTimeTable(selectedTime: time)) }
        case false:
            if let index = ProgramService.selectedData.firstIndex(where: { $0.selectedTime == time }) {
                
                ProgramService.selectedData.remove(at: index)
            }
            
            break
        }
        
    }
    
    //update Date begin and Date End
    
    func setDates(_ dateBegin:String, weekduration:Int) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        startDate = dateBegin.isEmpty ? Date() : formatter.date(from: dateBegin)!
        endDate = startDate.add(component: .weekOfMonth, value: weekduration)
        
        
    }
    // Week Process Data
    private var weekJson :[[String:Any]] = []
    var startDate = Date()
    var endDate = Date()
    var weekDuration : Int = 0
    
    func getWeekTimes(_ hours: [UserTimeTable]) -> Void {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateComponents : Set<Calendar.Component> = [.year,.month,.day]
        
        var w = 0
        var d = 0
        
        //each week
        for weeks in DateRange(calendar: Calendar.autoupdatingCurrent, startDate: startDate.add(component: .weekOfYear, value: -1), endDate: endDate, component: .weekOfYear, step: 1) {
            
            var dayJson:[[String:Any]] = []
            
            dayJson.removeAll()
            d = 0
            //each day events
            for days in DateRange(calendar: Calendar.autoupdatingCurrent, startDate: weeks.startOfDay, endDate: weeks.startOfDay.add(component: .day, value: 7), component: .day, step: 1) {
                
                let dateFirst = Calendar.autoupdatingCurrent.dateComponents(dateComponents, from: days)
                let sameDays = ProgramService.selectedData.filter {
                    let date =  Calendar.autoupdatingCurrent.dateComponents(dateComponents, from: $0.selectedTime.startDate)
                    return date.day == dateFirst.day
                }
                
                let date = "\(dateFirst.month!)-\(dateFirst.day!)-\(dateFirst.year!)"
                
                guard !sameDays.isEmpty else {
                    
                    let daySample = ["day": "\(d)", "date":date ,"hours":[]] as [String : Any]
                    dayJson.append(daySample)
                    d += 1
                    continue
                }
                
                let sameHourDict = calculateDailyHours(sameDays)
                
                let daySample = ["day": "\(d)", "date":"\(date)","hours":sameHourDict] as [String : Any]
                dayJson.append(daySample)
                d += 1
            }
            let weekSample = ["week":"\(w)", "days":dayJson] as [String : Any]
            weekJson.append(weekSample)
            w += 1
        }
    }
    
    
    func calculateDailyHours(_ dailyHours:[UserTimeTable]) -> [[String:Any]] {
        
        var sameHourArr : [[String:Any]] = []
        
        let dailyComponents: Set<Calendar.Component> = [.hour, .minute,.second]
        let userCalendar = Calendar.current
        
        for day in dailyHours {
            let temp = userCalendar.dateComponents(dailyComponents, from: day.selectedTime.startDate)
            
            sameHourArr.append(["hour":"\(temp.hour!)"])
        }
        
        return sameHourArr
    }
    
    func sendDataToServer(selectedBooks: [String], startDate:Date, endDate:Date, weekDuration:Int, completion: @escaping () -> ()) {
        
        let lessonData = getBookIDs(selectedBooks)
        getWeekTimes(ProgramService.selectedData)
        
        submitToServer(lessonData)
        
        
    }
    
    func checkPackageAvailable(completion: @escaping (Bool) -> ()) {
        let user = defaults.string(forKey: "username") ?? Bundle.main.localizedString(forKey: "testUserEmail", value: nil, table: "Secrets")
        
        let password = defaults.string(forKey: "password") ?? Bundle.main.localizedString(forKey: "testUserPass", value: nil, table: "Secrets")
        
        //let userID = defaults.string(forKey: "UserID") ?? "2"
        
        let url = URL(string: "http://www.mrplanner.org/api/packages")
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let base64Credential = credentialData.base64EncodedString()
        
        let header: HTTPHeaders = ["X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
                                   "Content-Type" : "application/json",
                                   "Authorization":"Basic \(base64Credential)"]
        
        
        Alamofire.request(url!, method: .get, headers: header).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let statusCode = response.response?.statusCode
                    if statusCode! >= 200 && statusCode! <= 300 {
                        let json = JSON(value)
                        let item = json["data",0,"number_programs"].intValue
                        if item > 0 { completion(true) }
                        
                    } else {
                        print(response.error?.localizedDescription as Any)
                        completion(false)
                    }
                    break
                case .failure(let error):
                    completion(false)
                    print(error)
                    
                }
        }
        
        
    
        
        
    }
    
    
    private func submitToServer(_ lessonData:[[String:Any]]) {
        
        let user = defaults.string(forKey: "username") ?? Bundle.main.localizedString(forKey: "testUserEmail", value: nil, table: "Secrets")
        
        let password = defaults.string(forKey: "password") ?? Bundle.main.localizedString(forKey: "testUserPass", value: nil, table: "Secrets")
        
        let userID = defaults.string(forKey: "UserID") ?? "2"
        
        let url = URL(string: "http://www.mrplanner.org/api/createProgram")
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let base64Credential = credentialData.base64EncodedString()
        
        let header: HTTPHeaders = ["X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
                                   "Content-Type" : "application/json",
                                   "Authorization":"Basic \(base64Credential)"]
        
        
        let parameter: Parameters = ["user_id":userID,
                                     "lessons": lessonData,
                                     "weeks": weekJson
            
        ]
        Alamofire.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let statusCode = response.response?.statusCode
                    if statusCode! >= 200 && statusCode! <= 300 {
                        let json = JSON(value)
                        print("json result is:\(json)")
                        self.parseJSON(json)
                    } else {
                        print(response.error?.localizedDescription as Any)
                        
                    }
                    break
                case .failure(let error):
                    print(error)
                    
                }
        }
        
    }
    
    var realDataEvents = [DefaultEvent]()
    
    private func parseJSON(_ json:JSON) {
        realDataEvents = proceedProgramData(json["data"])
        if let data = try? json.rawData() {
            let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentUrl,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                
                for fileURL in fileURLs {
                    if fileURL.pathExtension == "json" {
                        try FileManager.default.removeItem(at: fileURL)
                    }
                }
                
            } catch(let error) {
                print(error)
            }
            
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("response.json")
            
            try? data.write(to: fileUrl)
        }
        
        
    }
    
    
    func geteventsData(completion: @escaping ([DefaultEvent]) -> ()) {
        
        
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("response.json")
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            let filePath    = Bundle.main.path(forResource: "response", ofType: "json")!
            let fileURL        = URL(fileURLWithPath: filePath)
            let fileData    = try! Data(contentsOf: fileURL)
        
            let json = JSON(fileData)
            realDataEvents = proceedProgramData(json["data"])
        
            completion(realDataEvents)
            return
        }
        let json = try! JSON(data: data)
        realDataEvents = proceedProgramData(json["data"])
        
        completion(realDataEvents)

    }
    
    
    func proceedProgramData(_ json: JSON) -> ([DefaultEvent]) {
        
        var events = [DefaultEvent]()
        
        let formatter = DateFormatter()
        //let dateComponents : Set<Calendar.Component> = [.year,.month,.day]
        formatter.dateFormat = "M-dd-yyyy H"
        
        for (_,subJson):(String, JSON) in json {
            // Do something you want
            //each week
            print("Week Data is: \(subJson)")
            
            for (_,subJson):(String, JSON) in subJson["days"] {
                //each day
                print("Daily Data is: \(subJson)")
                let dateDay = subJson["date"].string!
                
                for (_,subJson):(String,JSON) in subJson["hours"] {
                    //each Hour
                    print("Hour Data is: \(subJson)")
                    //let dateCom = Calendar.autoupdatingCurrent.dateComponents(dateComponents, from: dateDay)
                    
                    let date = formatter.date(from: "\(dateDay) \(subJson["hour"].string!)")
                    
                    let id: [JSONSubscriptType] = ["lesson",0,"id"]
                    let event =  DefaultEvent(id: subJson[id].string ?? "",
                                              title: subJson["lesson",0,"name"].stringValue ,
                                              startDate: date!,
                                              endDate: (date?.add(component: .hour, value: 1))!,
                                              page: subJson["lesson",0,"pageForReading"].stringValue)
                    events.append(event)
                    
                    
                }
            }
            
        }
            //CalendarViewVC.sharedInstance.saveData(events)
            
        return events
    }
}
