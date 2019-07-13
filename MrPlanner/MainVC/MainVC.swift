//
//  MainVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/26/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import AlamofireImage
import Kingfisher
import SwiftyJSON


class MainVC: UIViewController{

    @IBOutlet weak var slideShow: ImageSlideshow!
    
    @IBOutlet weak var popularBookUIView: UIView!
    @IBOutlet weak var popularReaderUIView: UIView!
    
   
    
    override func viewDidLoad() {
        self.title = "Home"
        
        loadImage()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
        
    
    private func loadImage() {
        let image = UIImage(named: "schdule")
        //slideShow.setImageInputs(Placeholder(image))
        
        slideShow.setImageInputs([
            ImageSource(image: image!),
            AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", placeholder: image)!,
            KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!
            
            ])
        
        slideShow.slideshowInterval = 3
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.backgroundColor = UIColor(hex: 0xA0C0C4 )
        slideShow.layer.cornerRadius = 5
        
        
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
