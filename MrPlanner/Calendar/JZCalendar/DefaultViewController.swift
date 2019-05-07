//
//  DefaultViewController.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 3/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultViewController: UIViewController {
    
    @IBOutlet weak var calendarWeekView: DefaultWeekView!
    
    let viewModel = DefaultViewModel()
    
    var planBeginDate:String = ""
    var weekduration: Int = 0
    
    
    var fullGridEvents = [DefaultEvent]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvents()
        setupBasic()
        setupCalendarView()
    }
    
    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }
    
    
    
    
    private func setupCalendarView() {
        
        calendarWeekView.baseDelegate = self
        
        // Basic setup
        let eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: fullGridEvents)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let beginDate = planBeginDate.isEmpty ? Date() : formatter.date(from: planBeginDate)
        let endDate = beginDate?.add(component: .weekOfMonth, value: weekduration)
        
        calendarWeekView.setupCalendar(numOfDays: 7,
                                       setDate: beginDate ?? Date(),
                                       allEvents: eventsByDate,
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       currentTimelineType: .page,
                                       visibleTime: Date()
                                       ,scrollableRange: (startDate: Date(), endDate: endDate))
        // Optional
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: JZHourGridDivision.noneDiv))
    }
    
}

extension DefaultViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNaviBarTitle()
    }
    
    func setupBasic() {
        // Add this to fix lower than iOS11 problems
        if #available(iOS 11, *) {
            return
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func updateNaviBarTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        self.navigationItem.title = dateFormatter.string(from: calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays))
    }
    
    func setupEvents() {
        fullGridEvents.removeAll()
        let calendar = Calendar.current
        let today = Date().add(component: .day, value: 1)
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let beginDate = planBeginDate.isEmpty ? Date() : formatter.date(from: planBeginDate)
        
        
        var nextFirstWeekday = DateComponents()
        nextFirstWeekday.weekday = calendar.firstWeekday
        //nextMonday.weekday = 3
        let startDate = calendar.nextDate(after: beginDate ?? today,
                                          matching: nextFirstWeekday,
                                          matchingPolicy: .nextTimePreservingSmallerComponents)
        
        
        
        let dateEnd = startDate?.add(component: .weekOfMonth, value: weekduration)
     
        for date in DateRange(calendar: Calendar.autoupdatingCurrent,
                              startDate: startDate!,
                              endDate: dateEnd,
                              component: .day,
                              step: 1)
            {
                                //print(date)
                fullGridEvents.append(contentsOf: generateDailyEvents(date))
                //fullGridEvents = generateDailyEvents(date)
        }
        
    }

    func generateDailyEvents(_ beginDate: Date=Date() ) -> [DefaultEvent] {
        
        // get the current date and time
        let currentDateTime = beginDate
        
        // get the user's calendar
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day,.hour, .minute,.second]
        
        let dateTimeC = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let dayBeginTime = formatter.date(from: "\(dateTimeC.year!)/\(dateTimeC.month!)/\(dateTimeC.day!) 00:00")

        
        var fullGridEvents = [DefaultEvent]()
        for i in 0..<24 {
            
            fullGridEvents.append(DefaultEvent(id: "\(i)", title: "", startDate: dayBeginTime!.add(component: .hour, value: i), endDate: (dayBeginTime?.add(component: .hour, value: i+1))!, location: ""))
        }
        
        return fullGridEvents
        
    }
}
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
    
    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

