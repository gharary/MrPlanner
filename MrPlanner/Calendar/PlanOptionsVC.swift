//
//  PlanOptionsVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/6/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class PlanOptionsVC: UIViewController {

    @IBOutlet weak var wakeupDatePicker: UIDatePicker!
    @IBOutlet weak var sleepDatePicker: UIDatePicker!
    @IBOutlet weak var planDurationWeek: UIPickerView!
    
    var weekDuration:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planDurationWeek.delegate = self
        planDurationWeek.dataSource = self
        
        
        setupPicker()
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalendar" {
            let vc = segue.destination as! DefaultViewController
                
                vc.wakeupTime = wakeupDatePicker.date
                vc.sleepTime = sleepDatePicker.date
                vc.weekduration = weekDuration
                
            
        }
    }
    
    
    

    
}





extension PlanOptionsVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weekDuration = row
    }
    
    func setupPicker() {
        //ToolBar
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        //txtDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        //txtDatePicker.inputView = datePicker
        
        
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
