//
//  FirstViewVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import Kingfisher


class FirstViewVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    var effectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    
    
    func blurBackground() {
        let blurEffect = UIBlurEffect(style: .light)
        effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(effectView)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        removeBlur()
    }
    func removeBlur() {
        effectView.removeFromSuperview()
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
