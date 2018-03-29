//
//  CalculatorViewController.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

protocol CalculatorViewControllerDelegate : class {
  func calculatorViewController(showResults : CalculationResult)
}

class CalculatorViewController: UIViewController,UIGestureRecognizerDelegate,PrimeEngineDelegate {
  weak var delegate : CalculatorViewControllerDelegate!
  @IBOutlet weak var innerHolder: UIView!
  @IBOutlet weak var copyPasteHolder : UIView!
  @IBOutlet weak var display : Display!
  var tapGestureRecognizer : UITapGestureRecognizer!
  
  private var text : String = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    self.tapGestureRecognizer.delegate = self
    self.view.addGestureRecognizer(self.tapGestureRecognizer)
    PrimeEngine.sharedInstance.delegate = self
    
    
  }
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    let touchPoint = touch.location(in: self.view)
    var isTouchedToTheDisplay : Bool = false
    if let aView = self.view.hitTest(touchPoint, with: nil){
      if aView.isKind(of: Display.self){
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
    if !PrimeEngine.sharedInstance.isThereAnyOperationProgress() && self.innerHolder.isUserInteractionEnabled{
      self.copyPasteHolder.alpha = 1.0
      self.copyPasteHolder.isUserInteractionEnabled = true
    }
   
  }
  func concealCopyPasteHolder(){
    UIView.animate(withDuration: 0.35, animations: {
      self.copyPasteHolder.alpha = 0.0
    }) { (completed) in
      self.copyPasteHolder.isUserInteractionEnabled = false
    }
  }
  @IBAction func copyAction(_ sender: UIButton) {
    let currentValue = self.display.getCurrentValue()
    UIPasteboard.general.string = "\(currentValue)"
  }
  @IBAction func pasteAction(_ sender: UIButton) {
    if let pasteBoarding = UIPasteboard.general.string {
      var trimmedString = pasteBoarding.trimmingCharacters(in: .whitespacesAndNewlines)
      trimmedString = trimmedString.replacingOccurrences(of: " ", with: "")
      if trimmedString.count > 0 {
        let aSet = CharacterSet(charactersIn: "0123456789").inverted
        if trimmedString.rangeOfCharacter(from: aSet) == nil {
          if trimmedString.count <= self.display.maxDigitCount {
            self.display.replaceText(trimmedString)
          }
        }else {
          errorStimulation()
        }
        
      }
    }
  }
  
  func errorStimulation(){
    let shakeGap = ceil(self.view.bounds.size.width * 0.025)
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 3
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.view.center.x - shakeGap, y: self.view.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.view.center.x + shakeGap, y: self.view.center.y))
    self.view.layer.add(animation, forKey: "position")
  }
  
  var abc : Int = 0
  @IBAction func buttomTouchDownAction(_ sender: UIButton) {
    sender.alpha = 0.6
    if self.innerHolder.isUserInteractionEnabled {
      self.innerHolder.isUserInteractionEnabled = false
    }
    // MARK: Çalışan herhangibir işlem var mı
    if PrimeEngine.sharedInstance.isThereAnyOperationProgress() {
      if sender.tag == 10 {
        PrimeEngine.sharedInstance.cancelCurrentOperation()
      }
    }else{
      
      if sender.tag >= 0 && sender.tag < 10 {
        self.display.insertText("\(sender.tag)")
        self.display.updatePrimeIndicator(indicator: .PINull)
      }else if sender.tag == 10 {
        self.display.deleteAll()
        self.display.updatePrimeIndicator(indicator: .PINull)
      }else if sender.tag == 11 {
        self.display.deleteBackward()
        self.display.updatePrimeIndicator(indicator: .PINull)
      }else if sender.tag == 12 {
        if self.display.currentMode.rawValue < 6 {
          if let nextMode = Modes(rawValue: self.display.currentMode.rawValue + 1){
            self.display.currentMode = nextMode
          }
        }else{
          self.display.currentMode = .MValidator
        }
        self.display.updatesModes(mode: self.display.currentMode)
      }else if sender.tag == 13 {
        self.display.updatePrimeIndicator(indicator: .PINull)
        self.display.updateCalculationIndicator(indicator: .CI0)
        if self.display.currentMode == .MValidator {
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTIsPrime, start: currentValueOnDisplay, repetetions: 0, completionHandler: { (result) in
            if let calculationResult = result {
              if calculationResult.isStartValuePrime{
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                self.display.updatePrimeIndicator(indicator: .PINotPrime)
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
            }
            
          })
        }else if self.display.currentMode == .MNext1{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindNext, start: currentValueOnDisplay, repetetions: 1, completionHandler: { (result) in
            if let calculationResult = result {
              var isNextValueApproite : Bool = false
              if let firstValue = calculationResult.calculatedValues.first{
                let firstValueInString = "\(firstValue)"
                if firstValueInString.count <= self.display.maxDigitCount{
                  self.display.replaceText(firstValueInString)
                  self.display.updatePrimeIndicator(indicator: .PIPrime)
                }else{
                  isNextValueApproite = true
                }
              }
              if !isNextValueApproite{
                if calculationResult.isStartValuePrime {
                  self.display.updatePrimeIndicator(indicator: .PIPrime)
                }else{
                  self.display.updatePrimeIndicator(indicator: .PINotPrime)
                }
              }
              
            }
            
          })
          
        }else if self.display.currentMode == .Mnext10{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindNext, start: currentValueOnDisplay, repetetions: 10, completionHandler: { (result) in
            if let calculationResult = result {
              if calculationResult.isStartValuePrime {
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                self.display.updatePrimeIndicator(indicator: .PINotPrime)
              }
              if calculationResult.calculatedValues.count > 0 {
                self.delegate.calculatorViewController(showResults: calculationResult)
   
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
              
            }
          })
          
          
        }else if self.display.currentMode == .Mnext100{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindNext, start: currentValueOnDisplay, repetetions: 100, completionHandler: { (result) in
            if let calculationResult = result {
              if calculationResult.isStartValuePrime {
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                self.display.updatePrimeIndicator(indicator: .PINotPrime)
              }
              if calculationResult.calculatedValues.count > 0 {
                
                self.delegate.calculatorViewController(showResults: calculationResult)
                
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
              
            }
          })
          
          
        }else if self.display.currentMode == .MPrev1{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindPrev, start: currentValueOnDisplay, repetetions: 1, completionHandler: { (result) in
            if let calculationResult = result {
              
              if let firstValue = calculationResult.calculatedValues.first{
                let firstValueInString = "\(firstValue)"
                self.display.replaceText(firstValueInString)
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                if calculationResult.isStartValuePrime {
                  self.display.updatePrimeIndicator(indicator: .PIPrime)
                }else{
                  self.display.updatePrimeIndicator(indicator: .PINotPrime)
                }
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
              
            }
            
          })
          
          
        }else if self.display.currentMode == .MPrev10{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindPrev, start: currentValueOnDisplay, repetetions: 10, completionHandler: { (result) in
            if let calculationResult = result {
              
              if let firstValue = calculationResult.calculatedValues.first{
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                self.display.updatePrimeIndicator(indicator: .PINotPrime)
              }
              if calculationResult.calculatedValues.count > 0 {
                if calculationResult.calculatedValues.count < 2 {
                  if let firstValue = calculationResult.calculatedValues.first{
                    let firstValueInString = "\(firstValue)"
                    self.display.replaceText(firstValueInString)
                    self.display.updatePrimeIndicator(indicator: .PIPrime)
                  }
                }else{
                  
                  self.delegate.calculatorViewController(showResults: calculationResult)
                }
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
              
            }
            
          })
          
        }else if self.display.currentMode == .Mprev100{
          let currentValueOnDisplay = self.display.getCurrentValue()
          PrimeEngine.sharedInstance.processWith(type: .PPTFindPrev, start: currentValueOnDisplay, repetetions: 10, completionHandler: { (result) in
            if let calculationResult = result {
              
              if let firstValue = calculationResult.calculatedValues.first{
                self.display.updatePrimeIndicator(indicator: .PIPrime)
              }else{
                self.display.updatePrimeIndicator(indicator: .PINotPrime)
              }
              if calculationResult.calculatedValues.count > 0 {
                if calculationResult.calculatedValues.count < 2 {
                  if let firstValue = calculationResult.calculatedValues.first{
                    let firstValueInString = "\(firstValue)"
                    self.display.replaceText(firstValueInString)
                    self.display.updatePrimeIndicator(indicator: .PIPrime)
                  }
                }else{
                  
                  self.delegate.calculatorViewController(showResults: calculationResult)
                }
              }
              self.display.updateCalculationIndicator(indicator: .CINull)
              
            }
            
          })
        }
        
      }
    }
  }
  
  @IBAction func buttonTouchUpInsideOutsideCancel(_ sender: UIButton) {
    self.innerHolder.isUserInteractionEnabled = true
    sender.alpha = 1.0
  }
  
  func primeEngine(updateUI completed: Int) {
    var calcIndicator:CalculationIndicator = .CI0
    switch completed {
    case 10:
      calcIndicator = .CI10
    case 20:
      calcIndicator = .CI20
    case 30:
      calcIndicator = .CI30
    case 40:
      calcIndicator = .CI40
    case 50:
      calcIndicator = .CI50
    case 60:
      calcIndicator = .CI60
    case 70:
      calcIndicator = .CI70
    case 80:
      calcIndicator = .CI80
    case 90:
      calcIndicator = .CI90
    case 100:
      calcIndicator = .CI100
    default:
      calcIndicator = .CI0
    }
    self.display.updateCalculationIndicator(indicator: calcIndicator)
  }
  
  
}

