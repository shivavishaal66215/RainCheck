//
//  ResultViewController.swift
//  RainCheck
//
//  Created by Vishaal S on 27/12/21.
//

import UIKit

class ResultViewController: UIViewController{
    
    var message = ""
    
    
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad(){
        super.viewDidLoad()
        resultLabel.text = message
    }
}
