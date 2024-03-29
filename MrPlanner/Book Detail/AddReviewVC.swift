//
//  AddReviewVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/28/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD

class AddReviewVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var reviewDesc: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewRating: CosmosView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        // Do any additional setup after loading the view.
    }
    

    private func initViews() {
        //init Submit Button
        submitBtn.titleLabel?.text = "Submit review"
        submitBtn.tintColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.widthAnchor.constraint(equalToConstant: 339).isActive = true
        submitBtn.heightAnchor.constraint(equalToConstant: 47).isActive = true
        submitBtn.clipsToBounds = true
        submitBtn.layer.cornerRadius = 24
        submitBtn.layer.borderColor = UIColor(red: 0.11, green: 0.82, blue: 0.63, alpha: 1).cgColor
        submitBtn.backgroundColor = UIColor(red: 0.11, green: 0.82, blue: 0.63, alpha: 1)
        submitBtn.layer.borderWidth = 1
        submitBtn.alpha = 1
        
        // Text style for "Submit review"
        //style.font = UIFont(name: "SFProText-Medium", size: 13)
        //style.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        
        
        //init description text
        reviewDesc.translatesAutoresizingMaskIntoConstraints = false
        reviewDesc.widthAnchor.constraint(equalToConstant: 339).isActive = true
        reviewDesc.heightAnchor.constraint(equalToConstant: 205).isActive = true
        reviewDesc.clipsToBounds = true
        reviewDesc.layer.cornerRadius = 10
        reviewDesc.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        reviewDesc.alpha = 1
        reviewDesc.delegate = self
        reviewDesc.text = "Your Review Description Here!"
        reviewDesc.textAlignment = .center
        reviewDesc.textColor = .lightGray
        
        //init label2
        label2.backgroundColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
        label2.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        label2.clipsToBounds = true
        label2.layer.cornerRadius = 5
        /*
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.widthAnchor.constraint(equalToConstant: 234).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 13).isActive = true
        label2.clipsToBounds = true
        
        label2.alpha = 1
        label2.text = "Your review pending for accept by moderator"
        label2.font = UIFont(name: "SFProText-Light", size: 11)
        
        */
        
        reviewRating.rating = 0
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.textAlignment = .left
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Review Description Here!"
            textView.textAlignment = .center
            textView.textColor = .lightGray
            
        }
    }
    @IBAction func SubmitClicked(_ sender: UIButton) {
        
        
        SVProgressHUD.showSuccess(withStatus: "Your review submited successfully")
        
        
        
        let alert = UIAlertController(title: "Submit", message: "Your review submited successfully.", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //self.dismiss(animated: true, completion: nil)
            self.performSegueToReturnBack()
        } ))
        //self.present(alert, animated: true, completion: nil)
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
