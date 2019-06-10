//
//  DefaultWeekView.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 4/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView
import RealmSwift
class DefaultWeekView: JZBaseWeekView {
    
    var selectedData = [UserTimeTable]()
    
    
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(UINib(nibName: EventCell.className, bundle: nil), forCellWithReuseIdentifier: EventCell.className)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as! EventCell
        
        let event = getCurrentEvent(with: indexPath)
        guard selectedData.firstIndex(where: { $0.selectedTime == event }) != nil else {
            
            cell.backgroundColor = UIColor(hex: 0xEEF7FF)
            return cell
        }
        
        cell.backgroundColor = .green
        
        return cell
 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath)
        if cell?.backgroundColor == UIColor.green {
            cell?.backgroundColor =  UIColor(hex: 0xEEF7FF)
            let event = getCurrentEvent(with: indexPath)!
            BookSelectionVC.sharedInstance.getSelectedTime(event, add: false)
            
            
        }
        else {
            cell?.backgroundColor = .green
            let event = getCurrentEvent(with: indexPath)!
            //selectedData.append(UserTimeTable(selectedTime: event))
            BookSelectionVC.sharedInstance.getSelectedTime(event, add: true)
            
        }
    }
    
    
    
    
    

}
