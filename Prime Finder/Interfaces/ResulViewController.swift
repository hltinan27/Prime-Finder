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
  func resultsViewController(initiateActivityVC activtyVC: UIActivityViewController)
}

class ResulViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

  @IBOutlet weak var copyToClipBoardDialog: CopyToClipBoardDialog!
  @IBOutlet weak var navigationBar: UINavigationBar!
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
      if let navBarItem = self.navigationBar.topItem {
      self.calculatedValues = calcRes.calculatedValues
      self.calculatedValues.insert(calcRes.startValue, at: 0)
      var title:String = ""
      if calcRes.processType == .PPTFindNext{
        title = "Next"
      }else if calcRes.processType == .PPTFindPrev{
        title = "Previous"
      }
      title += " \(calcRes.calculatedValues.count) Primes"
        navBarItem.title = title
      
      }
      self.tableView.reloadData()
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
        var startNumberCellDetailLabelText:String = "Start value"
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
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row > 0 {
      let calculateValue = "\(self.calculatedValues[indexPath.row])"
      if self.copyToClipBoardDialog != nil {
        self.copyToClipBoardDialog.initiateDialogWith(string: calculateValue)
      }
    }
    
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    if indexPath.row == 0 {
      return false
    }
    return true
  }
  
  @IBAction func shareAction(_ sender: UIBarButtonItem) {
    if let calcRes = self.calculationResult{
      var sharingString: String = "Start value is \(calcRes.startValue)\n"
      if calcRes.isStartValuePrime{
        sharingString += "and it's a prime number.\n\n"
      }else{
        sharingString += "and it's not a prime number.\n\n"
      }
      
      if calcRes.processType == .PPTFindNext {
        sharingString += "Next"
      }else if calcRes.processType == .PPTFindPrev {
        sharingString += "Previous"
      }
      sharingString += " \(calcRes.calculatedValues.count) prime numbers are listed bellow.\n\n"
      for (i, prime) in calcRes.calculatedValues.enumerated() {
        sharingString += "\(i + 1)) \(prime)\n"
      }
      sharingString += "\nCreated by Prime Finder Application\n"
      
      let activtyVC = UIActivityViewController(activityItems: [sharingString], applicationActivities: nil)
      activtyVC.setValue("Prime numbers", forKey: "subject")
      activtyVC.excludedActivityTypes = [
        UIActivityType.saveToCameraRoll,
        UIActivityType.assignToContact,
        UIActivityType.addToReadingList,
        UIActivityType.openInIBooks,
        UIActivityType.postToFlickr,
        UIActivityType.postToTencentWeibo,
        UIActivityType.postToVimeo,
        UIActivityType.postToWeibo
      ]
      activtyVC.modalPresentationStyle = .popover
      activtyVC.popoverPresentationController?.barButtonItem = sender
      self.delegate.resultsViewController(initiateActivityVC: activtyVC)
      
  }
  
  }

}
