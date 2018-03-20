//
//  MainViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  let storyBoard = UIStoryboard(name: "Main", bundle: .main)
  var calculatorViewController : CalculatorViewController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addCalculatorViewControllerAsAChildViewController()
      
    }
  
  func addCalculatorViewControllerAsAChildViewController(){
    
    self.calculatorViewController = self.storyBoard.instantiateViewController(withIdentifier: "calculatorViewController") as! CalculatorViewController
    self.addChildViewController(self.calculatorViewController)
    self.calculatorViewController.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.insertSubview(self.calculatorViewController.view, at: 1)
    self.view.addConstraints([
      NSLayoutConstraint(item: self.calculatorViewController.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.calculatorViewController.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.calculatorViewController.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: self.calculatorViewController.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
      ])
    self.view.layoutIfNeeded()
    
  }
  
  

  

}
