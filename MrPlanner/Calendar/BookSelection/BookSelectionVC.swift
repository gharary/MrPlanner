//
//  BookSelectionVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD
import SwiftyJSON
import RealmSwift
import JZCalendarWeekView
import Foundation

private let reuseIdentifier = "BookCell"

class BookSelectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0

    var weekDuration:Int = 0
    
    static var sharedInstance = BookSelectionVC()
    
    static var selectedData = [UserTimeTable]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
    let defaults = UserDefaults.standard
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Book Selection!"
        loadShelfBooks()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func getSelectedTime(_ time:JZBaseEvent, add: Bool = true) {
        switch add {
        case true:
            let isDuplicate = BookSelectionVC.selectedData.filter{ $0.selectedTime == time }
            if isDuplicate.isEmpty { BookSelectionVC.selectedData.append(UserTimeTable(selectedTime: time)) }
        case false:
            if let index = BookSelectionVC.selectedData.firstIndex(where: { $0.selectedTime == time }) {
            
                BookSelectionVC.selectedData.remove(at: index)
            }
            
            break
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 5
    }
    
    @IBAction func NextBtnTapped(_ sender: UIBarButtonItem) {
        getBookIDs(selectedBooks)
        getWeekTimes(BookSelectionVC.selectedData)
        submitToServer()
        
    }
    
    
    private func submitToServer() {
        
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
                        
                    } else {
                        print(response.error?.localizedDescription as Any)
                        
                    }
                    break
                case .failure(let error):
                    print(error)
                    
                }
        }
        
    }
    
    
    private var lessonData: [[String: Any]] = [[:]]
    
    private func getBookIDs(_ books: [String]) -> () {
        let realm = try! Realm()
        
        let shelve = realm.objects(Shelve.self).filter("GoogleID IN %@", books.self)
        
        var bookIDs = [String]()
        lessonData.removeAll()
        for i in 0..<shelve.count {
            bookIDs.append(shelve[i].InternalID!)
            let lessonSample = ["id":"\(shelve[i].InternalID!)","chapters":[["pages":"1-\(String(describing: shelve[i].Book!.pageCount.value!))"]]] as [String : Any]
            lessonData.append(lessonSample)
            
        }
    }
    
    
    func toJSonString(data : Any) -> String {
        
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
    
    private var weekJson :[[String:Any]] = []
    
    
    var startDate = Date()
    var endDate = Date()
    
    private func getWeekTimes(_ hours: [UserTimeTable]) -> Void {
        
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
                let sameDays = BookSelectionVC.selectedData.filter {
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
    
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    
    var books: Results<Books>?
    var selectedBooks = [String]()
    
    func loadShelfBooks() {
        
        let realm = try! Realm()
        books = realm.objects(Books.self)
        
        
        //SVProgressHUD.showProgress(0.3)
        GoodreadsService.sharedInstance.loadBooks(sender: self) {
            (books)  in
            //self.books = books
            SVProgressHUD.showProgress(0.6)
            self.collectionView.reloadData()
            SVProgressHUD.showProgress(1)
            SVProgressHUD.dismiss()
            //print(books)
        }
        SVProgressHUD.dismiss(withDelay: 0.3)
    }
    
}

extension BookSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return books?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell

        if let book = books?[indexPath.row] {
            cell.titleLbl.text = book.title
            cell.authorLbl.text = book.authors.first
            cell.checkMarkView.style = .grayedOut
            cell.checkMarkView.setNeedsDisplay()
            if !book.image!.isEmpty {
            
                let url:URL! = URL(string: book.image!)
                cell.bookImage.kf.indicatorType = .activity
                cell.bookImage.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
   
        let bookID = books?[indexPath.row].id
        
        if !cell.checkMarkView.checked {
            selectedBooks.append(bookID ?? "")
            cell.checkMarkView.checked = !cell.checkMarkView.checked
        } else {
            selectedBooks.removeAll(where: {$0 == bookID })
            
            cell.checkMarkView.checked = !cell.checkMarkView.checked
        }
        
        
        
        
        
    }



}

extension BookSelectionVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        //let height = Int(collectionView.frame.height / columns)
        
        //let height = 138 - width + (inset + spacing))
        return CGSize(width: width, height: width * 2)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
}
extension BookSelectionVC: UISearchResultsUpdating {
    
    
    func searchBarIsEmpty() -> Bool {
        return (searchController.searchBar.text?.isEmpty)!
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil {
            //reqSearchServer(term: searchText)
        } else {
            
        }
    }
    
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}

