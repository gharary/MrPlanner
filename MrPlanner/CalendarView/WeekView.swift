//
//  WeekView.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/25/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class WeekView: JZBaseWeekView {
    
    var selectedTime = [JZBaseEvent]()
    
    override func registerViewClasses() {
        super.registerViewClasses()
        self.collectionView.register(UINib(nibName: EventNewCell.className, bundle: nil), forCellWithReuseIdentifier: EventNewCell.className)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventNewCell.className, for: indexPath) as! EventNewCell
        
        cell.configureCell(event: getCurrentEvent(with: indexPath) as! DefaultEvent)
        /*
        let event = getCurrentEvent(with: indexPath)
        if selectedTime.firstIndex(of: event!) != nil {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = UIColor(hex: 0xEEF7FF)
        }
        */
        return cell
    }
    
    
}
