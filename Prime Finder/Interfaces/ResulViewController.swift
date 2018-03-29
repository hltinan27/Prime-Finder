//
//  ResulViewController.swift
//  Prime Finder
//
//  Created by inan on 26.04.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
protocol ResultViewControllerDelegate:class {
  func resultViewControllerDismiss()
}

class ResulViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  @IBOutlet weak var tableView: UITableView!
  weak var delegate:ResultViewControllerDelegate!
  
  var calculationResult : CalculationResult!
  var calculatedValues : [UInt64]!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.tableView.separatorInset = .zero
      self.tableView.separatorStyle = .singleLine
      self.tableView.separatorColor = .white

    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let calcRes = self.calculationResult{
      self.calculatedValues = calcRes.calculatedValues
      self.calculatedValues.insert(calcRes.startValue, at: 0)
    }
  }

  @IBAction func dismissAction(_ sender: UIBarButtonItem) {
    self.delegate.resultViewControllerDismiss()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.calculatedValues.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell : UITableViewCell!
    var calculatedValue = "\(calculatedValues[indexPath.row])"
    calculatedValue.applyDecimal(seperator: "'")
    if indexPath.row == 0 {
      if let calcRes  = self.calculationResult {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomCell1
        var startNumberCellDetailLabelText:String = "Start Value"
        if calcRes.isStartValuePrime{
          startNumberCellDetailLabelText += " is a prime number"
          cell1?.backgroundColor = UIColor(red: 12.0/255, green: 150.0/155, blue: 30.0/255, alpha: 0.7)
        }else{
           startNumberCellDetailLabelText += " is not a prime number"
           cell1?.backgroundColor = UIColor(red: 171.0/255, green: 20.0/155, blue: 9.0/255, alpha: 0.7)
        }
        cell1?.mainLabel.text = calculatedValue
        cell1?.detailLabel.text = startNumberCellDetailLabelText
        cell = cell1
        
      }
      
    }else{
      let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomCell2
      cell2?.orderLabel.text = "\(indexPath.row)-"
      cell2?.valueLabel.text = calculatedValue
      
      cell = cell2
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  


}
