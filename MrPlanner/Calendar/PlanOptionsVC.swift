//
//  PlanOptionsVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/6/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class PlanOptionsVC: UIViewController {

    
    @IBOutlet weak var planDurationWeek: UIPickerView!
    @IBOutlet weak var dateBeginTF: UITextField!
    
    
    var weekDuration:Int = 0
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateBeginTF.becomeFirstResponder()
        planDurationWeek.delegate = self
        planDurationWeek.dataSource = self
        
        
        setupPicker()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalendar" {
            let vc = segue.destination as! DefaultViewController
            
            vc.planBeginDate = dateBeginTF.text!.isEmpty ? "" : dateBeginTF!.text!
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: String(row), attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "546379")!])
        return attributedString
    }
    
    
    
    
    func setupPicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dateBeginTF.inputAccessoryView = toolbar
                
        // add datepicker to textField
        dateBeginTF.inputView = datePicker
        
        
       
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateBeginTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func TextFieldEditingBegin(_ sender: UITextField) {
        
        datePicker.datePickerMode = .date
        
        
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        
        let date = dateFormatter.string(from: sender.date)
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateBeginTF.text = date
    }
}
