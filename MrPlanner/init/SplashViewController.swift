//
//  SplashViewController.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/16/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import RevealingSplashView


class SplashViewController: UIViewController {

    
    //@IBOutlet weak var logo: 
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        
        
        revealingSplashView.animationType = .twitter
        revealingSplashView.backgroundColor = .gray
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
        
        // Do any additional setup after loading the view.
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
