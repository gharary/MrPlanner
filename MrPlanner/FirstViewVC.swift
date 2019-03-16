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
    
    

    @IBOutlet weak var imageShow: ImageSlideshow!
    
    
    var effectView: UIVisualEffectView!

    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initImageShow()
        // Do any additional setup after loading the view.
    }
    
    func initImageShow() {
        //let view: PageIndicatorView =
        imageShow.circular = true
        //imageShow.pageIndicator = LabelPageIndicator()
        imageShow.setImageInputs([AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!,
                                  KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!])
        
        imageShow.slideshowInterval = 10
        //Custom View Page Indicator
        
        
        imageShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
    }
    @IBAction func goodReadsLoginBtn(_ sender: UIButton) {
        /*
        let popup = goodreadLoginVC.create()
        let sbPopup = SBCardPopupViewController(contentViewController: popup)
        sbPopup.show(onViewController: self)
        //sbPopup.show(onViewController: self)
        
        */
        //print("Login Clicked!")
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstView", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "goodreadLoginVC")
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .crossDissolve
        vc.preferredContentSize = CGSize(width: 300, height: 400)
        //self.view.
        let popover = vc.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .down
        
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        
        
        blurBackground()
        self.present(vc, animated: true, completion: nil)
 
        
        
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
