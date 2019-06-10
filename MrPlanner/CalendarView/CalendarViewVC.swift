//
//  CalendarViewVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/24/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import JZCalendarWeekView
import SVProgressHUD
class CalendarViewVC: UIViewController {
    
    @IBOutlet weak var calendarWeekView: WeekView!
    
    var events = [DefaultEvent]()
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.setupEvents()
            self.view.layoutIfNeeded()
        }
        
        setupBasic()
        setupCalendar()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }
    
    private func setupCalendar() {
        calendarWeekView.baseDelegate = self
        
        //Basic Setup
        let eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
        
        calendarWeekView.setupCalendar(numOfDays: 7,
                                       setDate: Date(),
                                       allEvents: eventsByDate,
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Monday,
                                       currentTimelineType: .page,
                                       visibleTime: Date(),
                                       scrollableRange: (startDate: Date(), endDate: Date().add(component: .month, value: 1)))
        //Optional
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: JZHourGridDivision.noneDiv))
        
        
        
    }
    
    
    @IBAction func todayBtnTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarWeekView.updateWeekView(to: Date())
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    
}

extension CalendarViewVC: JZBaseViewDelegate {
    
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
        events.removeAll()
        
        for date in DateRange(calendar: .autoupdatingCurrent,
                              startDate: Date(),//.add(component: .weekOfYear, value: -1),
                              endDate: Date().add(component: .day, value: 10),
                              component: .day,
                              step: 1) {
                                events.append(contentsOf: genEvents(date))
        }
        
        
        UIView.transition(with: self.calendarWeekView, duration: 0.33, options: [], animations: {
            self.calendarWeekView.refreshWeekView()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func genEvents(_ beginDate: Date = Date()) -> [DefaultEvent] {
        
        
        var fullGridEvents = [DefaultEvent]()
        for i in 0..<5 {
            let startDate = beginDate.add(component: .hour, value: i)
            
            fullGridEvents.append(DefaultEvent(id: "\(i)", title: "Traction", startDate: startDate, endDate: startDate.add(component: .hour, value: 1), page: "\(i)-\(i+10)"))
            
        }
        
        
        
        return fullGridEvents
    }
    
}
