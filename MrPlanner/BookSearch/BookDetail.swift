//
//  searchVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class BookDetail: UIViewController {

    
    
    @IBOutlet weak var bookDesc: UITextView!
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    var bookTitleStr:String = ""
    var author:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        
        
        bookTitle.text = bookTitleStr
        bookAuthor.text = author
        

    }
    

    
    

}



