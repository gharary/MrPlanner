//
//  EmailVerifyVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import KWVerificationCodeView

class EmailVerifyVC: UIViewController {

    
    //Mark: - IBOutlets
    @IBOutlet var verificationCode: KWVerificationCodeView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    //Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        verificationCode.delegate = self
        verificationCode.clear()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if verificationCode.hasValidCode() {
            let alert = UIAlertController(title: "Success", message: "Code is \(verificationCode.getVerificationCode())", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowMain", sender: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }


}

extension EmailVerifyVC: KWVerificationCodeViewDelegate {
    
    func didChangeVerificationCode() {
        submitButton.isEnabled = verificationCode.hasValidCode()
    }
}
