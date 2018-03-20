//
//  CalculatorViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  @IBAction func buttomTouchDownAction(_ sender: UIButton) {
    print("Tag \(sender.tag)")
  }
  
  @IBAction func buttonTouchUpInsideOutsideCancel(_ sender: UIButton) {
  }
  
}
