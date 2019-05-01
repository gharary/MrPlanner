//
//  DefaultWeekView.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 4/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultWeekView: JZBaseWeekView {
    
    
    
    var selectedTime = [JZBaseEvent]()
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(UINib(nibName: EventCell.className, bundle: nil), forCellWithReuseIdentifier: EventCell.className)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as! EventCell
        
        let event = getCurrentEvent(with: indexPath)
        if selectedTime.firstIndex(of: event!) != nil {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .clear//UIColor(hex: 0xEEF7FF)
        }
        
        return cell
 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let selectedEvent = getCurrentEvent(with: indexPath) as! DefaultEvent
        //ToastUtil.toastMessageInTheMiddle(message: selectedEvent.title)
        
        
        let cell = self.collectionView.cellForItem(at: indexPath)
        if cell?.backgroundColor == UIColor.red {
            cell?.backgroundColor =  UIColor(hex: 0xEEF7FF)
            let event = getCurrentEvent(with: indexPath)
            selectedTime.remove(at: selectedTime.firstIndex(of: event!)!)
            
        }
        else {
            cell?.backgroundColor = .red
            let event = getCurrentEvent(with: indexPath)
            selectedTime.append(event!)
            
        }
        
    }

}
