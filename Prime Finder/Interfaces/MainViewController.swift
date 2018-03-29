//
//  MainViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CalculatorViewControllerDelegate, ResultViewControllerDelegate {

  let storyBoard = UIStoryboard(name: "Main", bundle: .main)
  var calculatorViewController : CalculatorViewController!
  var resultViewController : ResulViewController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addCalculatorViewControllerAsAChildViewController()
      
    }
  override var traitCollection: UITraitCollection{
    if UIDevice.current.userInterfaceIdiom == .pad{
      if UIDevice.current.orientation.isLandscape{
        return UITraitCollection(traitsFrom: [
          UITraitCollection(horizontalSizeClass: .regular),
          UITraitCollection(verticalSizeClass: .compact)
          ])
      }
    }
    return super.traitCollection
  }
  
  func addCalculatorViewControllerAsAChildViewController(){
    
    self.calculatorViewController = self.storyBoard.instantiateViewController(withIdentifier: "calculatorViewController") as! CalculatorViewController
    self.calculatorViewController.delegate = self
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
  
  func addResultViewControllerAsAChildViewController(WithResults: CalculationResult){
    if self.resultViewController == nil{
      self.resultViewController = self.storyBoard.instantiateViewController(withIdentifier : "resultViewController") as! ResulViewController
      self.resultViewController.delegate = self
      self.resultViewController.view.alpha = 0.0
      self.resultViewController.calculationResult = WithResults
      self.addChildViewController(self.resultViewController)
      self.resultViewController.view.translatesAutoresizingMaskIntoConstraints = false
      self.view.insertSubview(self.resultViewController.view, at: 2)
      self.view.addConstraints([
        NSLayoutConstraint(item: self.resultViewController.view, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.resultViewController.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.resultViewController.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
        
        NSLayoutConstraint(item: self.resultViewController.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
      self.view.layoutIfNeeded()
      UIView.animate(withDuration: 0.35, animations: {
        self.resultViewController.view.alpha = 1.0
      })
    }
  }
  
  //MARK: CAlculatorViewController Delegate
  
  func calculatorViewController(showResults: CalculationResult) {
    addResultViewControllerAsAChildViewController(WithResults: showResults)
  }
  //MARK: ResultViewController Delegate
  
  func resultViewControllerDismiss() {
    if self.resultViewController != nil {
      UIView.animate(withDuration: 0.35, animations: {
        self.resultViewController.view.alpha = 0.0
      }, completion: { (completed) in
        self.resultViewController.view.removeFromSuperview()
        self.resultViewController.removeFromParentViewController()
        self.resultViewController.delegate = nil
        self.resultViewController = nil
      })
    }
  }

  

}
