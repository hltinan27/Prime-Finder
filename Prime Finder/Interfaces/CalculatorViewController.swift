//
//  CalculatorViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController,UIGestureRecognizerDelegate {
  @IBOutlet weak var copyPasteHolder : UIView!
  @IBOutlet weak var display : Display!
  var tapGestureRecognizer : UITapGestureRecognizer!
  
  private var text : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
      self.tapGestureRecognizer.delegate = self
      self.view.addGestureRecognizer(self.tapGestureRecognizer)
        
    }
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    let touchPoint = touch.location(in: self.view)
    var isTouchedToTheDisplay : Bool = false
    if let aView = self.view.hitTest(touchPoint, with: nil){
      print(aView)
      if aView.isKind(of: Display.self){
        print("Touched to Displayyy")
        isTouchedToTheDisplay = true
      }
    }
    if isTouchedToTheDisplay {
      if self.copyPasteHolder.isUserInteractionEnabled {
        concealCopyPasteHolder()
      }else{
        revealCopyPasteHolder()
      }
    }else{
      concealCopyPasteHolder()
    }
    
    return false
  }
  
  func revealCopyPasteHolder(){
    self.copyPasteHolder.alpha = 1.0
    self.copyPasteHolder.isUserInteractionEnabled = true
  }
  func concealCopyPasteHolder(){
    UIView.animate(withDuration: 0.35, animations: {
      self.copyPasteHolder.alpha = 0.0
    }) { (completed) in
      self.copyPasteHolder.isUserInteractionEnabled = false
    }
  }
  @IBAction func copyAction(_ sender: UIButton) {
  }
  @IBAction func pasteAction(_ sender: UIButton) {
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
