//
//  CalculatorViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
  @IBOutlet weak var display: Display!
  private var text : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  var abc : Int = 0
  @IBAction func buttomTouchDownAction(_ sender: UIButton) {
    print("Tag \(sender.tag)")
    if sender.tag >= 0 && sender.tag < 10 {
      self.display.insertText("\(sender.tag)")
    }else if sender.tag == 10 {
      self.display.deleteAll()
    }else if sender.tag == 11 {
      self.display.deleteBackward()
    }else if sender.tag == 12 {
      self.display.updatesModes(mode: Modes(rawValue: abc)!)
      if abc > 5 {
        abc = 0
      }else{
        abc += 1
      }
      
    }
  }
  
  @IBAction func buttonTouchUpInsideOutsideCancel(_ sender: UIButton) {
  }
  
}
