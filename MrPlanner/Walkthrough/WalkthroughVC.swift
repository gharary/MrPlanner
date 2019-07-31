//
//  WalkthroughVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/9/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class WalkthroughVC: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var skipBtn: UIButton!
    
    var slides:[Slide] = [];
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(true, forKey: "walkthroughSeen")
        
        scrollView.delegate = self
        
        GoodreadsService.sharedInstance.logoutOfGoodreadsAccount()
        
        slides = createSlides()
        setupSlideScrollViews(slides: slides)
        
        pageControll.numberOfPages = slides.count
        pageControll.currentPage = 0
        view.bringSubviewToFront(pageControll)
        view.bringSubviewToFront(skipBtn)
        
        // Do any additional setup after loading the view.
    }
    
    var window: UIWindow?
    
    @IBAction func skipButton(_ sender: UIButton) {
        
        /*
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "remember_token")
        defaults.set(nil, forKey: "password")
        
        if  defaults.object(forKey: "remember_token") != nil || defaults.object(forKey: "password") != nil  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Tabbar")
            self.removeFromParent()
            self.present(initialViewController, animated: true, completion: nil)
        
        } else {
         */
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            vc.firstLogin = true
        
            
        
        
            self.present(vc, animated: true, completion: nil)
        
        //}
      
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "1")
        slide1.labelTitle.text = "Leaders Are Readers"
        slide1.labelDesc.text = "Today a reader, tomorrow a leader."
        
        
        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "2")
        slide2.labelTitle.text = "A Reader As A Friend"
        slide2.labelDesc.text = "Never trust anyone who has not brought a book with them."
        
        let slide3: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "3")
        slide3.labelTitle.text = "How Others Reads"
        slide3.labelDesc.text = "You can never get a cup of tea large enough or a book long enough to suit me."
        
        
        let slide4: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "4")
        slide4.labelTitle.text = "George R.R. Martin:"
        slide4.labelDesc.text = "A reader lives a thousand lives before he dies . . . The man who never reads lives only one."
        
        let slide5: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.imageView.image = UIImage(named: "5")
        slide5.labelTitle.text = "Ready To Plan Your Reading?"
        slide5.labelDesc.text = "Whatever you had planned for 2019, add more fifty books to it within the help of MrPlanner, it is going to worth it to try."
        
        return [slide1, slide2, slide3, slide4, slide5]
        
    }

    
    func setupSlideScrollViews(slides: [Slide]) {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
            
        }
    }

}
extension WalkthroughVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        //Vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        

        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControll.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControll.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControll.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControll.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    func fade(fromRed: CGFloat,
                  fromGreen: CGFloat,
                  fromBlue: CGFloat,
                  fromAlpha: CGFloat,
                  toRed: CGFloat,
                  toGreen: CGFloat,
                  toBlue: CGFloat,
                  toAlpha: CGFloat,
                  withPercentage percentage: CGFloat) -> UIColor {
            
            let red: CGFloat = (toRed - fromRed) * percentage + fromRed
            let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
            let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
            let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
            
            // return the fade colour
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
}
