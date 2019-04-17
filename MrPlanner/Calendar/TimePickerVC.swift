//
//  TimePickerVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 4/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class TimePickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var weakLabel: UILabel!
    
    
    let columns: CGFloat = 7
    let inset: CGFloat = 0.0
    let spacing: CGFloat = 8.0
    let lineSpacing:CGFloat = 8.0
    
    var timeArray: [Int] = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard timeCounts > 0 else { return 126 }
        return timeCounts
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! TimePickerCell
        
        
        if selectedCell.contains(indexPath) {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .darkGray
        }
        if timeArray.count > 0 {
            cell.time.text = "\(timeArray[indexPath.row])"
        }
        
        cell.layer.cornerRadius = 5
        return cell
        
    }
    
    var selectedCell: [IndexPath] = []
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimePickerCell
        cell.toggleSelected()
        selectedCell.append(indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimePickerCell
        cell.toggleSelected()
        selectedCell.removeAll{$0 == indexPath}
        
    }
    
    
    
    

    
    
    @IBOutlet weak var wakeUpPicker:UIDatePicker!
    @IBOutlet weak var sleepPicker:UIDatePicker!
    @IBOutlet weak var timeCollection: UICollectionView!
    
    
    let dateFormatter = DateFormatter()
    var timeCounts: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        self.timeCollection.allowsMultipleSelection  = true
        
        for i in 6..<24 {
            timeArray.append(contentsOf: Array(repeating: i, count: 7))
        }
        
        self.timeCollection.layer.cornerRadius = 15
        self.timeCollection.layer.borderColor = UIColor.white.cgColor
        self.timeCollection.layer.borderWidth = 2
        self.timeCollection.backgroundColor = .lightGray
        
        // Do any additional setup after loading the view.
    }


    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        guard wakeUpPicker.date <= sleepPicker.date else { return }
        dateFormatter.dateFormat = "hh:mm"
        let difference = Calendar.current.dateComponents([.hour, .minute], from: wakeUpPicker.date, to: sleepPicker.date)
        timeCounts = ((difference.hour! + 1) * 7)
        
        let time1 = Calendar.current.dateComponents([.hour, .minute], from: wakeUpPicker!.date)
        let time2 = Calendar.current.dateComponents([.hour, .minute], from: sleepPicker!.date)
        
        var i:Int = time1.hour!
        timeArray = []
        while i <= time2.hour! {
            for _ in 1..<8 {
                timeArray.append(i)
            }
            i += 1
        }
        timeCollection.reloadData()
        
        
        
    }
    


}


extension TimePickerVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        
        //let testWidth = weakLabel.widthAnchor.
        return CGSize(width: width, height: width)
        
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
