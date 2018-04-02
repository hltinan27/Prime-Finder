//
//  CopyToClipBoardDialog.swift
//  Prime Finder
//
//  Created by inan on 29.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CopyToClipBoardDialog: UIView, UIGestureRecognizerDelegate {
  @IBOutlet var clipBoardDialog:UIView!
  @IBOutlet var dialogLabel:UILabel!
  private var tapGestureRecognizer:UITapGestureRecognizer!
  private var currentValue:String = ""
  override func awakeFromNib() {
     super.awakeFromNib()
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.bounds = self.clipBoardDialog.bounds
    gradientLayer.anchorPoint = .zero
    gradientLayer.colors = [
    UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1).cgColor,
    UIColor.white.cgColor
    ]
    gradientLayer.cornerRadius = 20.0
    self.clipBoardDialog.layer.insertSublayer(gradientLayer, at: 0)
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    self.tapGestureRecognizer.delegate = self
    self.addGestureRecognizer(self.tapGestureRecognizer)
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    let touchPoint = touch.location(in: self)
    if let aView = self.hitTest(touchPoint, with: nil){
      if aView.isKind(of: UIView.self){
        if aView.tag == 1{
          removeSelfWith(copy: true)
        }else{
          removeSelfWith(copy: false)
        }
      }
      
    }
    return false
  }
  
  func removeSelfWith(copy: Bool){
    if copy {
      if self.currentValue != ""{
        UIPasteboard.general.string = currentValue
      }
      if let labelFont = UIFont(name: "ArialRoundedMTBold", size: 18){
        let labelFontAttributes:[NSAttributedStringKey : Any] = [
          NSAttributedStringKey.font : labelFont,
          NSAttributedStringKey.foregroundColor : UIColor.green
        ]
        let labelFontMutableAttributes = NSMutableAttributedString(string: "Copied", attributes: labelFontAttributes)
        
        self.dialogLabel.attributedText = labelFontMutableAttributes
      }
    }else {
        if let labelFont = UIFont(name: "ArialRoundedMTBold", size: 18){
          let labelFontAttributes:[NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : labelFont,
            NSAttributedStringKey.foregroundColor : UIColor.red
          ]
          let labelFontMutableAttributes = NSMutableAttributedString(string: "Canceled", attributes: labelFontAttributes)
          
          self.dialogLabel.attributedText = labelFontMutableAttributes
    }
      }
    UIView.animate(withDuration: 0.35, delay: 0.35, options: UIViewAnimationOptions.curveLinear, animations: {
      self.alpha = 0.0
    }) { (completed) in
       self.isUserInteractionEnabled = false
    }
  }
  
  func initiateDialogWith(string : String){
    self.currentValue = string
    self.isUserInteractionEnabled = true
    
    if let labelFont = UIFont(name: "ArialRoundedMTBold", size: 18){
      let allString = "Tap here to coppy\n\"\(string)\"\nto clipboard"
      let labelFontAttributes:[NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : labelFont,
        NSAttributedStringKey.foregroundColor : UIColor.darkGray
      ]
      let labelFontMutableAttributes = NSMutableAttributedString(string: allString, attributes: labelFontAttributes)
      
      labelFontMutableAttributes.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 16.0/255, green: 140.0/255, blue: 194.0/255, alpha: 1.0), range: (allString as NSString).range(of: string))
      self.dialogLabel.attributedText = labelFontMutableAttributes
    }
    
 
    if self.alpha == 0 {
      UIView.animate(withDuration: 0.35, animations: {
        self.alpha = 1.0
      })
    }
  }

}
